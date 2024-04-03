import 'package:flutter/material.dart';

class DismissableKeyboardWidget extends StatelessWidget {
  final Widget? child;

  const DismissableKeyboardWidget({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(Duration(milliseconds: 300));
      },
      child: child,
    );
  }
}
