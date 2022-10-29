import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/buttons/sign_in_bt.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:AnandaAttendance/shared/text_field/auth_text_field.dart';
import 'package:AnandaAttendance/views/authentication/eid_dialogue.dart';
import 'package:AnandaAttendance/views/authentication/forgot_pass_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String mail = "";
  String pass = "";
  bool _hidePassword = true;
  bool loading = false;
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _mailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log-In"),
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
                // Email form field
                TextFormField(
                  decoration: authTextInputDecoration("Email", Icons.mail),
                  focusNode: _mailFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your email" : null,
                  onChanged: (val) => mail = val,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusScope.of(context).requestFocus(_passFocusNode),
                ),
                const SizedBox(
                  height: 20.0,
                  width: 0.0,
                ),
                // Password form field
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    prefixIcon: const Icon(Icons.vpn_key),
                    labelText: "Password",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: textFieldBorder(),
                    focusedBorder: textFieldBorder(),
                    errorBorder: textFieldBorder(),
                    suffixIcon: IconButton(
                        onPressed: () => setState(
                              () => _hidePassword = !_hidePassword,
                            ),
                        icon: (_hidePassword)
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                  ),
                  focusNode: _passFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your password" : null,
                  onChanged: (val) => pass = val,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                  obscureText: _hidePassword,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        Navigator.of(context).push(CupertinoDialogRoute(
                            builder: (context) => ForgetPassDialog(),
                            context: context));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0, width: 0.0),
                TextButton(
                  style: authSignInBtnStyle(),
                  onPressed: () async => await signInLogic(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: loading
                        ? const Loading(
                            white: true,
                          )
                        : const Text(
                            "Sign-in",
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

  @override
  void dispose() {
    _passFocusNode.dispose();
    _mailFocusNode.dispose();
    super.dispose();
  }

  Future<void> signInLogic(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await AuthenticationService()
          .signInWithMailPass(mail.trim(), pass.trim());
      if (result != null) {
        await UserSharedPref.setUser(result);
        loading = false;
        Navigator.of(context).push(CupertinoDialogRoute(
          builder: (context) => const EidConfirmDialog(),
          context: context,
        ));
      } else {
        setState(() {
          loading = false;
          commonSnackbar(
              "Couldn't sign-in, please try again.\nPlease check credentials and network connection.",
              context);
        });
      }
    }
  }
}
