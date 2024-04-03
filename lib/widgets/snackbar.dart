import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/widgets/text.dart';

//create a snackbar widget
void snackBar({
  required String message,
  required BuildContext context,
}) {
  final theme = Provider.of<ThemeViewModel>(context, listen: false);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: TextWidget(
        text: message,
        color: Colors.white,
      ),
      backgroundColor: theme.color,
    ),
  );
}
