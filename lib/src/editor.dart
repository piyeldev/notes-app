import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Noted/src/db/notes_database.dart';
import 'package:Noted/src/home.dart';
import 'package:Noted/src/model/note.dart';
import 'package:image_picker/image_picker.dart';

class Editor extends StatefulWidget {
  Note? note;
  Editor({this.note, Key? key}) : super(key: key);
  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  final TextEditingController textEditor = TextEditingController();
  final TextEditingController titleTextFielfController =
      TextEditingController();
  bool isSaved = false;
  bool viewMode = true;

  Note? rilNote;
  late int number;
  late String title;
  late String note;
  late DateTime lastSavedDate;
  late DateTime createdTime;
  bool isFavorite = false;
  String img = "";

  int characterCount = 0;

  Widget deleteNote() => widget.note == null
      ? Container()
      : IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await NotesDatabase.instance.delete(widget.note?.id ?? 0);
            homeSetStateController.add("");
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );

  AnimationController? _scaleAnimController;

  int id = 0;
  @override
  void initState() {
    super.initState();
    readNote();

    if (widget.note?.id == null) {
      viewMode = false;
    } else {
      viewMode = true;
    }

    _scaleAnimController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200),
    );

    characterCount = textEditor.text.length;
    textEditor.addListener(() {
      setState(() {
        characterCount = textEditor.text.length;
      });
    });
  }

  @override
  void dispose() {
    
    if (_scaleAnimController!.isAnimating) {
      _scaleAnimController!.stop();
      _scaleAnimController!.dispose();
    }
    titleTextFielfController.dispose();
    textEditor.dispose();
    super.dispose();
  }

  void readNote() {
    id = widget.note?.id ?? 0;
    title = widget.note?.title ?? '';
    note = widget.note?.note ?? '';
    isFavorite = widget.note?.isFavorite ?? false;
    number = widget.note?.number ?? 0;
    lastSavedDate = widget.note?.lastSavedDate ?? DateTime.now();
    createdTime = widget.note?.createdTime ?? DateTime.now();

    titleTextFielfController.text = title;
    textEditor.text = note;

    if (widget.note?.image != null) {
      setState(() {
        imgPath = widget.note?.image ?? "";
      });
    }
  }

  void addOrUpdateNote() {
    bool isUpdating = widget.note != null;

    if (isUpdating) {
      updateNote();
    } else {
      addNote();
    }
  }

  void updateNote() async {
    debugPrint("updating note..");
    final noted = widget.note!.copy(
        number: number,
        title: titleTextFielfController.text,
        note: textEditor.text,
        lastSavedDate: DateTime.now(),
        createdTime: DateTime.now(),
        isFavorite: isFavorite,
        image: imgPath);

    await NotesDatabase.instance.update(noted);
    streamController.add("");
  }

  Note? notedd;
  void addNote() async {
    debugPrint("adding note..");

    if ((textEditor.text.isEmpty && titleTextFielfController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Empty Note"),
        action: SnackBarAction(
            label: "Close",
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      ));
    } else {
      final noted = Note(
        number: number,
        title: titleTextFielfController.text,
        note: textEditor.text,
        lastSavedDate: DateTime.now(),
        createdTime: DateTime.now(),
        isFavorite: isFavorite,
        image: imgPath ?? "",
      );

      await NotesDatabase.instance.create(noted);
      streamController.add("");
      isSaved = true;

      final notes = await NotesDatabase.instance.readAllNotes();
      final newNote = notes[notes.length -1];

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Editor(
                    note: newNote,
                  )));

      if (Navigator.of(context).canPop()) {
        debugPrint("refreshed");
      }

    }
  }

  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            ScaleTransition(
              scale: Tween(begin: 0.0001, end: 1.0).animate(CurvedAnimation(
                  parent: _scaleAnimController!, curve: Curves.bounceInOut)),
              // save button
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      addOrUpdateNote();
                      isChanged = false;
                      Timer(const Duration(milliseconds: 300),
                          () => _scaleAnimController!.reverse());
                    });
                  },
                  icon: const Icon(Icons.check_rounded)),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite ? isFavorite = false : isFavorite = true;
                    addOrUpdateNote();
                    streamController.add("");
                  });
                },
                isSelected: isFavorite,
                selectedIcon: const Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
                icon: const Icon(
                  FontAwesomeIcons.heart,
                )),
            deleteNote(),
            const SizedBox(
              width: 10,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Hero(
          tag: widget.note?.id ?? 0,
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      imgPath!= null
                          ? InkWell(
                              onTap: () => showSelectCameraOrGallery(),
                              child: Image.file(File(imgPath!))
                              )
                          : Container(),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextField(
                          readOnly: viewMode,
                          controller: titleTextFielfController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (_) {
                            isChanged = true;
                            if (!_scaleAnimController!.isCompleted) {
                              _scaleAnimController?.forward();
                            }
                          },
                          onTap: () {
                            
                            if (viewMode){
                              setState(() {
                                viewMode = false;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Title",
                              hintStyle: TextStyle(
                                fontSize: 23,
                              )),
                          style: const TextStyle(
                              fontSize: 23, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          onTap: () {
                            
                            viewMode = false;
                          },
                          onChanged: (text) {
                            if (!_scaleAnimController!.isCompleted) {
                              _scaleAnimController?.forward();
                            }
                          },
                          readOnly: viewMode,
                          controller: textEditor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write your note here...",
                              hintStyle: GoogleFonts.nunito()),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      viewMode
                          ? Container()
                          : IconButton(
                              onPressed: () => showSelectCameraOrGallery(),
                              icon: const Icon(FontAwesomeIcons.image)),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: const Alignment(0.6, 0.2),
                          child: Text(
                              "Edited: ${DateFormat.yMMMd().add_jm().format(widget.note?.lastSavedDate ?? DateTime.now())} | $characterCount characters",
                              style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: Colors.black.withOpacity(0.5))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void showSelectCameraOrGallery() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12, left: 20, bottom: 4),
              child: Text("Select Source"),
            ),
            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: const Text("Image"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_rounded),
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            )
          ],
        );
      },
    );
  }

  File? image;
  String? imgPath;

  Future _pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (mounted) {
        Navigator.pop(context);
      }

      if (image == null) return;

      setState(() {
        imgPath = image.path;
      });

      _scaleAnimController!.forward();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  
}
