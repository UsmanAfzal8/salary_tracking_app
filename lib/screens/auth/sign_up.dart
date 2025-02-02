import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salary_tracking_app/consts/colors.dart';
import 'package:salary_tracking_app/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../responsive.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _jobTitleFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String _fullName = '';
  String _jobTitle = '';
  String _companyName = 'Katy';
  int? _phoneNumber;
  XFile? _pickedImage;
  String? url;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  List companies = [
    'Katy',
    'Laporte',
    'Houston',
  ];
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toIso8601String();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          print('here before uploading image');
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersImages')
              .child(_fullName + '.jpg');
          Uint8List imageData = await _pickedImage!.readAsBytes();
          await ref.putData(imageData);
          url = await ref.getDownloadURL();
          await _auth.createUserWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim());
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          print(_uid);

          user.updatePhotoURL(url);
          user.updateDisplayName(_fullName);
          user.reload();
          print('here');
          print(user.email);
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'companyName': _companyName,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedAt': formattedDate,
            'isAdmin': false,
            'wage': '10.0',
            'jobTitle': _jobTitle,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
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

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = XFile(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = XFile(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = (MediaQuery.of(context).size.width * 1);
    double heightsize = (MediaQuery.of(context).size.height * 1);
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: widthsize,
                        decoration: BoxDecoration(
                          color: ResponsiveWidget.isSmallScreen(context)
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: heightsize * 0.04,
                              color: ResponsiveWidget.isSmallScreen(context)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 5, left: 30, right: 30, bottom: 30),
                            child: CircleAvatar(
                              radius: 71,
                              backgroundColor: ColorsConsts.gradiendLEnd,
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: ColorsConsts.gradiendFEnd,
                                backgroundImage: _pickedImage == null
                                    ? null
                                    : kIsWeb
                                        ? NetworkImage(_pickedImage!.path)
                                            as ImageProvider
                                        : FileImage(File(_pickedImage!.path)),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 120,
                              left: 110,
                              child: RawMaterialButton(
                                elevation: 10,
                                fillColor: ColorsConsts.gradiendLEnd,
                                child: const Icon(Icons.add_a_photo),
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Choose option',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConsts
                                                    .gradiendLStart),
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: [
                                                InkWell(
                                                  onTap: _pickImageCamera,
                                                  splashColor:
                                                      Colors.purpleAccent,
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.camera,
                                                          color: Colors
                                                              .purpleAccent,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorsConsts
                                                                .title),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: _pickImageGallery,
                                                  splashColor:
                                                      Colors.purpleAccent,
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.image,
                                                          color: Colors
                                                              .purpleAccent,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorsConsts
                                                                .title),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: _remove,
                                                  splashColor:
                                                      Colors.purpleAccent,
                                                  child: Row(
                                                    children: const [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.red),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ))
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('name'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'name cannot be null';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    filled: true,
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: 'Full name',
                                    fillColor:
                                        Theme.of(context).backgroundColor),
                                onSaved: (value) {
                                  _fullName = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('job title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'job title cannot be null';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_jobTitleFocusNode),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    filled: true,
                                    prefixIcon: const Icon(Icons.business),
                                    labelText: 'Job Title',
                                    fillColor:
                                        Theme.of(context).backgroundColor),
                                onSaved: (value) {
                                  _jobTitle = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('email'),
                                focusNode: _emailFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    filled: true,
                                    prefixIcon: const Icon(Icons.email),
                                    labelText: 'Email Address',
                                    fillColor:
                                        Theme.of(context).backgroundColor),
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
                                  if (value!.isEmpty || value.length < 7) {
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
                                    fillColor:
                                        Theme.of(context).backgroundColor),
                                onSaved: (value) {
                                  _password = value!;
                                },
                                obscureText: _obscureText,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_phoneNumberFocusNode),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('phone number'),
                                focusNode: _phoneNumberFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _submitForm,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    filled: true,
                                    prefixIcon: const Icon(Icons.phone_android),
                                    labelText: 'Phone number',
                                    fillColor:
                                        Theme.of(context).backgroundColor),
                                onSaved: (value) {
                                  _phoneNumber = int.parse(value!);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Select Company',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      magnification: 1.2,
                                      looping: false,
                                      offAxisFraction: 0,
                                      useMagnifier: true,
                                      squeeze: 2,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          _companyName = companies[index];
                                        });
                                      },
                                      children: companies
                                          .map((company) => Text(
                                                company,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                _isLoading
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: ColorsConsts
                                                    .backgroundColor),
                                          ),
                                        )),
                                        onPressed: _submitForm,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Sign up',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.person,
                                              size: 18,
                                            )
                                          ],
                                        )),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
