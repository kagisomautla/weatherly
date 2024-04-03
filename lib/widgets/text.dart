import 'package:flutter/material.dart';

enum TextSize { sm, normal, md, lg, xl }

class TextWidget extends StatefulWidget {
  final dynamic text;
  final TextSize size;
  final bool? isBold;
  final Color? color;

  const TextWidget({super.key, this.text, this.size = TextSize.normal, this.isBold = false, this.color});
  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    switch (widget.size) {
      case TextSize.sm:
        textStyle = TextStyle(
          fontSize: 8,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
          overflow: TextOverflow.clip,
        );
        break;
      case TextSize.normal:
        textStyle = TextStyle(
          fontSize: 12,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
          overflow: TextOverflow.clip,
        );
        break;
      case TextSize.md:
        textStyle = TextStyle(
          fontSize: 18,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
          overflow: TextOverflow.clip,
        );
        break;
      case TextSize.lg:
        textStyle = TextStyle(
          fontSize: 22,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
          overflow: TextOverflow.clip,
        );
        break;
      case TextSize.xl:
        textStyle = TextStyle(
          fontSize: 30,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
          overflow: TextOverflow.clip,
        );
        break;
      default:
    }
    return Text(
      widget.text.toString(),
      style: textStyle,
    );
  }
}
