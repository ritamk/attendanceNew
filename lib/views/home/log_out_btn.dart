import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/views/authentication/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogginOutHome extends StatefulWidget {
  const LogginOutHome({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<LogginOutHome> createState() => _LogginOutHomeState();
}

class _LogginOutHomeState extends State<LogginOutHome> {
  bool loggingOut = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => logOutLogic(() {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const AuthPage()),
            (route) => false);
      }),
      icon: !loggingOut
          ? const Icon(Icons.power_settings_new)
          : const Loading(white: false),
      tooltip: "Log-out",
    );
  }

  Future<void> logOutLogic(VoidCallback route) async {
    setState(() => loggingOut = true);
    await AuthenticationService().signOut();
    await UserSharedPref.setVerifiedOrNot(false);
    await UserSharedPref.setUser("noUser");
    route.call();
  }
}
