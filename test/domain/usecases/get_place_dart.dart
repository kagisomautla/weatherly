import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherly/domains/usecases/get_google_place.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetGooglePlaceUseCase getGooglePlaceUseCase;
  late MockGooglePlaceRepository mockGooglePlaceRepository;

  setUp(() {
    mockGooglePlaceRepository = MockGooglePlaceRepository();
    getGooglePlaceUseCase = GetGooglePlaceUseCase(mockGooglePlaceRepository);
  });

  final validTestPlace = [
    Prediction(
      description: 'Minneapolis, MN, USA',
      placeId: 'ChIJv0pY2hUys1IRv3dH5dK5KvY',
    ),
  ];
  final invalidTestPlace = [];
  final validTestSearch = 'Minneapolis';
  final invalidTestSearch = 'xyz';

  test('should return an valid place using an invalid place ID', () async {
    // Given
    when(mockGooglePlaceRepository.getPlaceByPlaceBySearch(validTestSearch)).thenAnswer((_) async => Right(validTestPlace));

    // When
    final result = await getGooglePlaceUseCase.executeGetPlaceBySearch(validTestSearch);
    // Then
    expect(result, Right(validTestPlace));
  });
}
