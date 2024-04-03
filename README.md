# Weatherly

A Flutter project for displaying weather forecasts and current conditions.

## Overview

Weatherly is a Flutter application designed to provide users with up-to-date weather information for their location and other selected areas. It utilizes various APIs to fetch weather data, including OpenWeatherMap and Google Maps Geocoding.

## Conventions and Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern for organizing code and separating concerns. It emphasizes modularity, maintainability, and scalability.

## Third-Party Dependencies

The following third-party packages are used in this project:

- `provider: ^6.1.2`: For state management using the Provider package.
- `flutter_dotenv: ^5.1.0`: For loading environment variables from a `.env` file.
- `google_fonts: ^6.2.1`: For using custom fonts in the application.
- `intl: ^0.19.0`: For internationalization and localization support.
- `shared_preferences: ^2.0.15`: For storing simple key-value pairs persistently.
- `http: ^1.2.1`: For making HTTP requests to fetch weather data.
- `mockito: ^5.4.4`: For mocking HTTP client in tests.
- `flutter_secure_storage: ^9.0.0`: For securely storing sensitive data.
- `font_awesome_flutter: ^10.7.0`: For displaying icons using the Font Awesome library.
- `geolocator: ^11.0.0`: For retrieving the device's current location.
- `google_maps_flutter: ^2.6.0`: For integrating Google Maps into the application.
- `google_places_flutter: ^2.0.8`: For autocomplete search functionality using Google Places API.
- `lottie: ^3.1.0`: For displaying animations using Lottie files.
- `cached_network_image: ^3.3.1`: For caching network images for improved performance.
- `connectivity_plus: ^6.0.1`: For checking network connectivity status.
- `dartz: ^0.10.1`: For functional programming constructs like Either and Option.
- `percent_indicator: ^4.2.3`: For displaying progress indicators.

## Installation

To install the dependencies, run the following command in the terminal:

```bash
flutter pub get
```

## Testing the Application
```bash
flutter test
```

This command will execute all unit tests located in the test directory of the project.

## Running the Application
### On Physical Devices
To install and run the application on physical devices, follow these steps:

- Ensure that you have a compatible Flutter development environment set up.
- Connect your device to your computer using a USB cable.
- Enable USB debugging on your device.
- Run the following command to build and install the application on your device:

```bash
flutter run
```

### On Emulators/Simulators
To run the application on emulators or simulators, follow these steps:

- Launch your preferred emulator or simulator from your development environment.
- Run the following command to build and install the application:

```bash
flutter run
```

## Additional Notes
Ensure that you have valid API keys for services like OpenWeatherMap and Google Maps. Add these keys to your .env file located in the assets/env/ directory.
Check the documentation of each package for usage instructions and additional features.
For testing, consider using tools like flutter_test for unit and widget tests, and mockito for mocking dependencies.
Follow best practices for error handling, performance optimization, and security when implementing features and integrating with external services.
