import 'dart:core';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:Noted/src/db/notes_database.dart';
import 'package:Noted/src/editor.dart';
import 'package:Noted/src/model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:Noted/src/note_card.dart';
import 'material-theme (1)/color_schemes.g.dart';

StreamController streamController = StreamController();
StreamController homeSetStateController = StreamController();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<Note> notes;
  bool isLoading = false;
  bool isGridView = true;

  AnimationController? _gridScalingAnim;
  AnimationController? _listScalingAnim;

  @override
  void initState() {
    super.initState();
    refreshNotes();

    _listScalingAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _gridScalingAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..forward();

    streamController.stream.listen((event) {
      refreshNotes();
    });

    homeSetStateController.stream.listen((event) {
      setState(() {
        Timer(
            const Duration(
              seconds: 1,
            ),
            () => refreshNotes());
      });
    });
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    _listScalingAnim?.dispose();
    _gridScalingAnim?.dispose();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
    // notes.forEach((element) {
    //   print(element.id);
    // });

    filterFavesFromNot(true);
    isFavesEmpty = filterFavesFromNot(true).isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: GoogleFonts.nunito(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: () {
              NotesDatabase.instance.deleteTable();
                  refreshNotes();
            }, child: const Text("Delete Notes")),
            IconButton(
              onPressed: () {
                setState(() {
                  if (isGridView) {
                    isGridView = false;
                    _gridScalingAnim!.reverse();
                    Timer(const Duration(milliseconds: 300), () {
                      _listScalingAnim?.forward();
                    });
                  } else {
                    isGridView = true;
                    _listScalingAnim!.reverse();
                    Timer(const Duration(milliseconds: 300), () {
                      _gridScalingAnim?.forward();
                    });
                  }
                });
              },
              isSelected: isGridView,
              icon: const Icon(Icons.grid_view_rounded),
              selectedIcon: const Icon(Icons.list_rounded),
            )
          ],
          title: Transform.translate(
            offset: const Offset(-22.0, 0.0),
            child: Text("Notes",
                style: GoogleFonts.nunito(color: lightColorScheme.primary)
            ),
          ),
        ),
        drawer: const Drawer(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty? Center(
              child: Transform.translate(
          offset: const Offset(0,-40),
                child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Text('¯\\_(ツ)_/¯', style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                    fontSize: 50
                ),),
                SizedBox(height: 15,),
                Text('No Notes Here :)\nCreate one by tapping the\n "+ Create" button below', textAlign: TextAlign.center,)
          ],
        ),
              ),
            )
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12),
            child: Column(
              children: [
                isFavesEmpty? Container() : const Align(alignment: Alignment.centerLeft,child: Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 15),
                  child: Text("Favorites"),
                )),
                isGridView? favoritesGrid(): favoritesList(),
                isFavesEmpty? const SizedBox(): const SizedBox(
                  height: 15,
                ),
                const Align(alignment: Alignment.centerLeft,child: Padding(
                  padding: EdgeInsets.only(top: 10,left: 12, bottom: 15),
                  child: Text("Others"),
                )),
                isGridView? notesGrid(): notesList(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => Editor()));
          },
          heroTag: 0,
          label: const Text("Create"),
          icon: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }



  Widget favoritesList() {
    return isFavesEmpty? Container() : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filterFavesFromNot(true).length,
      itemBuilder: (context, index) {
        final note = filterFavesFromNot(true).reversed.toList()[index];

        return Hero(
          tag: note.id!,
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween(begin: 0.001, end: 1.0).animate(CurvedAnimation(
                  parent: _listScalingAnim!, curve: Curves.bounceInOut)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, __, ___) => Editor(
                      note: note,
                    ),
                  ));
                },
                child: NoteCard(note: note, index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget notesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filterFavesFromNot(false).length,
      itemBuilder: (context, index) {
        final note = filterFavesFromNot(false).reversed.toList()[index];

        return Hero(
          tag: note.id!,
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween(begin: 0.001, end: 1.0).animate(CurvedAnimation(
                  parent: _listScalingAnim!, curve: Curves.bounceInOut)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, __, ___) => Editor(
                      note: note,
                    ),
                  ));
                },
                child: NoteCard(note: note, index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget listView() {
    return Column(
      children: [
        isFavesEmpty? Container() : const Align(alignment: Alignment.centerLeft,child: Padding(
          padding: EdgeInsets.only(left: 12, bottom: 15),
          child: Text("Favorites"),
        )),
        favoritesList(),
        isFavesEmpty? const SizedBox(): const SizedBox(
          height: 15,
        ),
        ScaleTransition(
          scale: Tween(
            begin: 0.001,
            end: 1.0
          ).animate(CurvedAnimation(parent: _listScalingAnim!, curve: Curves.bounceInOut)),
          child: const Align(alignment: Alignment.centerLeft,child: Padding(
            padding: EdgeInsets.only(top: 10,left: 12, bottom: 15),
            child: Text("Others"),
          )),
        ),
        notesList(),
      ],
    );
  }

  List<Note> filterFavesFromNot(bool getFavorite) {
    List<Note> faves = [];
    List<Note> notFaves = [];
    for (var i = 0; i < notes.length; i++) {
      if (notes.toList()[i].isFavorite) {
        faves.add(notes.toList()[i]);
      } else {
        notFaves.add(notes.toList()[i]);
      }
    }

    if (getFavorite) {
      return faves;
    } else {
      return notFaves;
    }
  }

  Widget favoritesGrid() {
    return isFavesEmpty? Container()
        : MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filterFavesFromNot(true).length,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = filterFavesFromNot(true).reversed.toList()[index];

        return Hero(
          tag: note.id!,
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween(begin: 0.001, end: 1.0).animate(CurvedAnimation(
                  parent: _gridScalingAnim!, curve: Curves.bounceInOut)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, __, ___) => Editor(
                      note: note,
                    ),
                  ));
                },
                child: NoteCard(note: note, index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget notesGrid() {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filterFavesFromNot(false).length,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = filterFavesFromNot(false).reversed.toList()[index];

        return Hero(
          tag: note.id!,
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween(begin: 0.001, end: 1.0).animate(CurvedAnimation(
                  parent: _gridScalingAnim!, curve: Curves.bounceInOut)),
              child: NoteCard(note: note, index: index),
            ),
          ),
        );
      },
    );
  }
  bool isFavesEmpty = true;
  Widget gridView() {

    return Column(
      children: [
        isFavesEmpty? Container() : const Align(alignment: Alignment.centerLeft,child: Padding(
          padding: EdgeInsets.only(left: 12, bottom: 15),
          child: Text("Favorites"),
        )),
        favoritesGrid(),
        isFavesEmpty? const SizedBox(): const SizedBox(
          height: 15,
        ),
        ScaleTransition(
          scale: Tween(
              begin: 0.001,
              end: 1.0
          ).animate(CurvedAnimation(parent: _gridScalingAnim!, curve: Curves.bounceInOut)),
          child: const Align(alignment: Alignment.centerLeft,child: Padding(
            padding: EdgeInsets.only(top: 10,left: 12, bottom: 15),
            child: Text("Others"),
          )),
        ),
        notesGrid(),
      ],
    );
  }
}
