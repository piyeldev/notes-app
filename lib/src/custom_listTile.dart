import 'package:Noted/src/material-theme%20(1)/color_schemes.g.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final bool? active;
  final String? text;
  final VoidCallback? onTap;
  final TextStyle? style;
  final double? iconSize;
  final IconData? icon;
  CustomListTile(
      {super.key,
      this.icon,
      this.iconSize,
      this.active,
      this.text,
      this.onTap,
      this.style});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  Widget trailingArrowStyle(bool active) {
    return active
        ? const Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.black87,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: widget.active != null && widget.active!
          ? lightColorScheme.primaryContainer:Colors.white,
      height: 50,
      child: InkWell(
        splashColor: Colors.black12,
        onTap: () {
          debugPrint("hello!");
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            children: [
              widget.icon != null?
              Icon(
                widget.icon ,
                size: widget.iconSize ?? 24,
              ): Container(),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    widget.text ?? "",
                    style: widget.style ?? TextStyle(fontSize: 16),
                  )),
              Spacer(),
              widget.active != null && widget.active!? trailingArrowStyle(true):Container()
            ],
          ),
        ),
      ),
    );
  }
}
