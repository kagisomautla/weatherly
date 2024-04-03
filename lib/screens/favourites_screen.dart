import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:weatherly/screens/no_internet_connection_screen.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/snackbar.dart';
import 'package:weatherly/widgets/text.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  List<LocationModel> favourites = [];
  bool loadingScreen = false;
  bool loadingWeather = false;
  bool showWeather = false;
  WeatherModel? selectedWeatherData;

  init() async {
    final locations = await LocalStorageService.getFavouriteLocationsData();
    setState(() {
      favourites = locations;
    });

    print('favourites: ${favourites.length}');
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      backgroundColor: themeViewModel.color,
      appBar: AppBar(
        backgroundColor: themeViewModel.color ?? Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: TextWidget(
          text: 'Favorites',
          color: Colors.white,
          isBold: true,
          size: TextSize.md,
        ),
      ),
      body: weatherViewModel.isOnline
          ? loadingScreen
              ? FocusDetector(
                  onVisibilityGained: () {
                    init();
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoaderWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'Loading your favorite locations...',
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(top: 10),
                  child: favourites.isEmpty
                      ? Center(
                          child: TextWidget(
                            text: 'No favorite locations found.',
                            color: themeViewModel.color != null ? Colors.white : Colors.grey,
                          ),
                        )
                      : SingleChildScrollView(
                          key: UniqueKey(),
                          child: Column(
                            children: [
                              loadingWeather
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          LoaderWidget(
                                            color: kSunnyBackgroundColor,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextWidget(
                                            text: 'Loading your favorite locations...',
                                          ),
                                        ],
                                      ),
                                    )
                                  : showWeather
                                      ? ShowWeatherComponent(
                                          selectedWeatherData: selectedWeatherData,
                                          backgroundColor: themeViewModel.color!,
                                          icon: selectedWeatherData!.icon,
                                        )
                                      : Container(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: favourites.map((location) {
                                    return Dismissible(
                                      background: Container(color: Colors.grey),
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) async {
                                        int idx = favourites.indexWhere((e) => e.name == location.name);

                                        if (idx > -1) {
                                          setState(() {
                                            showWeather = false;
                                          });
                                          await locationViewModel.removeLocationFromFavourites(location: location, locations: favourites);
                                        }

                                        await init();
                                        snackBar(context: context, message: '${location.name} removed from favorites.');
                                      },
                                      child: Card(
                                        child: ListTile(
                                          onTap: () async {
                                            print('fetching weather data for ${location.name}');
                                            await weatherViewModel.onSearch(
                                              searchItem: Prediction(
                                                lat: location.coordinates.latitude.toString(),
                                                lng: location.coordinates.longitude.toString(),
                                              ),
                                              context: context,
                                            );
                                          },
                                          leading: FaIcon(
                                            FontAwesomeIcons.mapLocation,
                                            color: kSunnyBackgroundColor,
                                          ),
                                          trailing: FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Colors.red,
                                          ),
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text: location.name,
                                                size: TextSize.md,
                                              ),
                                              Row(
                                                children: [
                                                  TextWidget(
                                                    text: 'lat:',
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  TextWidget(
                                                    text: location.coordinates.latitude,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TextWidget(
                                                    text: 'lng:',
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  TextWidget(
                                                    text: location.coordinates.longitude,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()),
                              SizedBox(
                                height: 20,
                              ),
                              TextWidget(
                                text: 'Swipe to unfavorite.',
                                color: themeViewModel.color != null ? Colors.white : Colors.grey,
                              )
                            ],
                          ),
                        ),
                )
          : NoInternetConnectionScreen(),
    );
  }
}

class ShowWeatherComponent extends StatelessWidget {
  const ShowWeatherComponent({
    super.key,
    required this.selectedWeatherData,
    required this.backgroundColor,
    required this.icon,
  });

  final WeatherModel? selectedWeatherData;
  final Color backgroundColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      color: backgroundColor,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != ''
                  ? CachedNetworkImage(
                      imageUrl: 'https://openweathermap.org/img/w/$icon.png',
                      height: 100,
                      width: 100,
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              TextWidget(
                text: selectedWeatherData?.main,
                color: Colors.white,
              ),
              TextWidget(
                text: selectedWeatherData?.temperature!.temp,
                color: Colors.white,
                size: TextSize.lg,
                isBold: true,
              ),
              SizedBox(
                height: 20,
              ),
              FaIcon(
                FontAwesomeIcons.mapPin,
                color: Colors.white,
              ),
              TextWidget(
                text: '${selectedWeatherData?.description}',
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
