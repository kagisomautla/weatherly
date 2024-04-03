import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/screens/permissions_denied_screen.dart';
import 'package:weatherly/services/google_service.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/widgets/pop_up.dart';

class CoordinatesViewModel extends ChangeNotifier {
  CoordinatesModel? _coordinates;
  List<CoordinatesModel> _favourites = [];
  bool? _showPermissionDialog;
  bool _permissionGranted = false;

  CoordinatesModel? get coordinates => _coordinates;
  List<CoordinatesModel> get favourites => _favourites;
  bool? get showPermissionDialog => _showPermissionDialog;
  bool get permissionGranted => _permissionGranted;

  set coordinates(CoordinatesModel? value) {
    _coordinates = value;
    notifyListeners();
  }

  set favourites(List<CoordinatesModel> value) {
    _favourites = value;
    notifyListeners();
  }

  set showPermissionDialog(bool? value) {
    _showPermissionDialog = value;
    notifyListeners();
  }

  set permissionGranted(bool value) {
    _permissionGranted = value;
    notifyListeners();
  }

  void clearCoordinates() {
    _coordinates = null;
    notifyListeners();
  }

  Future<void> getPermissions(BuildContext context) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showPermissionDialog = true;
        Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionsDeniedScreen(permission: PermissionsDenied.services)));
        // throw 'Location services are disabled.';
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied) {
          _showPermissionDialog = true;
          Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionsDeniedScreen(permission: PermissionsDenied.location)));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog = true;
        Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionsDeniedScreen(permission: PermissionsDenied.deniedForever)));
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      _permissionGranted = true;

      // //at this point, permission has been granted
      // //fetch offline data
      // if (_permissionGranted) {
      //   final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      //   await weatherViewModel.fetchOfflineData(context);
      // }
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting permissions: $e');
      popupControl(context: context, message: 'Location services are needed in order for the Weatherly app to function effectively. Please switch on your location services.', title: 'Location Services Required');
      // throw e;
    }
  }

  ///fetches the current coordinates of the user
  ///returns a [CoordinatesModel] object and assigns it to the [_coordinates] variable
  Future<void> fetchCurrentPosition(BuildContext context) async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      _coordinates = CoordinatesModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (_coordinates == null) {
        throw 'Error fetching coordinates';
      }

      //you are here because the coordinates are not null
      //save the coordinate in the local storage
      await LocalStorageService.saveCoordinatesData(coordinates: _coordinates!);

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching coordinates: $e');
      throw Exception(e);
    }
  }

  Future searchForLocation(String searchQuery) async {
    try {
      final googleService = GoogleService();
      await googleService.searchLocation(searchQuery);
    } catch (e) {
      debugPrint('Error searching for location: $e');
      throw e;
    }
  }
}
