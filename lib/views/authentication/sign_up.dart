import 'package:AnandaAttendance/services/authentication.dart';
import 'package:AnandaAttendance/services/shared_pref.dart';
import 'package:AnandaAttendance/shared/buttons/sign_in_bt.dart';
import 'package:AnandaAttendance/shared/constants.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/shared/snackbar.dart';
import 'package:AnandaAttendance/shared/text_field/auth_text_field.dart';
import 'package:AnandaAttendance/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int storeIndex = 0;
  bool storeSelected = false;
  final TextEditingController storeController = TextEditingController();
  String name = "";
  String mail = "";
  String pass = "";
  bool _hidePassword = true;
  bool loading = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _mailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Form(
            key: _globalKey,
            child: Column(
              children: <Widget>[
                // name form field
                TextFormField(
                  decoration: authTextInputDecoration("Name", Icons.person),
                  focusNode: _nameFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your name" : null,
                  onChanged: (val) => name = val,
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusScope.of(context).requestFocus(_mailFocusNode),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: storeController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    prefixIcon: Icon(Icons.store),
                    labelText: "Store",
                    helperText: "select from dropdown below",
                    errorStyle: TextStyle(color: Colors.red.shade800),
                    helperStyle: TextStyle(color: Colors.black54),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: textFieldBorder(),
                    focusedBorder: textFieldBorder(),
                    errorBorder: textFieldBorder(),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? "Please select a store" : null,
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey.shade300,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    itemBuilder: (context) {
                      return <PopupMenuItem<String>>[
                        for (String elem in STORES)
                          PopupMenuItem(
                            value: elem,
                            child: Text(elem,
                                style: const TextStyle(color: Colors.black54)),
                          ),
                      ];
                    },
                    onSelected: (String value) {
                      storeIndex =
                          STORES.indexWhere((element) => value == element);
                      storeSelected = true;
                      storeController.text = STORES[storeIndex];
                      setState(() {});
                    },
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10.0),
                        Text("Select Store",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Email form field
                TextFormField(
                  decoration: authTextInputDecoration("Email", Icons.mail),
                  focusNode: _mailFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter a valid email" : null,
                  onChanged: (val) => mail = val,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusScope.of(context).requestFocus(_passFocusNode),
                ),
                const SizedBox(height: 20.0),
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
                  validator: (val) => (val!.length < 6)
                      ? "Please enter a password with\nmore than 6 characters"
                      : null,
                  onChanged: (val) => pass = val,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                  obscureText: _hidePassword,
                ),
                const SizedBox(height: 40.0),
                TextButton(
                  style: authSignInBtnStyle(),
                  onPressed: () async => await signUpLogic(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: loading
                        ? const Loading(
                            white: true,
                          )
                        : const Text(
                            "Sign-up",
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

  Future<void> signUpLogic(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await AuthenticationService().registerWithMailPass(
        name.trim(),
        mail.trim(),
        pass.trim(),
        COORDINATES[storeIndex],
        STORES[storeIndex],
      );
      if (result != null) {
        await UserSharedPref.setUser(result);
        await UserSharedPref.setVerifiedOrNot(true);
        loading = false;
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (builder) => HomePage(uid: result)),
            (route) => false);
      } else {
        setState(() {
          loading = false;
          commonSnackbar(
            "Couldn't sign-up, please try again later.\nPlease check credentials and/or network connection.",
            context,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _passFocusNode.dispose();
    _mailFocusNode.dispose();
    super.dispose();
  }
}
