// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:notesappflutter/src/editor.dart';
// import 'package:notesappflutter/src/material-theme%20(1)/color_schemes.g.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class ItemsRender extends ConsumerStatefulWidget {
//   final Stream? stream;
//   const ItemsRender({super.key, this.stream});
//   @override
//   ConsumerState<ItemsRender> createState() => ItemsRenderState();
// }
//
// class ItemsRenderState extends ConsumerState<ItemsRender> {
//   List<String> oddNotesKeys = [];
//   List<String> evenNotesKeys = [];
//
//   void listSharedPreferencesData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map<String, dynamic> allData =
//         sharedPreferences.getKeys().fold<Map<String, dynamic>>(
//       {},
//       (previousValue, key) {
//         previousValue[key] = sharedPreferences.get(key);
//         return previousValue;
//       },
//     );
//
//     Iterable<MapEntry<String, dynamic>> allDataToList =
//         allData.entries.toList().reversed;
//
//     Map<String, dynamic> allNotes = Map.fromEntries(allDataToList);
//
//
//     setState(() {
//       orderNotesBasedOnODDorEVEN(allData);
//     });
//   }
//
//   Future<List<String>> previewNote(String key) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final data = sharedPreferences.get(key);
//     List<dynamic> dataToJson = jsonDecode(data.toString());
//
//     String note = dataToJson[0]["note"];
//     String title = dataToJson[0]["title"];
//     String lastSavedDate = dataToJson[0]["lastSavedDate"];
//
//     List<String> contents = [title, note, lastSavedDate];
//     return contents;
//   }
//
//   void orderNotesBasedOnODDorEVEN(Map notes) {
//     List<String> evenNotes = [];
//     List<String> oddNotes = [];
//     for (var i = notes.length; i > 0; i--) {
//       if (i.remainder(2) == 0) {
//         evenNotes.add(notes.keys.toList()[i - 1]);
//       } else {
//         oddNotes.add(notes.keys.toList()[i - 1]);
//       }
//     }
//
//     evenNotesKeys = evenNotes;
//     oddNotesKeys = oddNotes;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     widget.stream?.listen((event) {
//       listSharedPreferencesData();
//       setState(() {});
//     });
//     listSharedPreferencesData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Wrap(
//           children: [
//             Column(
//               children: List.generate(oddNotesKeys.reversed.length, (index) {
//                 return InkWell(
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Editor(
//                                 noteID:
//                                     oddNotesKeys.reversed.toList()[index])));
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 10, right: 8),
//                     width: 150,
//                     height: 200,
//                     decoration: BoxDecoration(
//                         color: lightColorScheme.primaryContainer,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: FutureBuilder(
//                         future:
//                             previewNote(oddNotesKeys.reversed.toList()[index]),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Text("Please wait...");
//                           } else if (snapshot.hasError) {
//                             return Text("Error: ${snapshot.error}");
//                           } else {
//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.only(
//                                       left: 13, right: 13, top: 10),
//                                   child: Text(
//                                     snapshot.data![0].length > 25
//                                         ? snapshot.data![0].substring(0, 25) +
//                                             '...'
//                                         : snapshot.data![0],
//                                     style: GoogleFonts.nunito(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.only(
//                                         left: 13, right: 13, top: 3, bottom: 5),
//                                   child: Text(
//                                       snapshot.data![1],
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 6,
//                                       style: GoogleFonts.nunito(
//                                           fontWeight: FontWeight.w300,
//                                           fontSize: 14.5,
//                                           color:
//                                               Colors.black.withOpacity(0.75)),
//                                     ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                   child: Align(
//                                     alignment: const Alignment(0.70, -1),
//                                     child: Text(
//                                       snapshot.data![2],
//                                       style: GoogleFonts.nunito(
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: 10,
//                                           color:
//                                               Colors.black.withOpacity(0.75)),
//                                     ),
//                                   ),
//                                 ), const Spacer()
//                               ],
//                             );
//                           }
//                         }),
//                   ),
//                 );
//               }),
//             ),
//             Column(
//               children: List.generate(evenNotesKeys.reversed.length, (index) {
//                 return InkWell(
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Editor(
//                                 noteID:
//                                     evenNotesKeys.reversed.toList()[index])));
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 10, right: 8),
//                     height: 200,
//                     width: 150,
//                     decoration: BoxDecoration(
//                         color: lightColorScheme.primaryContainer,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: FutureBuilder(
//                         future:
//                         previewNote(evenNotesKeys.reversed.toList()[index]),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Text("Please wait...");
//                           } else if (snapshot.hasError) {
//                             return Text("Error: ${snapshot.error}");
//                           } else {
//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.only(
//                                       left: 13, right: 13, top: 10),
//                                   child: Text(
//                                     snapshot.data![0].length > 25
//                                         ? snapshot.data![0].substring(0, 25) +
//                                         '...'
//                                         : snapshot.data![0],
//                                     style: GoogleFonts.nunito(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 13, right: 13, top: 3),
//                                       child: Text(
//                                         snapshot.data![1],
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 6,
//                                         style: GoogleFonts.nunito(
//                                             fontWeight: FontWeight.w300,
//                                             fontSize: 14.5,
//                                             color:
//                                             Colors.black.withOpacity(0.75)),
//                                       )),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                   child: Align(
//                                     alignment: const Alignment(0.70, -1),
//                                     child: Text(
//                                       snapshot.data![2],
//                                       style: GoogleFonts.nunito(
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: 10,
//                                           color:
//                                           Colors.black.withOpacity(0.75)),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             );
//                           }
//                         }),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
