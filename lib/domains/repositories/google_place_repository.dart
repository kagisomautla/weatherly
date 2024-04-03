import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/models/Coordinates.dart';

abstract class GooglePlaceRepository extends ChangeNotifier {
  Future<Either<Failure, List<Prediction>>> getPlaceByPlaceID(String placeID);
  Future<Either<Failure, List<Prediction>>> getPlaceByPlaceBySearch(String placeID);
}
