import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/screens/loading_screen.dart';
import 'package:weatherly/screens/no_internet_connection_screen.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/pop_up.dart';
import 'package:weatherly/widgets/text.dart';

class GoogleMapsScreen extends StatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late GoogleMapController mapController;
  CoordinatesModel? myLocation;
  Set<Marker> markers = {};
  List<LocationModel> favourites = [];
  bool loading = true;
  bool loadingWeatherDetails = false;
  Prediction? selectedLocation;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.initState();
  }

  init() async {
    final LocationViewModel locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    if (!mounted) return;
    //fetch user current location
    final Position position = await Geolocator.getCurrentPosition();

    if (!mounted) return;
    //get favourites from local storage
    favourites = await LocalStorageService.getFavouriteLocationsData();

    print('FAVOURITES: ${favourites.length}');

    if (!mounted) return;
    //get user current location
    setState(() {
      myLocation = CoordinatesModel(latitude: position.latitude, longitude: position.longitude);
      print('myLocation: ${myLocation!.toJson()}');

      //add location to the set of markers
      markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(
            myLocation!.latitude,
            myLocation!.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'This is your location',
          ),
        ),
      );

      //iterate through favourites and add to markers
      for (var location in favourites) {
        print('Location: ${location.toJson()}');
        if (!mounted) return;
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(location.name!),
              position: LatLng(
                location.coordinates.latitude,
                location.coordinates.longitude,
              ),
              infoWindow: InfoWindow(
                title: location.name,
                snippet: 'This is ${location.name}',
                onTap: () {
                  popupControl(
                    context: context,
                    message: 'Do you want the weather for ${location.name}?',
                    title: 'Weatherly Alert',
                    onConfirm: () {
                      setState(() {
                        locationViewModel.location = location;
                      });
                    },
                  );
                },
              ),
            ),
          );
        });
      }

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final coordinatesViewModel = Provider.of<CoordinatesViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    final ThemeViewModel themeViewModel = Provider.of<ThemeViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.black,
          backgroundColor: themeViewModel.color,
          title: TextWidget(
            text: 'Google Maps',
            color: Colors.white,
            size: TextSize.md,
          ),
        ),
        body: loadingWeatherDetails
            ? LoadingScreen()
            : weatherViewModel.isOnline
                ? !loading
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            coordinatesViewModel.coordinates!.latitude,
                            coordinatesViewModel.coordinates!.longitude,
                          ),
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        onTap: (arg) {
                          popupControl(
                            context: context,
                            message: 'You tapped on the map. Do you want the weather for this location?',
                            title: 'Weatherly Alert',
                            onConfirm: () async {
                              setState(() {
                                loadingWeatherDetails = true;
                                selectedLocation = Prediction(
                                  lat: arg.latitude.toString(),
                                  lng: arg.longitude.toString(),
                                );
                                Navigator.pop(context);
                              });

                              await weatherViewModel.onSearch(
                                searchItem: selectedLocation!,
                                context: context,
                              );

                              if (!mounted) return;
                              setState(() {
                                loadingWeatherDetails = false;
                              });
                            },
                          );
                        },
                        myLocationEnabled: true,
                        markers: markers,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
                : NoInternetConnectionScreen());
  }
}
