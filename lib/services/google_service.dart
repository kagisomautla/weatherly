import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/services/http_service.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';

class GoogleService {
  Future<List<Prediction>> searchLocation(String searchQuery) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

      final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$apiKey&type=(cities)&language=en'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<Prediction> predictions = [];
        if (jsonData['predictions'] != null) {
          predictions = [];
          jsonData['predictions'].forEach((v) {
            predictions.add(Prediction.fromJson(v));
          });
        }
        debugPrint('LOCATION SEARCH SUCCESSFULLY FETCHED... ${jsonData['predictions']}');
        return predictions;
      } else {
        debugPrint('ERROR FETCHING LOCATION SEARCH DATA: ${response.statusCode}');
        throw Exception(e);
      }
    } catch (e) {
      debugPrint('ERROR FETCHING LOCATION SEARCH DATA: $e');
      throw Exception(e);
    }
  }

  ///fetches data from the google places api based on the placeId,
  ///then returns the coordinates of the place
  Future<CoordinatesModel?> fetchPlaceDetailsUsingPlaceId(String placeId) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      final apiHost = dotenv.env['GOOGLE_MAPS_URL'];
      const String apiPath = '/maps/api/place/details/json';

      final url = Uri.https(
        apiHost!,
        apiPath,
        {
          'place_id': placeId,
          'key': apiKey,
          'fields': 'name,formatted_address,geometry,photos',
        },
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('PLACE DETAILS: $data');
        debugPrint('latitude: ${data['result']['geometry']['location']['lat']}');
        debugPrint('photo: ${data['result']['photos']?[0]?['photo_reference']}');

        //fetch weather data based on the coordinates
        if (data['result']['geometry']['location']['lat'] != null && data['result']['geometry']['location']['lng'] != null) {
          return CoordinatesModel(
            latitude: data['result']['geometry']['location']['lat'],
            longitude: data['result']['geometry']['location']['lng'],
          );
        } else {
          debugPrint('Failed to fetch place details');
          return null;
        }
      } else {
        debugPrint('Failed to fetch place details');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching place details: $e');
      throw Exception(e);
    }
  }

  ///Fetches the place details using the coordinates of the location and
  ///saves the location data in the local storage.
  ///This method should ALWAYS be called after the weathe and forecast are retrieved.
  // Future fetchPlaceDetailsUsingCoordinates({
  //   required CoordinatesModel coordinates,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final reverseGeocodingResponse = await HttpService().getPlaceDetailsUsingGeocodingCoordinates(coordinates: coordinates);

  //     if (!reverseGeocodingResponse.success) {
  //       debugPrint('Failed to fetch place details');
  //       throw Exception('Failed to fetch place details');
  //     }

  //     debugPrint('reverseGeocodingResponse.content: ${reverseGeocodingResponse.content}');

  //     final results = (reverseGeocodingResponse.content['results'] as List<dynamic>);
  //     String? city;
  //     String? photo = 'https://placehold.co/600x400'; //default incase the location does not contain any photos

  //     if (results.isNotEmpty) {
  //       final placeId = results[0]['place_id'];
  //       final placeDetailsResponse = await HttpService().getPlaceDetailsUsingPlaceId(placeId: placeId);

  //       if (!placeDetailsResponse.success) {
  //         debugPrint('Failed to fetch place details');
  //         throw Exception('Failed to fetch place details');
  //       }

  //       final addressComponents = results[0]['address_components'] as List<dynamic>;

  //       if (results[0]['photos'] != null) {
  //         final photos = results[0]['photos'] as List<dynamic>;
  //         photo = photos[0]['photo_reference'] as String;
  //       }

  //       for (final component in addressComponents) {
  //         final types = component['types'] as List<dynamic>;
  //         if (types.contains('locality')) {
  //           city = component['long_name'] as String;
  //         }
  //       }

  //       //save the location data in the local storage
  //       final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
  //       final coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
  //       final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
  //       locationViewModel.location = LocationModel(
  //         weather: weatherViewModel.weather!,
  //         name: city,
  //         coordinates: CoordinatesModel(
  //           latitude: coordinatesViewModel.coordinates!.latitude,
  //           longitude: coordinatesViewModel.coordinates!.longitude,
  //         ),
  //       );
  //       LocalStorageService.saveLocationData(location: locationViewModel.location!);

  //       //save searched location to list of searched locations
  //       await LocalStorageService.saveSearchedLocation(
  //         location: Prediction(
  //           lat: locationViewModel.location!.coordinates.latitude.toString(),
  //           lng: locationViewModel.location!.coordinates.longitude.toString(),
  //         ),
  //       );
  //     } else {
  //       throw Exception('No results found for the provided coordinates');
  //     }
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     throw Exception(e);
  //   }
  // }
}
