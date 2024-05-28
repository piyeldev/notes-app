import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;
  final Clip clipBehavior = Clip.none;
  final VoidCallback initState;

  const CustomContainer({
    super.key,
    this.width,
    this.height,
    this.decoration,
    this.margin = EdgeInsets.zero,
    this.alignment,
    this.constraints,
    this.child,
    this.color,
    this.foregroundDecoration,
    this.padding = EdgeInsets.zero,
    this.transform,
    this.transformAlignment,
    required this.initState
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      margin: widget.margin,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      alignment: widget.alignment,
      color: widget.color,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      constraints: widget.constraints,
      child: widget.child,
    );
  }
}


