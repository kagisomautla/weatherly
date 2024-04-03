import 'package:flutter/material.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/widgets/text.dart';

class CurrentTemperatureWidget extends StatelessWidget {
  final String min;
  final String current;
  final String max;

  const CurrentTemperatureWidget({required this.min, required this.current, required this.max});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: cPadding, right: cPadding, top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: '$min°',
                    isBold: true,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: 'Min',
                    size: TextSize.sm,
                    color: Colors.white,
                  ),
                ],
              ),
              Column(
                children: [
                  TextWidget(
                    text: '$current°',
                    isBold: true,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: 'Current',
                    size: TextSize.sm,
                    color: Colors.white,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextWidget(
                    text: '$max°',
                    isBold: true,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: 'Max',
                    size: TextSize.sm,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }
}
