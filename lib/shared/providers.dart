import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<double> geofencingRangeProvider =
    StateProvider<double>((ref) => 0.001);

final StateProvider<List<String>> storesListProvider =
    StateProvider<List<String>>((ref) => <String>[]);

final StateProvider<List<GeoPoint>> geopointListProvider =
    StateProvider<List<GeoPoint>>((ref) => <GeoPoint>[]);
