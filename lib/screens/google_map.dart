import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/screens/loading_screen.dart';
import 'package:weatherly/screens/no_internet_connection_screen.dart';
import 'package:weatherly/viewmodels/google_maps_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/text.dart';

class GoogleMapScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  GoogleMapScreen({Key? key, required this.navigatorKey}) : super(key: key);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  bool loading = true;

  init() async {
    //call google view model
    final GoogleMapsViewModel mapsViewModel = Provider.of<GoogleMapsViewModel>(context, listen: false);
    await mapsViewModel.initialise(context: context);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherViewModel = Provider.of<WeatherViewModel>(widget.navigatorKey.currentContext!, listen: false);
      weatherViewModel.isOnline ? init() : null;
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   final GoogleMapsViewModel mapsViewModel = Provider.of<GoogleMapsViewModel>(widget.navigatorKey.currentContext!, listen: false);
  //   mapsViewModel.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeViewModel = Provider.of<ThemeViewModel>(context);
    final GoogleMapsViewModel googleMapsViewModel = Provider.of<GoogleMapsViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeViewModel.color,
        shadowColor: Colors.black,
        elevation: 2,
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.mapLocation,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            TextWidget(
              text: 'Google Map',
              color: Colors.white,
              isBold: true,
              size: TextSize.md,
            ),
          ],
        ),
      ),
      body: !weatherViewModel.isOnline
          ? NoInternetConnectionScreen()
          : loading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoaderWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: 'Loading google map. Please wait...',
                      ),
                    ],
                  ),
                )
              : Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    GoogleMap(
                      onMapCreated: googleMapsViewModel.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: googleMapsViewModel.center,
                        zoom: 12.0,
                      ),
                      myLocationButtonEnabled: true,
                      markers: googleMapsViewModel.markers,
                      myLocationEnabled: true,
                      onLongPress: (args) async {
                        await googleMapsViewModel.onLongPress(args, context);
                      },
                    ),
                    googleMapsViewModel.favourites.isNotEmpty
                        ? Positioned(
                            left: 0,
                            child: InkWell(
                              onTap: () {
                                googleMapsViewModel.onGoForwardGoBack();
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    googleMapsViewModel.favourites.isNotEmpty
                        ? Positioned(
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                googleMapsViewModel.onGoForwardGoBack();
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
    );
  }
}
