import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

import '../authentication/SignUpForm.dart';
import '../authentication/firebase_auth.dart';
import '../authentication/loginform.dart';
import '../globals.dart';
import '../widgets/loading.dart';
import 'otp_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  String? name;
  LoginPage({Key? key, this.name}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    final el = window.document.getElementById('__ff-recaptcha-container');
    if (el != null) {
      el.style.visibility = 'hidden';
    }
  }

  TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  late String actualCode;

  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String phonenumber = '';

  bool? googleloading = false;
  bool formVisible = false;
  bool value = false;
  bool phoneVisible = false;
  int _formIndex = 1;

  bool _isHidden = true;
  bool _isLoading = false;
  final _loginkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 700) {
          return Stack(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Color.fromRGBO(35, 0, 79, 1),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(80.00),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 525,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              HexColor("440F87"),
                              HexColor("7226D1"),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 40.0, // soften the shadow
                              offset: Offset(
                                0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                height: 75,
                                width: 110,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Let's Explore",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 22),
                              ),
                              Text(
                                "Data Science & Analytics together!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/loginoop.png'),
                                  // child: SvgPicture.asset(
                                  //   'assets/Frame.svg',
                                  //   height: verticalScale * 360,
                                  //   width: horizontalScale * 300,
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 325,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 40.0, // soften the shadow
                              offset: Offset(
                                0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 500),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: 'We will send you a ',
                                                style: TextStyle(
                                                    color:
                                                        MyColors.primaryColor,
                                                    fontSize: 18)),
                                            TextSpan(
                                                text: 'One Time Password ',
                                                style: TextStyle(
                                                    color:
                                                        MyColors.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            TextSpan(
                                                text: 'on this mobile number',
                                                style: TextStyle(
                                                    color:
                                                        MyColors.primaryColor,
                                                    fontSize: 18)),
                                          ]),
                                        )),
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Container(
                                      height: 40,
                                      constraints: const BoxConstraints(maxWidth: 500),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: InternationalPhoneNumberInput(
                                        maxLength: 10,
                                        onInputChanged: (PhoneNumber number) {
                                          print(number.phoneNumber);
                                          print(phoneController.text);
                                          phonenumber = number.phoneNumber.toString();
                                          print("phone number: ${phonenumber}");
                                        },
                                        onInputValidated: (bool value) {
                                          print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                          trailingSpace: false,
                                          selectorType: PhoneInputSelectorType.DIALOG,
                                        ),
                                        autofillHints: [AutofillHints.telephoneNumber],
                                        autoFocus: true,
                                        textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.start,
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.disabled,
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        initialValue: number,
                                        textFieldController: phoneController,
                                        formatInput: false,
                                        keyboardType: TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                        onSaved: (PhoneNumber number) {
                                          print('On Saved: $number');
                                          print(phoneController.text);
                                        },
                                      ),
                                      // CupertinoTextField(
                                      //   maxLength: 10,
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 16),
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       borderRadius:
                                      //           const BorderRadius.all(
                                      //               Radius.circular(4))),
                                      //   controller: phoneController,
                                      //   clearButtonMode:
                                      //       OverlayVisibilityMode.editing,
                                      //   keyboardType: TextInputType.phone,
                                      //   maxLines: 1,
                                      //   placeholder: '+91...',
                                      // ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (phoneController.text.isNotEmpty) {
                                          globals.phone =
                                              phoneController.text.toString();
                                          getCodeWithPhoneNumber(context,
                                              "${phonenumber}");
                                        } else if (phoneController.text.isEmpty) {
                                          Fluttertoast.showToast(msg: 'Please enter a phone number');
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        constraints:
                                            const BoxConstraints(maxWidth: 500),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                            gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  // Color(0xFF8A2387),
                                                  Color.fromRGBO(
                                                      120, 96, 220, 1),
                                                  Color.fromRGBO(
                                                      120, 96, 220, 1),
                                                  Color.fromARGB(
                                                      255, 88, 52, 246),
                                                ])),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: loading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                                color: Colors
                                                                    .white))),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 0, 0, 0),
                                                    child: Text(
                                                      'Next',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: MyColors
                                                          .primaryColorLight,
                                                    ),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: () async {
                                          final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: 'app.support@cloudyml.com',
                                              query: 'subject=Query about App');
                                          var mailurl = params.toString();
                                          if (await canLaunch(mailurl)) {
                                            await launch(mailurl);
                                          } else {
                                            throw 'Could not launch $mailurl';
                                          }
                                        },
                                        child: Text(
                                          'Need Help with Login?',
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          style: TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 19,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Container(
                                    //   margin: const EdgeInsets.symmetric(
                                    //       horizontal: 20, vertical: 10),
                                    //   constraints:
                                    //       const BoxConstraints(maxWidth: 500),
                                    //   child: RaisedButton(
                                    //     onPressed: () {
                                    //       if (phoneController.text.isNotEmpty) {
                                    //         loginStore.getCodeWithPhoneNumber(context,
                                    //             "+91${phoneController.text.toString()}");
                                    //       } else {
                                    //         loginStore.loginScaffoldKey.currentState
                                    //             ?.showSnackBar(SnackBar(
                                    //           behavior: SnackBarBehavior.floating,
                                    //           backgroundColor: Colors.red,
                                    //           content: Text(
                                    //             'Please enter a phone number',
                                    //             style: TextStyle(color: Colors.white),
                                    //           ),
                                    //         ));
                                    //       }
                                    //     },
                                    //     color: MyColors.primaryColor,
                                    //     shape: const RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(14))),
                                    //     child: Container(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 8, horizontal: 8),
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: <Widget>[
                                    //           Text(
                                    //             'Next',
                                    //             style: TextStyle(color: Colors.white),
                                    //           ),
                                    //           Container(
                                    //             padding: const EdgeInsets.all(8),
                                    //             decoration: BoxDecoration(
                                    //               borderRadius:
                                    //                   const BorderRadius.all(
                                    //                       Radius.circular(20)),
                                    //               color: MyColors.primaryColorLight,
                                    //             ),
                                    //             child: Icon(
                                    //               Icons.arrow_forward_ios,
                                    //               color: Colors.white,
                                    //               size: 16,
                                    //             ),
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 325,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.only(
                    //         topRight: Radius.circular(30),
                    //         bottomRight: Radius.circular(30)),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black12,
                    //         blurRadius: 40.0, // soften the shadow
                    //         offset: Offset(
                    //           0, // Move to right 10  horizontally
                    //           2.0, // Move to bottom 10 Vertically
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(50.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Log in",
                    //           style: TextStyle(
                    //               color: HexColor("2C2C2C"),
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 22),
                    //         ),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Text(
                    //           "Login if you have already created an ",
                    //           style: TextStyle(
                    //               color: HexColor("2C2C2C"),
                    //               fontWeight: FontWeight.w600,
                    //               fontSize: 10),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(bottom: 20),
                    //           child: Text(
                    //             "account, else click on create account.",
                    //             style: TextStyle(
                    //                 color: HexColor("2C2C2C"),
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 10),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(bottom: 5.0),
                    //           child: Text(
                    //             "Email",
                    //             style: TextStyle(
                    //                 color: HexColor("2C2C2C"),
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 14),
                    //           ),
                    //         ),
                    //         Form(
                    //           key: _loginkey,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               SizedBox(
                    //                 height: 30,
                    //                 child: TextFormField(
                    //                   autofillHints: [AutofillHints.email],
                    //                   style: TextStyle(
                    //                     fontSize: 12,
                    //                   ),
                    //                   cursorColor: HexColor('8346E1'),
                    //                   controller: email,
                    //                   decoration: InputDecoration(
                    //                       contentPadding: EdgeInsets.all(10),
                    //                       hintText: 'Enter Your Email',
                    //                       errorStyle: TextStyle(fontSize: 0.1),
                    //                       hintStyle: TextStyle(fontSize: 12),
                    //                       border: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(5),
                    //                       ),
                    //                       focusedBorder: OutlineInputBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(5),
                    //                           borderSide: BorderSide(
                    //                               color: HexColor('8346E1'),
                    //                               width: 2)),
                    //                       enabledBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(5),
                    //                         borderSide: BorderSide(
                    //                             color: HexColor('8346E1'),
                    //                             width: 2),
                    //                       ),
                    //                       suffixIcon: Icon(
                    //                         Icons.email,
                    //                         color: HexColor('8346E1'),
                    //                         size: 20,
                    //                       )),
                    //                   keyboardType: TextInputType.emailAddress,
                    //                   validator: (value) {
                    //                     if (value!.isEmpty) {
                    //                       return 'Enter email address';
                    //                     } else if (!RegExp(
                    //                             r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                    //                             r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    //                         .hasMatch(value)) {
                    //                       return 'Please enter a valid email address';
                    //                     }
                    //                     return null;
                    //                   },
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 "Password",
                    //                 style: TextStyle(
                    //                     color: HexColor("2C2C2C"),
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Container(
                    //                 height: 30,
                    //                 child: TextFormField(
                    //                   autofillHints: [AutofillHints.password],
                    //                   style: TextStyle(
                    //                     fontSize: 12,
                    //                   ),
                    //                   cursorColor: Colors.purple,
                    //                   controller: pass,
                    //                   decoration: InputDecoration(
                    //                       errorStyle: TextStyle(fontSize: 0.1),
                    //                       contentPadding: EdgeInsets.all(10),
                    //                       hintText: 'Enter Password',
                    //                       hintStyle: TextStyle(fontSize: 12),
                    //                       border: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(5),
                    //                       ),
                    //                       focusedBorder: OutlineInputBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(5),
                    //                           borderSide: BorderSide(
                    //                               color: HexColor('8346E1'),
                    //                               width: 2)),
                    //                       enabledBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(5),
                    //                         borderSide: BorderSide(
                    //                             color: HexColor('8346E1'),
                    //                             width: 2),
                    //                       ),
                    //                       suffixIcon: InkWell(
                    //                         // onTap: _togglepasswordview,
                    //                         child: Icon(
                    //                           _isHidden
                    //                               ? Icons.visibility_off
                    //                               : Icons.visibility,
                    //                           color: HexColor('8346E1'),
                    //                           size: 20,
                    //                         ),
                    //                       ),
                    //                       errorMaxLines: 2),
                    //                   obscureText: _isHidden,
                    //                   validator: (value) {
                    //                     if (value!.isEmpty) {
                    //                       return 'Enter the Password';
                    //                     } else if (!RegExp(
                    //                             r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    //                         .hasMatch(value)) {
                    //                       return 'Password must have at least one Uppercase, one Lowercase, one special character, and one numeric value';
                    //                     }
                    //                     return null;
                    //                   },
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               InkWell(
                    //                 onTap: () {
                    //                   if (email.text.isNotEmpty) {
                    //                     auth.sendPasswordResetEmail(
                    //                         email: email.text);
                    //                     showDialog(
                    //                         context: context,
                    //                         builder: (BuildContext context) {
                    //                           Future.delayed(
                    //                               Duration(seconds: 13), () {
                    //                             Navigator.of(context).pop(true);
                    //                           });
                    //                           return AlertDialog(
                    //                             title: Center(
                    //                               child: Column(
                    //                                 children: [
                    //                                   Lottie.asset(
                    //                                       'assets/email.json',
                    //                                       height: height * 0.15,
                    //                                       width: width * 0.5),
                    //                                   Text(
                    //                                     'Reset Password',
                    //                                     textScaleFactor: min(
                    //                                         horizontalScale,
                    //                                         verticalScale),
                    //                                     style: TextStyle(
                    //                                         color: Colors.red,
                    //                                         fontSize: 22,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                             content: Column(
                    //                               mainAxisSize:
                    //                                   MainAxisSize.min,
                    //                               children: [
                    //                                 Text(
                    //                                   'An email has been sent to ',
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                   style: TextStyle(),
                    //                                 ),
                    //                                 Text(
                    //                                   '${email.text}',
                    //                                   style: TextStyle(
                    //                                       fontWeight:
                    //                                           FontWeight.bold),
                    //                                 ),
                    //                                 Text(
                    //                                   'Click the link in the email to change password.',
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                 ),
                    //                                 SizedBox(
                    //                                   height:
                    //                                       verticalScale * 10,
                    //                                 ),
                    //                                 Text(
                    //                                   'Didn\'t get the email?',
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                   style: TextStyle(
                    //                                       fontWeight:
                    //                                           FontWeight.bold),
                    //                                 ),
                    //                                 Text(
                    //                                   'Check entered email or check spam folder.',
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                   style: TextStyle(),
                    //                                 ),
                    //                                 TextButton(
                    //                                     child: Text(
                    //                                       'Retry',
                    //                                       textScaleFactor: min(
                    //                                           horizontalScale,
                    //                                           verticalScale),
                    //                                       style: TextStyle(
                    //                                         fontSize: 20,
                    //                                       ),
                    //                                     ),
                    //                                     onPressed: () {
                    //                                       Navigator.pop(
                    //                                           context, true);
                    //                                     }),
                    //                               ],
                    //                             ),
                    //                           );
                    //                         });
                    //                   } else {
                    //                     showDialog(
                    //                         context: context,
                    //                         builder: (BuildContext context) {
                    //                           return AlertDialog(
                    //                               title: Center(
                    //                                 child: Text(
                    //                                   'Error',
                    //                                   textScaleFactor: min(
                    //                                       horizontalScale,
                    //                                       verticalScale),
                    //                                   style: TextStyle(
                    //                                       color: Colors.red,
                    //                                       fontSize: 24,
                    //                                       fontWeight:
                    //                                           FontWeight.bold),
                    //                                 ),
                    //                               ),
                    //                               content: Text(
                    //                                 'Enter email in the email field or check if the email is valid.',
                    //                                 textAlign: TextAlign.center,
                    //                                 textScaleFactor: min(
                    //                                     horizontalScale,
                    //                                     verticalScale),
                    //                                 style:
                    //                                     TextStyle(fontSize: 16),
                    //                               ),
                    //                               actions: [
                    //                                 TextButton(
                    //                                     child: Text('Retry'),
                    //                                     onPressed: () {
                    //                                       Navigator.pop(
                    //                                           context, true);
                    //                                     })
                    //                               ]);
                    //                         });
                    //                   }
                    //                 },
                    //                 child: Align(
                    //                   alignment: Alignment.bottomRight,
                    //                   child: Text(
                    //                     'Forgot Password?',
                    //                     textScaleFactor:
                    //                         min(horizontalScale, verticalScale),
                    //                     textAlign: TextAlign.end,
                    //                     style: TextStyle(
                    //                         color: HexColor('8346E1'),
                    //                         fontSize: 16),
                    //                   ),
                    //                 ),
                    //               ),
                    //               // Row(
                    //               //   mainAxisAlignment: MainAxisAlignment.start,
                    //               //   children: [
                    //               //     Transform.scale(
                    //               //       scale: 0.6,
                    //               //       child: Checkbox(
                    //               //         splashRadius: 5.0,
                    //               //         fillColor:
                    //               //             MaterialStateProperty.resolveWith(
                    //               //                 (states) =>
                    //               //                     HexColor('8346E1')),
                    //               //         value: this.value,
                    //               //         onChanged: (value) {
                    //               //           setState(() {
                    //               //             this.value = value!;
                    //               //           });
                    //               //         },
                    //               //         shape: RoundedRectangleBorder(
                    //               //           borderRadius:
                    //               //               BorderRadius.circular(4.0),
                    //               //         ),
                    //               //       ),
                    //               //     ),
                    //               //     SizedBox(width: 5),
                    //               //     Text(
                    //               //       "Keep me Logged in",
                    //               //       style: TextStyle(
                    //               //           fontSize: 12,
                    //               //           fontWeight: FontWeight.w600,
                    //               //           color: Colors.grey),
                    //               //     )
                    //               //   ],
                    //               // ),
                    //             ],
                    //           ),
                    //         ),
                    //         _isLoading
                    //             ? Loading()
                    //             : Padding(
                    //                 padding: const EdgeInsets.only(top: 10.0),
                    //                 child: ElevatedButton(
                    //                   child: Center(
                    //                     child: Text(
                    //                       'Log in',
                    //                       textScaleFactor: min(
                    //                           horizontalScale, verticalScale),
                    //                       style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 22,
                    //                           fontWeight: FontWeight.w600),
                    //                     ),
                    //                   ),
                    //                   style: ElevatedButton.styleFrom(
                    //                     primary: HexColor('8346E1'),
                    //                   ),
                    //                   onPressed: () {
                    //                     if (email.text.isEmpty ||
                    //                         pass.text.isEmpty) {
                    //                       Fluttertoast.showToast(
                    //                           msg:
                    //                               "Please enter email or password");
                    //                     }

                    //                     if (_loginkey.currentState!
                    //                         .validate()) {
                    //                       setState(() {
                    //                         _isLoading = true;
                    //                       });
                    //                       logIn(email.text, pass.text)
                    //                           .then((user) async {
                    //                         if (user != null) {
                    //                           print(user);
                    //                           showToast(
                    //                               'Logged in Successfully');
                    //                           Navigator.pushAndRemoveUntil(
                    //                               context,
                    //                               PageTransition(
                    //                                   duration: Duration(
                    //                                       milliseconds: 200),
                    //                                   curve: Curves.bounceInOut,
                    //                                   type: PageTransitionType
                    //                                       .rightToLeftWithFade,
                    //                                   child: HomePage()),
                    //                               (route) => false);
                    //                           setState(() {
                    //                             _isLoading = false;
                    //                           });
                    //                         } else {
                    //                           setState(() {
                    //                             _isLoading = false;
                    //                           });
                    //                           {
                    //                             showDialog(
                    //                                 context: context,
                    //                                 builder:
                    //                                     (BuildContext context) {
                    //                                   return AlertDialog(
                    //                                       title: Center(
                    //                                         child: Text(
                    //                                           'Error',
                    //                                           textScaleFactor: min(
                    //                                               horizontalScale,
                    //                                               verticalScale),
                    //                                           style: TextStyle(
                    //                                               color: Colors
                    //                                                   .red,
                    //                                               fontSize: 24,
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                       ),
                    //                                       content: Text(
                    //                                         '       There is no user record \n corresponding to the identifier.',
                    //                                         textScaleFactor: min(
                    //                                             horizontalScale,
                    //                                             verticalScale),
                    //                                         style: TextStyle(
                    //                                             fontSize: 16),
                    //                                       ),
                    //                                       actions: [
                    //                                         TextButton(
                    //                                             child: Text(
                    //                                                 'Retry'),
                    //                                             onPressed: () {
                    //                                               Navigator.pop(
                    //                                                   context,
                    //                                                   true);
                    //                                             })
                    //                                       ]);
                    //                                 });
                    //                           }
                    //                           showToast('Login failed');
                    //                         }
                    //                       });
                    //                     }
                    //                   },
                    //                 ),
                    //               ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(top: 10),
                    //           child: Container(
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   'Don’t have an account? ',
                    //                   textScaleFactor:
                    //                       min(horizontalScale, verticalScale),
                    //                   style: TextStyle(fontSize: 20),
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       formVisible = true;
                    //                       _formIndex = 2;
                    //                     });
                    //                   },
                    //                   child: Center(
                    //                     child: Text(
                    //                       'Sign Up',
                    //                       textScaleFactor: min(
                    //                           horizontalScale, verticalScale),
                    //                       style: TextStyle(
                    //                           fontFamily: 'SemiBold',
                    //                           color: HexColor('5E1EC0'),
                    //                           fontSize: 20),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(top: 10.0),
                    //           child: Container(
                    //             child: Row(
                    //               children: [
                    //                 Expanded(
                    //                   child: Divider(
                    //                     color: Colors.black,
                    //                     thickness: 2,
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: horizontalScale * 10,
                    //                 ),
                    //                 Text(
                    //                   'OR',
                    //                   textScaleFactor:
                    //                       min(horizontalScale, verticalScale),
                    //                   style: TextStyle(
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.w600),
                    //                 ),
                    //                 SizedBox(
                    //                   width: horizontalScale * 10,
                    //                 ),
                    //                 Expanded(
                    //                   child: Divider(
                    //                     color: Colors.black,
                    //                     thickness: 2,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(top: 15.0),
                    //           child: InkWell(
                    //             onTap: () async {
                    //               // try {
                    //               //   setState(() {
                    //               //     googleloading = true;
                    //               //   });
                    //               //   await provider.googleLogin(
                    //               //     context,
                    //               //      // listOfAllExistingUser,
                    //               //   );
                    //               //   print(provider);
                    //               //   setState(() {
                    //               //     googleloading = false;
                    //               //   });
                    //               // } catch (e) {
                    //               //   print("Google error is here : ${e.toString()}");
                    //               // }
                    //             },
                    //             child: googleloading!
                    //                 ? Center(child: CircularProgressIndicator())
                    //                 : Container(
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white,
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       border: Border.all(
                    //                           color: Colors.black, width: 1),
                    //                       // boxShadow: [
                    //                       //   color: Colors.white, //background color of box
                    //                       //   BoxShadow(
                    //                       //     color: HexColor('977EFF'),
                    //                       //     blurRadius: 10.0, // soften the shadow
                    //                       //     offset: Offset(
                    //                       //       0, // Move to right 10  horizontally
                    //                       //       2.0, // Move to bottom 10 Vertically
                    //                       //     ),
                    //                       //   )
                    //                       // ],
                    //                     ),
                    //                     child: googleloading!
                    //                         ? CircularProgressIndicator(
                    //                             strokeWidth: 2,
                    //                             color: HexColor("2C2C2C"),
                    //                           )
                    //                         : Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.start,
                    //                             children: [
                    //                               SizedBox(
                    //                                 width: 5,
                    //                               ),
                    //                               SvgPicture.asset(
                    //                                 'assets/google.svg',
                    //                                 height: min(horizontalScale,
                    //                                         verticalScale) *
                    //                                     26,
                    //                                 width: min(horizontalScale,
                    //                                         verticalScale) *
                    //                                     26,
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                               ),
                    //                               Text(
                    //                                 'Continue with Google',
                    //                                 textScaleFactor: min(
                    //                                     horizontalScale,
                    //                                     verticalScale),
                    //                                 style: TextStyle(
                    //                                     color:
                    //                                         HexColor("2C2C2C"),
                    //                                     fontSize: 18,
                    //                                     fontWeight:
                    //                                         FontWeight.w600),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                   ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: (formVisible)
                      ? (_formIndex == 1)
                          ? Container(
                              color: Colors.black54,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.06)),
                                            ),
                                            child: Text(
                                              'Login',
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                              style: TextStyle(
                                                color: HexColor('6153D3'),
                                                fontSize: 16,
                                              ),
                                            )),
                                        SizedBox(
                                          width: horizontalScale * 17,
                                        ),
                                        IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                // formVisible = false;
                                              });
                                            },
                                            icon: Icon(Icons.clear))
                                      ],
                                    ),
                                    Container(
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        child: LoginForm(
                                          page: "OnBoard",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.black54,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.06)),
                                            ),
                                            child: Text('SignUp',
                                                textScaleFactor: min(
                                                    horizontalScale,
                                                    verticalScale),
                                                style: TextStyle(
                                                  color: HexColor('6153D3'),
                                                  fontSize: 18,
                                                ))),
                                        SizedBox(
                                          width: horizontalScale * 17,
                                        ),
                                        IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                // formVisible = false;
                                              });
                                            },
                                            icon: Icon(Icons.clear))
                                      ],
                                    ),
                                    Container(
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        child: SignUpform(
                                            // listOfAllExistingUser:
                                            //     listOfAllExistingUser,
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                      : null),
              // AnimatedSwitcher(
              //     duration: Duration(milliseconds: 200),
              //     child: (phoneVisible)
              //         ? Container(
              //       color: Colors.black54,
              //       alignment: Alignment.center,
              //       child: SingleChildScrollView(
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 ElevatedButton(
              //                     onPressed: () {},
              //                     style: ElevatedButton.styleFrom(
              //                       primary: Colors.white,
              //                       shape: RoundedRectangleBorder(
              //                           borderRadius: BorderRadius.circular(
              //                               width * 0.06)),
              //                     ),
              //                     child: Text('OTP Verification',
              //                         textScaleFactor: min(
              //                             horizontalScale, verticalScale),
              //                         style: TextStyle(
              //                           color: HexColor('6153D3'),
              //                           fontSize: 18,
              //                         ))),
              //                 SizedBox(
              //                   width: horizontalScale * 17,
              //                 ),
              //                 IconButton(
              //                     color: Colors.white,
              //                     onPressed: () {
              //                       setState(() {
              //                         phoneVisible = false;
              //                       });
              //                     },
              //                     icon: Icon(Icons.clear))
              //               ],
              //             ),
              //             Container(
              //               child: AnimatedSwitcher(
              //                 duration: Duration(milliseconds: 200),
              //                 child: PhoneAuthentication(),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     )
              //         : null)
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                    constraints:
                                        const BoxConstraints(maxHeight: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Image.asset(
                                        'assets/loginoop.png')), //assets/logingif.json
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('CloudyML',
                                style: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800)))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'We will send you an ',
                                    style: TextStyle(
                                        color: MyColors.primaryColor)),
                                TextSpan(
                                    text: 'One Time Password ',
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'on this mobile number',
                                    style: TextStyle(
                                        color: MyColors.primaryColor)),
                              ]),
                            )),
                        Container(
                          height: 40,
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CupertinoTextField(
                            maxLength: 10,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            controller: phoneController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            placeholder: '+91...',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (phoneController.text.isNotEmpty) {
                              globals.phone = phoneController.text.toString();
                              getCodeWithPhoneNumber(context,
                                  "${'+91' + phoneController.text.toString()}");
                            } else {
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Please enter a phone number',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            constraints: const BoxConstraints(maxWidth: 500),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      // Color(0xFF8A2387),
                                      Color.fromRGBO(120, 96, 220, 1),
                                      Color.fromRGBO(120, 96, 220, 1),
                                      Color.fromARGB(255, 88, 52, 246),
                                    ])),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: loading
                                ? Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white))),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 0, 0),
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: MyColors.primaryColorLight,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  
                                  
                          ),
                          

                        ),
                        SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: () async {
                                          final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: 'app.support@cloudyml.com',
                                              query: 'subject=Query about App');
                                          var mailurl = params.toString();
                                          if (await canLaunch(mailurl)) {
                                            await launch(mailurl);
                                          } else {
                                            throw 'Could not launch $mailurl';
                                          }
                                        },
                                        child: Text(
                                          'Need Help with Login?',
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          style: TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 19,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 10),
                        //   constraints:
                        //       const BoxConstraints(maxWidth: 500),
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       if (phoneController.text.isNotEmpty) {
                        //         loginStore.getCodeWithPhoneNumber(context,
                        //             "+91${phoneController.text.toString()}");
                        //       } else {
                        //         loginStore.loginScaffoldKey.currentState
                        //             ?.showSnackBar(SnackBar(
                        //           behavior: SnackBarBehavior.floating,
                        //           backgroundColor: Colors.red,
                        //           content: Text(
                        //             'Please enter a phone number',
                        //             style: TextStyle(color: Colors.white),
                        //           ),
                        //         ));
                        //       }
                        //     },
                        //     color: MyColors.primaryColor,
                        //     shape: const RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.all(
                        //             Radius.circular(14))),
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 8, horizontal: 8),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text(
                        //             'Next',
                        //             style: TextStyle(color: Colors.white),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             decoration: BoxDecoration(
                        //               borderRadius:
                        //                   const BorderRadius.all(
                        //                       Radius.circular(20)),
                        //               color: MyColors.primaryColorLight,
                        //             ),
                        //             child: Icon(
                        //               Icons.arrow_forward_ios,
                        //               color: Colors.white,
                        //               size: 16,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }),

    );
  }

  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    // try {
    //   final userCredential = await FirebaseAuth.instance.signInAnonymously();
    //   print("Signed in with temporary account.");
    // } on FirebaseAuthException catch (e) {
    //   switch (e.code) {
    //     case "operation-not-allowed":
    //       print("Anonymous auth hasn't been enabled for this project.");
    //       break;
    //     default:
    //       print("Unknown error.");
    //   }
    // }

    // final docSnapshot = await FirebaseFirestore.instance
    //     .collection('UserData')
    //     .doc()
    //     .set({"phone": phoneNumber, "date": DateTime.now()});

    setState(() {
      loading = true;
    });
    List<dynamic> items = [];
    var docSnapshots;
    try {
      print("1");
      docSnapshots = await FirebaseFirestore.instance
          .collection('Users')
          .where('mobilenumber', isEqualTo: phoneController.text.toString())
          .get();
      await FirebaseFirestore.instance
          .collection('Users')
          .where('mobilenumber', isEqualTo: phoneController.text.toString())
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((f) => items.add(f.data()));
      });
      print("2");

      print("1sdkfffffj$docSnapshots");

      if (docSnapshots == null) {
        print("3");
        docSnapshots = await FirebaseFirestore.instance
            .collection('Users')
            .where('mobilenumber',
            isEqualTo: phoneNumber)
            .get();

        items.clear();
        print("4");

        await FirebaseFirestore.instance
            .collection('Users')
            .where('mobilenumber', isEqualTo: phoneNumber)
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) => items.add(f.data()));
        });
        print("2sdkfffffj$docSnapshots");
      }
      print("5");

      // docSnapshots.then((QuerySnapshot snapshot) {
      //   snapshot.docs.forEach((f) => items.add(f.data()));
      // });
      print("6");
      // print(doc.contains("linked"));
      // print(items[0]);
      Map data = items[0];
      globals.googleAuth = data.containsValue("googleAuth").toString();
      globals.linked = data.containsKey("linked").toString();
      print("ddddddddddddddd");
      print(globals.googleAuth);
      print(globals.linked);
      print("dsdssssssssssssssssss");
      print("7");

      // print(doc.keys.contains("email"));
      // print(doc.containsValue("true"));
      // print(doc.containsKey("email"));

      final userSnapshot = docSnapshots.docs.first;
      print("8");
      globals.phoneNumberexists = userSnapshot.exists.toString();
      // print("------------------------------------------------");
      // print(docSnapshots.docs.contains("email"));
      // print(docSnapshots.docChanges.contains("emaill"));
      // print("------------------------------------------------");

      // if (docSnapshots.docChanges.contains("linked")) {
      //   globals.linked = 'true';
      //   showToast("linked true");
      // }
    } catch (e) {
      print(e);
      print("9");
    }

    // try {
    //   final docSnapshots = await FirebaseFirestore.instance
    //       .collection('Users')
    //       .where('linked', isEqualTo: "true")
    //       .get();

    //   final userSnapshot = docSnapshots.docs.first;
    //   globals.linked = userSnapshot.exists.toString();
    // } catch (e) {
    //   print(e);
    // }

    // showToast(phoneNumber);
    print("10");
    if (true) {
      print("11");
      setState(() {
        loading = true;
      });
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential auth) async {
            await _auth.signInWithCredential(auth).then((dynamic value) {
              print("1");
              if (value != null && value.user != null) {
                setState(() {
                  loading = false;
                  print("2");
                });
                print('Authentication successful');

                // onAuthenticationSuccessful(context, value);
              } else {
                setState(() {
                  loading = false;
                });
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    'Invalid code/invalid authentication',
                    style: TextStyle(color: Colors.white),
                  ),
                );
                print("3");
              }
            }).catchError((error) {
              setState(() {
                loading = false;
              });

              showToast(error);
            });
          },
          verificationFailed: (dynamic authException) {
            showToast('Error message: ' + authException.message);
            print('Error message: ' + authException.message);
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
                style: TextStyle(color: Colors.white),
              ),
            );
            setState(() {
              loading = false;
            });
          },
          codeSent: (String verificationId, int? forceResendingToken) async {
            setState(() {
              loading = false;
            });
            actualCode = verificationId;
            globals.actualCode = verificationId;
            globals.phone = phoneNumber;

            setState(() {
              loading = false;
            });

            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => OtpPage()));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            actualCode = verificationId;
            globals.actualCode = verificationId;
          });
    }
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, dynamic result) async {
    // firebaseUser = result.user;

    var user = FirebaseAuth.instance.currentUser;
    if (globals.name != "") {
      if (user != null) {
        setState(() {
          loading = false;
        });
        DocumentSnapshot userDocs = await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (userDocs.data() == null) {
          userprofile(
              name: globals.name,
              image: '',
              mobilenumber: globals.phone,
              authType: 'phoneAuth',
              phoneVerified: true,
              email: globals.email);
        }
      } else {
        setState(() {
          loading = false;
        });
        showToast('user does not exist');
      }
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
        (Route<dynamic> route) => false);
  }
}
