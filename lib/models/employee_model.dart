import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String uid;

  EmployeeModel({required this.uid});
}

class DetailedEmployeeModel {
  final String uid;
  final String name;
  final String eID;
  final String email;
  final GeoPoint? loc;
  final String? store;

  DetailedEmployeeModel({
    required this.uid,
    required this.name,
    required this.eID,
    required this.email,
    required this.loc,
    required this.store,
  });
}
