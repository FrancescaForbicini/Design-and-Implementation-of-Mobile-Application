import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AcquirePosition {

  static AcquirePosition _acquirePosition = AcquirePosition._AcquirePositionConstructor();

  factory AcquirePosition() =>
      _acquirePosition ??= AcquirePosition._AcquirePositionConstructor();

  AcquirePosition._AcquirePositionConstructor();
  String? _currentAddress;
  Position? _currentPosition;
  bool serviceEnabled = false;

  Future<bool> getPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          _currentPosition = position;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<String?> getPosition() async {
    serviceEnabled = await getPermission();
    if (!serviceEnabled) {
      return null;
    }
    await _getCurrentPosition();
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =  '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      debugPrint(e);
    });
    return _currentAddress;
  }
}


