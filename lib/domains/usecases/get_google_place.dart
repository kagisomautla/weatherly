import 'package:dartz/dartz.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/domains/repositories/google_place_repository.dart';

class GetGooglePlaceUseCase {
  final GooglePlaceRepository _googlePlaceRepository;

  GetGooglePlaceUseCase(this._googlePlaceRepository);

  Future<Either<Failure, List<Prediction>>> executeGetPlaceByPlaceID(String placeId) async {
    return await _googlePlaceRepository.getPlaceByPlaceID(placeId);
  }

  Future<Either<Failure, List<Prediction>>> executeGetPlaceBySearch(String query) async {
    return await _googlePlaceRepository.getPlaceByPlaceBySearch(query);
  }
}
