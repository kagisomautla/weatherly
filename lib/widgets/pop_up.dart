import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/widgets/text.dart';

Future<dynamic> popupControl({
  required BuildContext context,
  required String message,
  required String title,
  GestureTapCallback? onConfirm,
}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            TextWidget(
              text: title,
              size: TextSize.md,
              isBold: true,
            )
          ],
        ),
        backgroundColor: Colors.white,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cPadding),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cPadding),
          ),
          1,
        ),
        contentPadding: EdgeInsets.all(cPadding),
        actionsPadding: EdgeInsets.zero,
        content: TextWidget(
          text: message,
        ),
        actions: [
          GestureDetector(
            onTap: onConfirm,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(cPadding),
                child: Center(
                  child: TextWidget(
                    text: 'Yes',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            height: 0,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(cPadding),
                  bottomRight: Radius.circular(cPadding),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(cPadding),
                child: Center(
                  child: TextWidget(
                    text: 'No',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    },
  );
}
