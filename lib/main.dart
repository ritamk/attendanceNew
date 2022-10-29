import 'package:camera/camera.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSharedPref.init();
  cameras = await availableCameras();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnandaAttendance',
      // debugShowCheckedModeBanner: false,
      theme: mainTheme(),
      // home: Consumer(
      //     builder: (_, ref, __) => ref.watch(dashboardOrNotProvider)
      //         ? const HomePage()
      //         : const AuthPage()),
      home: const Wrapper(),
    );
  }
}

ThemeData mainTheme() {
  return ThemeData(
    fontFamily: "Montserrat",
    dividerColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white10,
      elevation: 0.0,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontFamily: "Montserrat",
      ),
      backgroundColor: Colors.white10,
      foregroundColor: Colors.red,
    ),
    primarySwatch: Colors.red,
  );
}
