import 'dart:convert';

import 'package:Noted/src/editor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Noted/src/material-theme%20(1)/color_schemes.g.dart';
import 'model/note.dart';
import 'package:Noted/image_caching/image_cache.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCard({super.key, required this.note, required this.index});

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 40;
      case 1:
        return 100;
      case 2:
        return 100;
      case 3:
        return 40;
      default:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.MMMd().add_jm().format(note.lastSavedDate);
    final minHeight = getMinHeight(index);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.black),
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, __, ___) => Editor(
              note: note,
            ),
          ));
        },
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: lightColorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              note.image.isNotEmpty? Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Image(image: CacheMemoryImageProvider(note.image, base64Decode(note.image))),)
                  : Container(height: 5,),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                child: Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Text(
                  note.note,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.5,
                      color: Colors.black.withOpacity(0.75)),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: SizedBox(
                  height: 15,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w200,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.75)),
                        ),
                        note.isFavorite
                            ? const Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 15,
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  const ListNotes({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.MMMd().add_jm().format(note.lastSavedDate);
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: lightColorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),

      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              note.note,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w300,
                  fontSize: 14.5,
                  color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                note.isFavorite
                    ? const Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 13,
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  time,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
