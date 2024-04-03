import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/snackbar.dart';

import '../viewmodels/locations_view_model.dart';

class FavouriteWidget extends StatefulWidget {
  final LocationModel location;
  const FavouriteWidget({super.key, required this.location});
  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  List<LocationModel> favourites = [];

  init() async {
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
    await locationViewModel.checkIfLocationIsFavourite(location: widget.location);
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return IconButton(
      icon: Icon(locationViewModel.isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: locationViewModel.isFavorite ? Colors.red : Colors.white),
      onPressed: () async {
        final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
        if (widget.location.name == null) {
          snackBar(message: 'Invalid place. Failed to favourite', context: context);
          return;
        }
        await locationViewModel.handleOnFavourite(location: widget.location, weather: weatherViewModel.weather!);
        init();
      },
    );
  }
}
