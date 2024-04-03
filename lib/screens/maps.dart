import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/google_maps_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/text.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // late GoogleMapController mapController;
  LatLng? _center;
  bool loading = true;
  Set<Marker> _favoritedLocationsMarkers = Set<Marker>();
  bool isGoTo = false;
  LocationModel? location;
  int numberOfFaveLocations = 0;
  int indexOfLocation = 1;
  List<LocationModel> locations = [];
  LocationModel? selectedLocation;

  init() async {
    await LocalStorageService.getFavouriteLocationsData().then((e) {
      setState(() {
        locations = e;
        numberOfFaveLocations = e.length;

        //print locations
        for (var location in locations) {
          print('LOCATION: ${location.toJson()}');
        }
      });
    });

    await LocalStorageService.getLocationData().then((e) {
      setState(() {
        selectedLocation = e;
      });
    });

    //get user current location
    final CoordinatesViewModel coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
    if (!mounted) return;
    await coordinatesViewModel.fetchCurrentPosition(context);

    setState(() {
      if (numberOfFaveLocations > 0) {
        for (var location in locations) {
          print('Adding markers... ${location.coordinates.latitude}, ${location.coordinates.longitude}');

          int index = locations.indexOf(location);

          _favoritedLocationsMarkers.add(
            Marker(
              markerId: MarkerId(index.toString()),
              position: LatLng(location.coordinates.latitude, location.coordinates.longitude),
              infoWindow: InfoWindow(
                title: location.name,
              ),
            ),
          );
        }
      }
      _favoritedLocationsMarkers.add(
        Marker(
          markerId: MarkerId(
            'currentLocation',
          ),
          position: LatLng(selectedLocation!.coordinates.latitude, selectedLocation!.coordinates.longitude),
          infoWindow: InfoWindow(
            title: 'You are here.',
          ),
        ),
      );
      _center = LatLng(selectedLocation!.coordinates.latitude, selectedLocation!.coordinates.longitude);
      loading = false;
    });

    print('_favoritedLocationsMarkers: ${_favoritedLocationsMarkers.length}');

    //print _favoritedLocationsMarkers
    for (var marker in _favoritedLocationsMarkers) {
      print('MARKER: ${marker.toJson()}');
    }
  }

  //create a method to animate the map to the next location and back
  //this method will be called when the user taps the back and forward buttons

  // void handleGoToNextAndBack() {
  //   if (indexOfLocation < numberOfFaveLocations) {
  //     setState(() {
  //       indexOfLocation++;
  //       selectedLocation = locations[indexOfLocation];
  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(selectedLocation!.coordinates.latitude, selectedLocation!.coordinates.longitude),
  //             zoom: 17,
  //           ),
  //         ),
  //       );
  //     });
  //   } else {
  //     setState(() {
  //       indexOfLocation = 0;
  //       selectedLocation = locations[indexOfLocation];
  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(selectedLocation!.coordinates.latitude, selectedLocation!.coordinates.longitude),
  //             zoom: 17,
  //           ),
  //         ),
  //       );
  //     });
  //   }
  // }

  // _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(selectedLocation!.coordinates.latitude, selectedLocation!.coordinates.longitude),
  //         zoom: 17,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    init2();
    super.initState();
  }

  @override
  void dispose() {
    // mapController.dispose();
    final GoogleMapsViewModel mapsViewModel = Provider.of<GoogleMapsViewModel>(context, listen: false);
    mapsViewModel.dispose();
    super.dispose();
  }

  init2() async {
    //call google view model
    final GoogleMapsViewModel mapsViewModel = Provider.of<GoogleMapsViewModel>(context, listen: false);
    await mapsViewModel.initialise(context: context);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeViewModel = Provider.of<ThemeViewModel>(context);
    final GoogleMapsViewModel googleMapsViewModel = Provider.of<GoogleMapsViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.mapLocation,
              color: themeViewModel.color,
            ),
            SizedBox(
              width: 10,
            ),
            TextWidget(
              text: 'Google Map',
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: loading
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
                  markers: _favoritedLocationsMarkers,
                  myLocationEnabled: true,
                ),
                Positioned(
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
                ),
                Positioned(
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
                ),
              ],
            ),
    );
  }
}
