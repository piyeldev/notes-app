import 'package:Noted/src/custom_listTile.dart';
import 'package:Noted/src/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  bool noteActive = true;
  bool taskActive = false;

  
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 18, top: 10),
                  child: Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Noted !",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: IconButton(onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
                          }, icon:  const Icon(Icons.settings_rounded, size: 20,)))
                      ],
                    ),
                  ),
                  ),
              const Divider(
                color: Colors.black45,
                endIndent: 24,
                indent: 12,
              ),
              CustomListTile(icon: Icons.sticky_note_2_rounded, text: "Notes", active: true,),
              CustomListTile(icon: Icons.task_alt_rounded, text: "Tasks", active: false,),
            ],
          ),
        );
  }
}