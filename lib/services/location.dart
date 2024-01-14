import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';



class Location {
  late Position _position;
  void requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      // Location permission granted, proceed with your location-related code.
      print('Location permission granted');
    } else {
      // Handle the case where the user denied location permission.
      print('Location permission denied');
    }
  }

  void askPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (await Geolocator.checkPermission() ==
        LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  // Launches coordinates in GMaps
  void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open $url';
    }
  }

  Future<Map> getLocation() async {
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('co-ordinates for location is $_position');
    // launchUrl(Uri.parse('https://www.google.com/maps/place/${_position.latitude},${_position.longitude}'));
    Map location = {'langitude': _position.latitude , 'longitude': _position.longitude};
    return location;
  }
  void redirect(double langitude , double longitude) async {
    launchUrl(Uri.parse('https://www.google.com/maps/place/$langitude,$longitude'));
  }
}

