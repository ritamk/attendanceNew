import 'package:AnandaAttendance/models/employee_model.dart';
import 'package:AnandaAttendance/services/database.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/views/attendance/att_report.dart';
import 'package:AnandaAttendance/views/home/att_in_out_dialog.dart';
import 'package:AnandaAttendance/views/home/log_out_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ShapeBorder roundedRectangleBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));
  DetailedEmployeeModel? detEmpModel;
  bool loadingError = false;
  bool loading = true;
  GeoPoint? geoPoint;

  @override
  void initState() {
    super.initState();
    loadEmpData().whenComplete(() => setState(() => loading = false));
  }

  Future loadEmpData() async {
    dynamic result = await DatabaseService(uid: widget.uid).employeeDetail();
    if (result != null) {
      detEmpModel = DetailedEmployeeModel(
        uid: result["uid"],
        name: result["name"],
        eID: result["eID"],
        email: result["email"],
        loc: result["loc"],
        store: result["store"],
      );
      geoPoint = await DatabaseService().getGeoLocation(detEmpModel!.store!);
    } else {
      setState(() => loadingError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // onDrawerChanged: (changed) => reloadAfterClosingDrawer(changed),
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          LogginOutHome(uid: widget.uid),
        ],
      ),
      body: !loading
          ? !loadingError
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(18.0),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  clipBehavior: Clip.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Welcome,",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.black54),
                            textAlign: TextAlign.start,
                          ),
                          Text(detEmpModel!.name,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          SelectableText("(E-ID: ${detEmpModel!.eID})",
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 20.0, width: 0.0),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            minVerticalPadding: 10.0,
                            tileColor: Colors.redAccent,
                            textColor: Colors.white,
                            shape: roundedRectangleBorder,
                            title: const Text("Attendance Recorder",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                            subtitle: const Text("Record your attendance"),
                            trailing: const Icon(Icons.pan_tool_outlined,
                                color: Colors.white),
                            onTap: () =>
                                Navigator.of(context).push(CupertinoDialogRoute(
                              builder: (context) => AttendanceInOrOutDialog(
                                  uid: widget.uid!, loc: geoPoint!),
                              context: context,
                            )),
                          ),
                          const SizedBox(height: 20.0, width: 0.0),
                          ListTile(
                            minVerticalPadding: 10.0,
                            tileColor: Colors.redAccent,
                            textColor: Colors.white,
                            shape: roundedRectangleBorder,
                            title: const Text("Attendance Summary",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                            subtitle: const Text("Your attendance records"),
                            trailing: const Icon(Icons.date_range,
                                color: Colors.white),
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        AttReportPage(uid: widget.uid!))),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    "Something went wrong while fetching from database.",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
          : const Center(child: Loading(white: false, rad: 14.0)),
      // drawer: const HomeDrawer(),
    );
  }

  void reloadAfterClosingDrawer(isOpened) {
    if (!isOpened) {
      setState(() => loading = true);
      loadEmpData().whenComplete(() => setState(() => loading = false));
    } else {
      null;
    }
  }
}
