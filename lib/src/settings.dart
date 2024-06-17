import "package:flutter/material.dart";

enum ColorModes { light, dark, system }

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 12),
                  child: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            Expanded(
              child: ListTile(
                title: Text("Color Mode"),
                trailing: DropdownMenu<ColorModes>(
                  initialSelection: ColorModes.system,
                  onSelected: (value) {
                    debugPrint(value.toString());
                  },
                  dropdownMenuEntries: ColorModes.values
                      .map((e) => DropdownMenuEntry<ColorModes>(
                            value: e,
                            label: e.name,
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
