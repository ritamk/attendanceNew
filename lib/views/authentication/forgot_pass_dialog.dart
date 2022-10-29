import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/text_field/auth_text_field.dart';
import 'package:AnandaAttendance/views/authentication/forgot_pass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPassDialog extends StatefulWidget {
  ForgetPassDialog({Key? key}) : super(key: key);

  @override
  State<ForgetPassDialog> createState() => _ForgetPassDialogState();
}

class _ForgetPassDialogState extends State<ForgetPassDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mailController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Enter registered email"),
      content: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextFormField(
                  controller: _mailController,
                  decoration: authTextInputDecoration("Email", Icons.mail),
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your email" : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20.0, width: 0.0),
                CupertinoDialogAction(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await AuthenticationService()
                          .forgetPass(_mailController.text)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                ForgotPass(mail: _mailController.text)));
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _loading
                        ? const Loading(
                            white: true,
                          )
                        : const Text(
                            "Send OTP",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 18.0),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
