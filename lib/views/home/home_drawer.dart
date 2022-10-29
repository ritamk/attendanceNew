import 'package:AnandaAttendance/services/database.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/buttons/sign_in_bt.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final GlobalKey<FormState> _drawerKey = GlobalKey<FormState>();
  final FocusNode _latFocus = FocusNode();
  final FocusNode _lonFocus = FocusNode();
  String lat = "";
  String lon = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              topRight: Radius.circular(25.0))),
      child: DrawerHeader(
        child: Form(
          key: _drawerKey,
          child: Column(
            children: <Widget>[
              const Text(
                "Change geolocation",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0, width: 0.0),
              TextFormField(
                focusNode: _latFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text("latitude"),
                ),
                onChanged: (val) => lat = val,
                onFieldSubmitted: (val) =>
                    FocusScope.of(context).requestFocus(_lonFocus),
                validator: (val) => val != null
                    ? val.contains(".")
                        ? null
                        : "Please enter a valid latitude"
                    : "Please enter a latitude",
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                focusNode: _lonFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text("longitude"),
                ),
                onChanged: (val) => lon = val,
                onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                validator: (val) => val != null
                    ? val.contains(".")
                        ? null
                        : "Please enter a valid longitude"
                    : "Please enter a longitude",
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 30.0, width: 0.0),
              TextButton(
                onPressed: () async {
                  if (_drawerKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    final result =
                        await DatabaseService(uid: UserSharedPref.getUser())
                            .updateGeoLocation(
                                double.parse(lat), double.parse(lon));
                    result
                        ? setState(() {
                            loading = false;
                            commonSnackbar(
                                "Successfully updated geolocation", context);
                          })
                        : setState(() {
                            loading = false;
                            commonSnackbar(
                                "Something went wrong\nCouldn't update geolocation",
                                context);
                          });
                  }
                },
                style: authSignInBtnStyle(),
                child: loading
                    ? const Loading(white: true)
                    : const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
