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
  String? _currentAddress;
  Position? _currentPosition;
  Future<bool> askLocationPermission() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> handleLocationPermission(bool serviceEnabled, BuildContext context) async {
    LocationPermission permission;

    if (!serviceEnabled) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).PositionDisabled)));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).PositionDenied)));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).PositionSuperDenied)));
    }
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).PositionError)));
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

  Future<String?> getPosition(bool permission) async {
    if (!permission) {
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


