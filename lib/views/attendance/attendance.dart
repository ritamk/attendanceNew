import 'dart:io';

import 'package:camera/camera.dart';
import 'package:AnandaAttendance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AnandaAttendance/models/attendance_model.dart';
import 'package:AnandaAttendance/services/database.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({
    Key? key,
    required this.loc,
    required this.uid,
    required this.reporting,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;
  final bool reporting;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late CameraController _cameraController;
  bool loading = true;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool? canCheckBiometric;
  bool biomAuthed = false;
  bool camAvailable = true;
  bool photoTaken = false;
  bool photoClicked = false;
  bool photoUploaded = false;
  bool picUploading = false;
  XFile? file;

  @override
  void initState() {
    super.initState();
    intialiseCamera();
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          clipBehavior: Clip.none,
          child: !loading
              ? camAvailable
                  ? !photoUploaded
                      ? !photoTaken
                          // camera
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CameraPreview(_cameraController),
                                  ),
                                  Positioned(
                                    bottom: 20.0,
                                    child: InkWell(
                                      onTapDown: (details) =>
                                          setState(() => photoClicked = true),
                                      onTapUp: (details) =>
                                          setState(() => photoClicked = false),
                                      onTap: () {
                                        try {
                                          _cameraController
                                              .takePicture()
                                              .then((value) => file = value)
                                              .whenComplete(() => setState(
                                                  () => photoTaken = true));
                                        } catch (e) {
                                          setState(() => camAvailable = false);
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 55.0,
                                            width: 55.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: Colors.white)),
                                          ),
                                          AnimatedContainer(
                                            height: photoClicked ? 40.0 : 45.0,
                                            width: photoClicked ? 40.0 : 45.0,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            duration: const Duration(
                                                milliseconds: 100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          // pic preview
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(File(file!.path)),
                                  ),
                                  Positioned(
                                      right: 20.0,
                                      top: 20.0,
                                      child: CircleAvatar(
                                        radius: 35.0,
                                        child: IconButton(
                                            color: Colors.white,
                                            iconSize: 48.0,
                                            onPressed: () => setState(
                                                () => photoTaken = false),
                                            icon:
                                                const Icon(Icons.cancel_sharp)),
                                      )),
                                  Positioned(
                                    bottom: 20.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                4.0),
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black54),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                      onPressed: () {
                                        setState(() => picUploading = true);
                                        DatabaseService()
                                            .uploadPicture(File(file!.path))
                                            .then((String value) =>
                                                photoUpload(value))
                                            .whenComplete(() => setState(
                                                () => picUploading = false));
                                      },
                                      child: !picUploading
                                          ? const Text(
                                              "Upload picture",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Loading(white: true),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      // attendance marked
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade500,
                              size: 32.0,
                            ),
                            const SizedBox(height: 20.0, width: 0.0),
                            Text(
                              "Attendance marked",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green.shade500,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                  // error
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          color: Colors.red.shade700,
                          size: 32.0,
                        ),
                        const SizedBox(height: 20.0, width: 0.0),
                        Text(
                          "Camera not accessible",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
              : const Loading(white: false, rad: 14.0),
        ),
      ),
    );
  }

  Future<void> photoUpload(String url) async {
    try {
      DatabaseService(uid: widget.uid)
          .attendanceReporting(
            EmpAttendanceModel(
              reporting: widget.reporting,
              time: Timestamp.now(),
              geoloc: widget.loc,
              photo: url,
            ),
          )
          .whenComplete(() {
            UserSharedPref.setEnterCheck(
                enteredLast: widget.reporting,
                day: int.parse(
                    DateFormat("dd").format(Timestamp.now().toDate())));

            setState(() => photoUploaded = true);

            commonSnackbar("Attendance marked successfully", context);
          })
          .timeout(const Duration(seconds: 10))
          .onError((error, stackTrace) => commonSnackbar(
              "Failed to mark attendance, please try again", context));
    } catch (e) {
      commonSnackbar("Failed to upload picture", context);
    }
  }

  Future<void> onAuthPressed() async {
    setState(() => loading = true);
    try {
      await localAuth
          .authenticate(
        localizedReason: "Verify biometrics to mark attendance",
        options: const AuthenticationOptions(biometricOnly: true),
      )
          .then((value) {
        if (value) {
          setState(() {
            loading = false;
            biomAuthed = true;
          });
        } else {
          commonSnackbar("Biometric verification failed", context);
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      commonSnackbar("Something went wrong, please try again\n", context);
      Navigator.of(context).pop();
    }
  }

  void intialiseCamera() {
    try {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high,
          enableAudio: false);
      _cameraController.initialize().then((value) {
        if (!mounted) return;
        setState(() => loading = false);
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              commonSnackbar("Camera access denied", context);
              break;
            default:
              commonSnackbar(
                  "Something went wrong when opening camera", context);
              break;
          }
        }
      });
    } catch (e) {
      loading = false;
      camAvailable = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }
}
