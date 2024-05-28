import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/material-theme (1)/color_schemes.g.dart';

import 'src/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotesApp());


}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, textTheme: const TextTheme(), fontFamily: GoogleFonts.nunito().fontFamily),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      );

  }
}
