import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/Constants/const_color.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Helpers/dialog_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword;
  bool _isLoading;
  GlobalKey<FormState> _globalLoginFormKey = GlobalKey<FormState>();
  TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    _showPassword = true;
    _isLoading = false;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  TextEditingController _controller(TextEditingController controller) {
    return TextEditingController.fromValue(
      TextEditingValue(
        text: controller.text,
        selection: TextSelection.collapsed(
          offset: controller.text.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: _size.height * 0.4,
                constraints: BoxConstraints(maxHeight: 330, minHeight: 200),
                width: double.infinity,
                color: ConstColor.BACK_COLOR,
              ),
            ),
            Positioned(
                top: min(_size.height * 0.4 - 70, 260),
                left: 15,
                right: 15,
                bottom: 0,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ConstValue.TEXT_FIELD_BORDER_RADIUS)),
                  child: Padding(
                    padding: const EdgeInsets.all(ConstValue.LEFT_PADDING),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 60, maxHeight: 80)),
                          Form(
                            key: _globalLoginFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _controller(_emailController),
                                  decoration: InputDecoration(
                                    hintText: "Enter Your Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          ConstValue.BORDER_RADIUS),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      _emailController.text = value,
                                  validator: (value) => value.isEmpty
                                      ? "Email Required"
                                      : !value.contains("@")
                                          ? "Invalid Email"
                                          : null,
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(
                                    height: ConstValue
                                        .LARGE_VERTICAL_SIZE_BETWEEN_ELE),
                                TextFormField(
                                  controller: _controller(_passwordController),
                                  obscureText: _showPassword,
                                  onChanged: (value) =>
                                      _passwordController.text = value,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    suffixIcon: GestureDetector(
                                      child: Icon(_showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onTap: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          ConstValue.BORDER_RADIUS),
                                    ),
                                  ),
                                  validator: (value) => value.isEmpty
                                      ? "Password Required"
                                      : value.length < 6
                                          ? "Password must be of min length 6"
                                          : null,
                                ),
                                SizedBox(
                                    height: ConstValue
                                        .LARGE_VERTICAL_SIZE_BETWEEN_ELE),
                                MaterialButton(
                                  onPressed: () async => signIn(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ConstValue.BORDER_RADIUS)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: ConstValue.SMALL_PADDING),
                                  minWidth: double.infinity,
                                  color: ConstColor.BACK_COLOR,
                                  child: _isLoading
                                      ? Center(
                                          child: DialogHelper.showLoading(color:Colors.white))
                                      : Text(
                                          "Login",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/signupPage");
                            },
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "Don't have account? ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Sign Up!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ConstColor.BACK_COLOR),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  signIn() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_globalLoginFormKey.currentState.validate()) {
      setState(() {
        _isLoading = !_isLoading;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;

      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        if (user.user.emailVerified) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Check your registered email address to verify your email.")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${e.toString()}")));
      }
    }
  }
}
