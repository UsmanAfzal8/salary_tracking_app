import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salary_tracking_app/consts/colors.dart';
import 'package:salary_tracking_app/services/authentication_service.dart';
import 'package:salary_tracking_app/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../responsive.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        _auth
            .signInWithEmailAndPassword(
                email: _emailAddress.toLowerCase().trim(),
                password: _password.trim())
            .then((value) {
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = (MediaQuery.of(context).size.width * 1);
    double heightsize = (MediaQuery.of(context).size.height * 1);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResponsiveWidget.isSmallScreen(context)
              ? const SizedBox()
              : Expanded(
                  child: Container(
                    height: heightsize,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Wage Me ',
                            style: TextStyle(
                              fontSize: 58.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Salary tracking App ',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: heightsize,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: heightsize,
                    color: ResponsiveWidget.isSmallScreen(context)
                        ? Colors.blue
                        : Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50, left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome!',
                                style: TextStyle(
                                  fontSize: heightsize * 0.06,
                                  color: ResponsiveWidget.isSmallScreen(context)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: heightsize * 0.04,
                                      color: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 70),
                        Padding(
                          padding: ResponsiveWidget.isSmallScreen(context)
                              ? const EdgeInsets.only(right: 0)
                              : const EdgeInsets.only(right: 30),
                          child: Container(
                            height: heightsize * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.circular(32),
                              //   topRight: Radius.circular(32),
                              // ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 80, left: 12, right: 12),
                                    child: TextFormField(
                                      key: const ValueKey('email'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () =>
                                          FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: const UnderlineInputBorder(),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.email),
                                          labelText: 'Email Address',
                                          fillColor: Theme.of(context)
                                              .backgroundColor),
                                      onSaved: (value) {
                                        _emailAddress = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextFormField(
                                      key: const ValueKey('Password'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 7) {
                                          return 'Please enter a valid Password';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: _passwordFocusNode,
                                      decoration: InputDecoration(
                                          border: const UnderlineInputBorder(),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(_obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                          labelText: 'Password',
                                          fillColor: Theme.of(context)
                                              .backgroundColor),
                                      onSaved: (value) {
                                        _password = value!;
                                      },
                                      obscureText: _obscureText,
                                      onEditingComplete: _submitForm,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 20),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ForgetPassword.routeName);
                                          },
                                          child: Text(
                                            'Recovery password',
                                            style: TextStyle(
                                              color: Colors.blue.shade900,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      _isLoading
                                          ? const CircularProgressIndicator()
                                          : SizedBox(
                                              height: 50,
                                              width: 170,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        side: BorderSide(
                                                            color: ColorsConsts
                                                                .backgroundColor),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: _submitForm,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const <Widget>[
                                                      Text(
                                                        'Login',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .verified_user_outlined,
                                                        size: 18,
                                                      )
                                                    ],
                                                  )),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
