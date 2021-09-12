import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/Constants/const_color.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Helpers/dialog_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  bool _showPassword;
  bool _isLoading;
  GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  TextEditingController _emailController, _passwordController;
  FirebaseAuth _auth = FirebaseAuth.instance;
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

  Widget _textField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: _controller(controller),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onChanged: (value) => controller.text = value,
      validator: (value) => value.isEmpty
          ? "Email Required"
          : !value.contains("@")
              ? "Invalid Email"
              : null,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
                top: MediaQuery.of(context).padding.top + 12,
                left: 8.0,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/login"))),
            Positioned(
                top: min(_size.height * 0.4 - 70, 260),
                left: 15,
                right: 15,
                bottom: 0,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(ConstValue.LEFT_PADDING),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 60, maxHeight: 80)),
                          Form(
                            key: _globalFormKey,
                            child: Column(children: [
                              _textField(
                                _emailController,
                                "Enter your email",
                              ),
                              SizedBox(
                                  height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE),
                              TextFormField(
                                controller: _controller(_passwordController),
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ConstValue.BORDER_RADIUS))),
                                validator: (value) => value.isEmpty
                                    ? "Password Required"
                                    : value.length < 6
                                        ? "Password must be of min length 6"
                                        : null,
                                onChanged: (value) =>
                                    _passwordController.text = value,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                  height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE),
                              TextFormField(
                                obscureText: _showPassword,
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
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
                                            ConstValue.BORDER_RADIUS))),
                                validator: (value) => value.isEmpty
                                    ? "Password Required"
                                    : value != _passwordController.text
                                        ? "Password Doesn't Match"
                                        : null,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 30),
                              MaterialButton(
                                onPressed: () => _signUpButton(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ConstValue.TEXT_FIELD_BORDER_RADIUS)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: ConstValue.SMALL_PADDING),
                                minWidth: double.infinity,
                                color: ConstColor.BACK_COLOR,
                                child: _isLoading
                                    ? Center(child: DialogHelper.showLoading(color:Colors.white))
                                    : Text(
                                        "Sign Up",
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                              ),
                            ]),
                          )
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

  void _signUpButton() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_globalFormKey.currentState.validate()) {
      setState(() {
        _isLoading = !_isLoading;
      });
      try {
        final new_user = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        if (new_user != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "An email has just been sent to you, Click the link provided to complete registration")));
          _sendEmailVerification();
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${e.toString()}")));
      } finally {
        setState(() {
          _isLoading = !_isLoading;
        });
      }
    }
  }

  void _sendEmailVerification() {
    User user = _auth.currentUser;
    user.sendEmailVerification();
  }
}
