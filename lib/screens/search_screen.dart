import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/screens/loading_screen.dart';
import 'package:weatherly/services/google_service.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isAutoCompleteLoading = false;
  List<Prediction> predictions = [];
  Timer? searchOnStoppedTyping;
  bool isSelected = false;
  final googleService = GoogleService();
  bool loadingSearchedLocationWeather = false;
  Prediction selectedPrediction = Prediction();
  List<Prediction> searchedLocations = [];

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    //get list of saved searched locations from local storage
    await LocalStorageService.getSearchedLocationsData().then((e) {
      setState(() {
        searchedLocations = e;
      });
    });

    //check if list is empty
    print('SEARCHED LOCATIONS: ${searchedLocations.length}');
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeViewModel.color,
        elevation: 2,
        shadowColor: Colors.black,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for address',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) async {
            // Handle search query changes
            try {
              Duration duration = Duration(milliseconds: 100);
              if (searchOnStoppedTyping != null) {
                setState(() {
                  searchOnStoppedTyping!.cancel();
                });
              }
              setState(() {
                searchOnStoppedTyping = Timer(duration, () async {
                  setState(() {
                    isAutoCompleteLoading = true;
                  });

                  if (_searchController.text.isNotEmpty) {
                    final predictionResults = await GoogleService().searchLocation(value);
                    setState(() {
                      if (predictionResults.isNotEmpty) {
                        predictions = predictionResults;
                      } else {
                        predictions = [];
                      }
                      isAutoCompleteLoading = false;
                    });
                  }
                });
              });
            } catch (e) {
              debugPrint('error loading data $e');
              throw Exception(e);
            }
          },
        ),
      ),
      body: loadingSearchedLocationWeather
          ? LoadingScreen(
              message: 'Searching for weather in ${selectedPrediction.description}...',
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: themeViewModel.color,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(cPadding),
                  child: SingleChildScrollView(
                    child: isAutoCompleteLoading
                        ? Center(
                            child: SizedBox(
                              height: 150,
                              child: LoaderWidget(),
                            ),
                          )
                        : predictions.isEmpty && searchedLocations.isNotEmpty
                            ? RecentlySearched(
                                searchedLocations: searchedLocations,
                                onSearch: (e) async {
                                  setState(() {
                                    loadingSearchedLocationWeather = true;
                                    selectedPrediction = e;
                                  });

                                  FocusScope.of(context).unfocus();

                                  await weatherViewModel.onSearch(
                                    searchItem: e,
                                    context: context,
                                  );

                                  setState(() {
                                    loadingSearchedLocationWeather = false;
                                  });
                                  //close search screen
                                  Navigator.pop(context);
                                },
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _searchController.text.isNotEmpty
                                    ? (predictions.isNotEmpty
                                        ? predictions
                                            .map((e) => GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () async {
                                                    setState(() {
                                                      isAutoCompleteLoading = false;
                                                      _searchController.text = e.description ?? '';
                                                      loadingSearchedLocationWeather = true;
                                                      selectedPrediction = e;
                                                    });

                                                    FocusScope.of(context).unfocus();

                                                    await weatherViewModel.onSearch(
                                                      searchItem: e,
                                                      context: context,
                                                    );

                                                    //save searched location to list of searched locations
                                                    await LocalStorageService.saveSearchedLocation(location: e);

                                                    setState(() {
                                                      loadingSearchedLocationWeather = false;
                                                    });
                                                    //close search screen
                                                    Navigator.pop(context);
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      InkWell(
                                                        splashColor: themeViewModel.color,
                                                        child: Card(
                                                          elevation: 1,
                                                          color: themeViewModel.color!.withOpacity(0.8),
                                                          shape: ShapeBorder.lerp(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            1,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: TextWidget(
                                                              text: e.description ?? '',
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList()
                                        : [])
                                    : [],
                              ),
                  ),
                ),
              ),
            ),
    );
  }
}

class RecentlySearched extends StatefulWidget {
  final List<Prediction> searchedLocations;
  //create a callback onChanged to notify the parent widget of changes
  final ValueChanged<Prediction> onSearch;
  // final ValueChanged<Prediction> onRemove;

  const RecentlySearched({
    super.key,
    this.searchedLocations = const [],
    required this.onSearch,
  });

  @override
  State<RecentlySearched> createState() => _RecentlySearchedState();
}

class _RecentlySearchedState extends State<RecentlySearched> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.searchedLocations.take(5).map((e) {
        return Card(
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            1,
          ),
          child: ListTile(
            tileColor: Colors.white,
            textColor: Colors.black,
            splashColor: Colors.grey,
            //clear icon on trailing
            trailing: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                //remove location from list
                await LocalStorageService.removeLocationFromSearchedLocations(location: e);
                //refresh list
                setState(() {
                  widget.searchedLocations.remove(e);
                });
              },
            ),
            title: TextWidget(
              text: e.description ?? '',
              color: Colors.black,
            ),
            onTap: () {
              widget.onSearch(e);
            },
          ),
        );
      }).toList(),
    );
  }
}
