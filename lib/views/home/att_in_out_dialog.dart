import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:AnandaAttendance/views/attendance/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;

class AttendanceInOrOutDialog extends StatefulWidget {
  const AttendanceInOrOutDialog({
    Key? key,
    required this.uid,
    required this.loc,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;

  @override
  State<AttendanceInOrOutDialog> createState() =>
      _AttendanceInOrOutDialogState();
}

class _AttendanceInOrOutDialogState extends State<AttendanceInOrOutDialog> {
  bool enteredLast = false;
  bool loading = false;
  Position? coord;
  GeoPoint? geoPointCoord;
  GeoPoint? desiredCoord;
  final double coordDiff = 0.001;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    enteredLast = UserSharedPref.getEnterCheck(
            day:
                int.parse(DateFormat("dd").format(Timestamp.now().toDate()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Verify geolocation"),
      content: Column(
        children: <Widget>[
          const Text("Tap the below icon to verify geolocation"),
          !loading
              ? MaterialButton(
                  onPressed: geolocationVerificationLogic,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Icon(Icons.location_on,
                      size: 24.0, color: Colors.blue),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Loading(white: false),
                ),
          const Text("Are you entering (In) or leaving (Out) the location?"),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("In"),
          onPressed: () => verified
              ? !enteredLast
                  ? toAttPage(context, true)
                  : commonSnackbar(
                      "Last attendance was marked \"In\""
                      "\nCan only choose \"Out\" now",
                      context)
              : commonSnackbar("Geolocation not verified", context),
        ),
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("Out"),
          onPressed: () => verified
              ? enteredLast
                  ? toAttPage(context, false)
                  : commonSnackbar(
                      "Last attendance was marked \"Out\""
                      "\nCan only choose \"In\" now",
                      context)
              : commonSnackbar("Geolocation not verified", context),
        ),
      ],
    );
  }

  Future<void> geolocationVerificationLogic() async {
    setState(() => loading = true);
    try {
      coord = await _determinePosition();
      geoPointCoord = GeoPoint(coord!.latitude, coord!.longitude);
      desiredCoord = widget.loc;
      if ((geoPointCoord!.latitude - desiredCoord!.latitude).abs() <
              coordDiff &&
          (geoPointCoord!.longitude - desiredCoord!.longitude).abs() <
              coordDiff) {
        setState(() {
          loading = false;
          commonSnackbar("Geolocation verification successful.", context);
          verified = true;
        });
      } else {
        setState(() {
          loading = false;
          commonSnackbar("Geolocation verification failed.", context);
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        commonSnackbar(e.toString(), context);
      });
    }
  }

  Future toAttPage(BuildContext context, bool reporting) {
    Navigator.pop(context);
    return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => AttendancePage(
            uid: widget.uid, loc: widget.loc, reporting: reporting)));
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loc.Location().requestService();
      if (!serviceEnabled) {
        throw "Please enable location services.";
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw "Please allow location permissions.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Cannot request permissions, location permissions are permanently denied.";
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      return Geolocator.getLastKnownPosition();
    }
  }
}
