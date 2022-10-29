import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/shared/buttons/sign_in_bt.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/text_field/auth_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key, required this.mail}) : super(key: key);
  final String mail;

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool _loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _otpFocus = FocusNode();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset password"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    prefixIcon: Icon(Icons.password),
                    labelText: "4 digit OTP",
                    helperText: "please check your email for an OTP",
                    errorStyle: TextStyle(color: Colors.red.shade800),
                    helperStyle: TextStyle(color: Colors.black54),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: textFieldBorder(),
                    focusedBorder: textFieldBorder(),
                    errorBorder: textFieldBorder(),
                  ),
                  focusNode: _otpFocus,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter the OTP" : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 40.0, width: 0.0),
                TextButton(
                  style: authSignInBtnStyle(),
                  onPressed: () async {
                    await checkOtp(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _loading
                        ? const Loading(
                            white: true,
                          )
                        : const Text(
                            "Check OTP",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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

  Future<void> checkOtp(BuildContext context) async {
    await AuthenticationService().forgetPass(widget.mail);
  }
}
