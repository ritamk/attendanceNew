import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AnandaAttendance/models/attendance_model.dart';
import 'package:AnandaAttendance/models/employee_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

final CollectionReference _adminCollection =
    FirebaseFirestore.instance.collection("Admin");

final CollectionReference _employeeCollection =
    FirebaseFirestore.instance.collection("Employee");

final CollectionReference _empAttCollection =
    FirebaseFirestore.instance.collection("EmpAttendance");

final DateTime dateNow = DateTime.now();

final Reference _reference =
    FirebaseStorage.instance.ref().child("${dateNow.month}${dateNow.year}");

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final String sth_wrong = "Something went wrong, please try again";

  Future<dynamic> setEmployeeData(DetailedEmployeeModel employee) async {
    try {
      String eid = employee.name.substring(0, 3).toUpperCase() +
          employee.uid.substring(0, 3).toUpperCase() +
          employee.uid.substring(15, 18).toUpperCase();
      try {
        await _empAttCollection.doc(uid).set({
          "attendance": {},
          "loc": employee.loc,
          "eID": eid,
        });
      } catch (e) {
        print("setEmpAttData: ${e.toString()}");
        return -2;
      }
      return await _employeeCollection.doc(uid).set({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "eID": eid,
        "loc": employee.loc,
        "store": employee.store,
      });
    } catch (e) {
      print("setEmployeeData: ${e.toString()}");
      return -1;
    }
  }

  Future<String?> eIDFromUID() async {
    try {
      DocumentSnapshot doc = await _employeeCollection.doc(uid).get();
      return doc.get("eID");
    } catch (e) {
      print("eIDFromUID: ${e.toString()}");
      return null;
    }
  }

  Future<dynamic> employeeDetail() async {
    try {
      DocumentSnapshot snap = await _employeeCollection.doc(uid).get();
      return snap.data();
    } catch (e) {
      print("employeeDetail: ${e.toString()}");
      return null;
    }
  }

  Future<GeoPoint?> getGeoLocation(String store) async {
    try {
      final DocumentSnapshot docsnap =
          await _adminCollection.doc("settings").get();
      final Map stores = docsnap.get("stores");
      return stores[store];
    } catch (e) {
      print("getGeoLocation: ${e.toString()}");
      throw sth_wrong;
    }
  }

  Future<bool> updateGeoLocation(double lat, double lon) async {
    try {
      await _employeeCollection.doc(uid).update({
        "loc": GeoPoint(lat, lon),
      });
      return true;
    } catch (e) {
      print("updateGeoLocation: ${e.toString()}");
      return false;
    }
  }

  Future<void> attendanceReporting(EmpAttendanceModel empAttendance) async {
    String date =
        empAttendance.time!.toDate().toString().substring(0, 10).trim();

    try {
      if (empAttendance.reporting!) {
        try {
          await _empAttCollection.doc(uid).update({
            "attendance.$date": FieldValue.arrayUnion([
              {
                "time": empAttendance.time,
                "photo": empAttendance.photo,
                "reporting": true,
                "geoloc": empAttendance.geoloc,
                "loc": empAttendance.loc,
              }
            ]),
          });
        } catch (e) {
          await _empAttCollection.doc(uid).update({
            "attendance": FieldValue.arrayUnion([
              {
                date: {
                  "time": empAttendance.time,
                  "photo": empAttendance.photo,
                  "reporting": true,
                  "geoloc": empAttendance.geoloc,
                  "loc": empAttendance.loc,
                }
              }
            ]),
          });
        }
      } else {
        try {
          await _empAttCollection.doc(uid).update({
            "attendance.$date": FieldValue.arrayUnion([
              {
                "time": empAttendance.time,
                "photo": empAttendance.photo,
                "reporting": false,
                "geoloc": empAttendance.geoloc,
                "loc": empAttendance.loc,
              }
            ]),
          });
        } catch (e) {
          await _empAttCollection.doc(uid).update({
            "attendance": FieldValue.arrayUnion([
              {
                date: {
                  "time": empAttendance.time,
                  "photo": empAttendance.photo,
                  "reporting": false,
                  "geoloc": empAttendance.geoloc,
                  "loc": empAttendance.loc,
                }
              }
            ]),
          });
        }
      }
    } catch (e) {
      print("attendanceReporting: ${e.toString}");
      return null;
    }
  }

  Future<List?> attendanceSummary(DateTime time) async {
    String date = time.toString().substring(0, 10);
    try {
      DocumentSnapshot snap = await _empAttCollection.doc(uid).get();

      return snap.get("attendance.$date");
    } catch (e) {
      print("attendanceSummary: ${e.toString()}");
      return List.empty();
    }
  }

  Future<String> uploadPicture(File file) async {
    try {
      final Reference ref =
          _reference.child("photos${Timestamp.now().toDate()}");
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("uploadPicture: ${e.toString()}");
      throw sth_wrong;
    }
  }
}
