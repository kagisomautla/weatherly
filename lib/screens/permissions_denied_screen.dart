import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/widgets/text.dart';

enum PermissionsDenied { location, services, deniedForever }

class PermissionsDeniedScreen extends StatefulWidget {
  final PermissionsDenied permission;
  const PermissionsDeniedScreen({required this.permission});

  @override
  State<PermissionsDeniedScreen> createState() => _PermissionsDeniedScreenState();
}

class _PermissionsDeniedScreenState extends State<PermissionsDeniedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(cPadding),
        child: Column(
          children: [
            Center(
              child: TextWidget(
                text: widget.permission == PermissionsDenied.deniedForever
                    ? 'Location permissions are permanently denied, we cannot request permissions. Therefore, you cannot use the Weatherly.'
                    : widget.permission == PermissionsDenied.location
                        ? 'Location permission denied'
                        : 'Location services are disabled. Please enable them to continue.',
              ),
            ),
            widget.permission == PermissionsDenied.location
                ? Expanded(
                    child: ElevatedButton(
                      child: TextWidget(
                        text: 'Request permission',
                      ),
                      onPressed: () async {
                        final coordinatesViewModel = context.read<CoordinatesViewModel>();
                        await coordinatesViewModel.getPermissions(context);
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
