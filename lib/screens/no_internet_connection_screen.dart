import 'package:flutter/material.dart';
import 'package:weatherly/widgets/text.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final bool? showRetryButton;
  final GestureTapCallback? onRetry;
  const NoInternetConnectionScreen({super.key, this.showRetryButton = false, this.onRetry});

  @override
  Widget build(BuildContext context) {
    assert(showRetryButton! ? onRetry != null : true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //load lottie animation json
        Center(child: Image.asset('assets/images/no_internet.gif')),
        SizedBox(height: 20),
        TextWidget(
          text: 'You are not connected to the internet',
          isBold: true,
        ),
        SizedBox(height: 20),
        showRetryButton == true
            ? ElevatedButton(
                onPressed: () {
                  onRetry!();
                },
                child: TextWidget(
                  text: 'Retry',
                  isBold: true,
                ),
              )
            : Container(),
      ],
    );
  }
}
