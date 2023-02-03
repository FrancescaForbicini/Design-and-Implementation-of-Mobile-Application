import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../generated/l10n.dart';

class AcquirePosition {

  static AcquirePosition _acquirePosition = AcquirePosition._AcquirePositionConstructor();

  factory AcquirePosition() =>
      _acquirePosition ??= AcquirePosition._AcquirePositionConstructor();

  AcquirePosition._AcquirePositionConstructor();
  List<String>? _currentAddress;
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).PositionDisabled)));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).PositionDenied)));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).PositionSuperDenied)));
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

  Future<List<String>?> getPosition() async {
    serviceEnabled = await getPermission();
    if (!serviceEnabled) {
      return null;
    }
    await _getCurrentPosition();
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress = [];
      _currentAddress!.add(place.isoCountryCode!);
      _currentAddress!.add("${place.administrativeArea!} , ${place.country}");
    }).catchError((e) {
      debugPrint(e);
    });
    return _currentAddress;
  }
}


