import 'package:flutter/material.dart';
import '../src/material-theme (1)/color_schemes.g.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.surface.withOpacity(0.1),
      body: Container(
        color: Colors.white.withAlpha(155),
        child: Column(
          children: [
            Container(
              color: lightColorScheme.surface,
              height: 190,
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: 'search',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            hintText: "Search Notes",
                            contentPadding: EdgeInsets.only(top: 10),
                            prefixIcon: const Icon(Icons.search)),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
