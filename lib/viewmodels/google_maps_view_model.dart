import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/pop_up.dart';

class GoogleMapsViewModel extends ChangeNotifier {
  int indexOfLocation = 1;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  set mapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  LatLng _center = LatLng(0, 0);
  LatLng get center => _center;
  set center(LatLng newCenter) {
    _center = newCenter;
    notifyListeners();
  }

  LocationModel? _myLocation;
  LocationModel? get myLocation => _myLocation;
  set myLocation(LocationModel? location) {
    _myLocation = location;
    notifyListeners();
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> newMarkers) {
    _markers = newMarkers;
    notifyListeners();
  }

  List<LocationModel> _favourites = [];
  List<LocationModel> get favourites => _favourites;
  set favourites(List<LocationModel> newFavourites) {
    _favourites = newFavourites;
    notifyListeners();
  }

  int _numberOfFaveLocations = 0;
  int get numberOfFaveLocations => _numberOfFaveLocations;
  set numberOfFaveLocations(int value) {
    _numberOfFaveLocations = value;
    notifyListeners();
  }

  void removeMarker(LocationModel location) {
    markers.removeWhere((marker) => marker.markerId.value == location.name);
    notifyListeners();
  }

  void clearMarkers() {
    markers.clear();
    notifyListeners();
  }

  void clearFavourites() {
    favourites.clear();
    notifyListeners();
  }

  Future initialise({required BuildContext context}) async {
    await LocalStorageService.getFavouriteLocationsData().then((e) {
      _favourites = e;
      _numberOfFaveLocations = e.length;

      //print locations
      for (var location in favourites) {
        print('LOCATION: ${location.toJson()}');
      }
    });

    await LocalStorageService.getLocationData().then((e) {
      _myLocation = e;
    });

    //get user current location
    if (!context.mounted) return;
    final CoordinatesViewModel coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
    await coordinatesViewModel.fetchCurrentPosition(context);

    if (numberOfFaveLocations > 0) {
      for (var location in _favourites) {
        print('Adding markers... ${location.coordinates.latitude}, ${location.coordinates.longitude}');

        int index = _favourites.indexOf(location);

        _markers.add(
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
    _markers.add(
      Marker(
        markerId: MarkerId(
          'currentLocation',
        ),
        position: LatLng(_myLocation!.coordinates.latitude, _myLocation!.coordinates.longitude),
        infoWindow: InfoWindow(
          title: 'You are here.',
        ),
      ),
    );
    _center = LatLng(_myLocation!.coordinates.latitude, _myLocation!.coordinates.longitude);

    print('_favourites: ${_favourites.length}');

    //print _favoritedLocationsMarkers
    for (var marker in _markers) {
      print('MARKER: ${marker.toJson()}');
    }

    if (!context.mounted) return;
    notifyListeners();
  }

  //create a method to animate the map to the next location and back
  //this method will be called when the user taps the back and forward buttons

  void onGoForwardGoBack() {
    if (indexOfLocation < numberOfFaveLocations) {
      indexOfLocation++;
      _myLocation = _favourites[indexOfLocation - 1];
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_myLocation!.coordinates.latitude, _myLocation!.coordinates.longitude),
            zoom: 17,
          ),
        ),
      );
    } else {
      indexOfLocation = 1;
      _myLocation = _favourites[indexOfLocation - 1];
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_myLocation!.coordinates.latitude, _myLocation!.coordinates.longitude),
            zoom: 17,
          ),
        ),
      );
    }

    notifyListeners();
  }

  onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_myLocation!.coordinates.latitude, _myLocation!.coordinates.longitude),
          zoom: 17,
        ),
      ),
    );

    notifyListeners();
  }

  Future onLongPress(LatLng args, BuildContext context) async {
    //show dialog to add location to favourites
    popupControl(
      context: context,
      message: 'Do you want to load the weather information for this location?',
      title: 'Load Weather?',
      onConfirm: () async {
        final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);

        await weatherViewModel.onSearch(
          searchItem: Prediction(
            lat: args.latitude.toString(),
            lng: args.longitude.toString(),
          ),
          context: context,
        );
      },
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
