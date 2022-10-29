import 'package:cloud_firestore/cloud_firestore.dart';

class EmpAttendanceModel {
  final Timestamp? time;
  final bool? reporting;
  final bool? leave;
  final GeoPoint? geoloc;
  final String? loc;
  final String? photo;
  final String? eID;

  EmpAttendanceModel({
    this.time,
    this.reporting,
    this.leave,
    this.geoloc,
    this.loc,
    this.photo,
    this.eID,
  });
}
