import 'package:AnandaAttendance/shared/buttons/sign_in_bt.dart';
import 'package:AnandaAttendance/views/authentication/sign_in.dart';
import 'package:AnandaAttendance/views/authentication/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/anandamela_logo.png",
                colorBlendMode: BlendMode.overlay,
                scale: 1.2,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (builder) => const SignUpPage())),
                      style: authSignInBtnStyle(),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      )),
                  // const Padding(padding: EdgeInsets.all(16.0)),
                  TextButton(
                      onPressed: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (builder) => const SignInPage())),
                      style: authSignInBtnStyle(),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Log-in",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
