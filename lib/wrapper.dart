import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:AnandaAttendance/views/authentication/auth_page.dart';
import 'package:AnandaAttendance/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  late bool verified;
  String? user;
  bool timeOut = false;
  @override
  void initState() {
    super.initState();
    if (UserSharedPref.getUser() != null) {
      user = UserSharedPref.getUser();
    } else {
      user = null;
    }
    if (UserSharedPref.getVerifiedOrNot() != null) {
      verified = UserSharedPref.getVerifiedOrNot()!;
    } else {
      verified = false;
      UserSharedPref.setVerifiedOrNot(verified);
    }
    Future.delayed(const Duration(seconds: 2))
        .then((value) => setState(() => timeOut = true));
  }

  Future<void> loadData() async {
    try {} catch (e) {
      commonSnackbar(
          "Something went wrong, couldn't load initial data", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timeOut) {
      if (user != null) {
        if (verified) {
          return HomePage(uid: UserSharedPref.getUser());
        } else {
          return const AuthPage();
        }
      } else {
        return FutureBuilder<String?>(
          future: AuthenticationService().currentUser(),
          initialData: "noUser",
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "noUser") {
              if (snapshot.data != null) {
                setUser(snapshot.data);
                if (verified) {
                  return HomePage(uid: snapshot.data);
                } else {
                  return const AuthPage();
                }
              } else {
                return const AuthPage();
              }
            } else {
              return const WrapperBody();
            }
          },
        );
      }
    } else {
      return const WrapperBody();
    }
  }

  Future setUser(String uid) async {
    await UserSharedPref.setUser(uid);
  }
}

class WrapperBody extends StatelessWidget {
  const WrapperBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/images/anandamela_logo.png",
              colorBlendMode: BlendMode.overlay,
            ),
          ),
          const SizedBox(height: 40.0, width: 0.0),
          const Loading(white: false, rad: 14.0),
        ],
      ),
    );
  }
}
