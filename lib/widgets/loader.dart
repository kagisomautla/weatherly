import 'package:flutter/material.dart';
import 'package:weatherly/widgets/text.dart';

class LoaderWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final bool showText;

  const LoaderWidget({
    super.key,
    this.color,
    this.text,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    assert(showText == false || text != null);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: color ?? Colors.white,
            strokeWidth: 3,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        text != null
            ? TextWidget(
                text: text ?? '',
                color: color ?? Colors.white,
                isBold: true,
              )
            : Container()
      ],
    );
  }
}
