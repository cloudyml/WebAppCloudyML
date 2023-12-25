import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../global_variable.dart' as globals;
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'coupon_api.dart';
import 'models/createCouponModel.dart';

class CreateCoupon extends StatefulWidget {
  const CreateCoupon({Key? key}) : super(key: key);

  @override
  _CreateCouponState createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController couponCode = TextEditingController();
  TextEditingController couponName = TextEditingController();
  TextEditingController couponDescription = TextEditingController();
  TextEditingController couponImageUrl = TextEditingController();
  TextEditingController couponValue = TextEditingController();
  TextEditingController valueType = TextEditingController();
  TextEditingController couponType = TextEditingController();
  TextEditingController validhours = TextEditingController();
  var validDate;
  var expireDate;

  List<String> listcoupontype = <String>[
    'Select Coupon Type',
    'global',
    'individual',
    'course'
  ];

  var selectcuppontype = 'Select Coupon Type';

  List<String> listcouponvaluetype = <String>[
    'Select Coupon Value Type',
    'percentage',
    'number'
  ];
  var selectcupponvaluetype = 'Select Coupon Value Type';
  var selectcupponvaliddate = 'Select Coupon Start and End Date/Time';
  var tempcoursename = 'Select Course Name';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getallcoursename();
  }

  getallcoursename() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .get()
          .then((value) {
        try {
          print('start1');
          value.docs.forEach((element) {
            try {
              globals.courseList.add(element['name']);
              print('start9');
            } catch (e) {
              print("error hhh $e");
            }
          });
        } catch (e) {
          print("error kkkl $e");
        }
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      globals.courseList;
    });
    print("jjjjjjjjjjjjjj3: ${globals.courseList}");
  }

  var docid;
  bool loadingcoursefeild = false;

  getdocid(coursename) async {
    setState(() {
      loadingcoursefeild = true;
    });
    await FirebaseFirestore.instance
        .collection("courses")
        .where("name", isEqualTo: coursename)
        .get()
        .then((value) {
      docid = value.docs.first.get("docid");
    }).whenComplete(() {
      setState(() {
        loadingcoursefeild = false;
      });
    });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : Align(
              alignment: AlignmentDirectional(0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height - 50,
                child: Card(
                  elevation: 0,
                  color: Color.fromARGB(107, 86, 113, 250),
                  semanticContainer: true,
                  child: Center(
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.min,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(28, 28, 28, 0),
                          child: TextFormField(
                            controller: couponCode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Coupon Code',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(28, 10, 28, 0),
                          child: TextFormField(
                            controller: couponName,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Coupon Name(optional)',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(28, 10, 28, 0),
                          child: TextFormField(
                            controller: couponDescription,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Coupon Description(optional)',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(28, 10, 28, 0),
                          child: TextFormField(
                            controller: couponImageUrl,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Coupon Image Url(optional)',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(27, 10, 27, 0),
                          child: TextFormField(
                            controller: couponValue,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Value',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(27, 0, 27, 0),
                              child: DropdownButton<String>(
                                value: selectcupponvaluetype,
                                hint: Text('Select Coupon Value Type'),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 131, 122, 122)),
                                underline: Container(
                                  height: 1,
                                  color: Color.fromARGB(255, 131, 122, 122),
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    selectcupponvaluetype = value!;
                                    valueType.text = value;
                                  });
                                },
                                items: listcouponvaluetype
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(27, 0, 27, 0),
                              child: DropdownButton<String>(
                                value: selectcuppontype,
                                hint: Text('Select Coupon Type'),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 131, 122, 122)),
                                underline: Container(
                                  height: 1,
                                  color: Color.fromARGB(255, 131, 122, 122),
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    selectcuppontype = value!;
                                    couponType.text = value;
                                  });
                                },
                                items: listcoupontype
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        selectcuppontype == 'individual'
                            ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    28, 28, 28, 0),
                                child: TextFormField(
                                  controller: validhours,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Valid for Hours',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        color: Colors.white,
                                      ),
                                ),
                              )
                            : Container(),
                        selectcuppontype == 'global' ||
                                selectcuppontype == 'course'
                            ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    27, 10, 27, 0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    List<DateTime>? dateTimeList =
                                        await showOmniDateTimeRangePicker(
                                      context: context,
                                      startInitialDate: DateTime.now(),
                                      startFirstDate: DateTime(1600)
                                          .subtract(const Duration(days: 3652)),
                                      startLastDate: DateTime.now().add(
                                        const Duration(days: 3652),
                                      ),
                                      endInitialDate: DateTime.now(),
                                      endFirstDate: DateTime(1600)
                                          .subtract(const Duration(days: 3652)),
                                      endLastDate: DateTime.now().add(
                                        const Duration(days: 3652),
                                      ),
                                      is24HourMode: false,
                                      isShowSeconds: false,
                                      minutesInterval: 1,
                                      secondsInterval: 1,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      constraints: const BoxConstraints(
                                        maxWidth: 350,
                                        maxHeight: 650,
                                      ),
                                      transitionBuilder:
                                          (context, anim1, anim2, child) {
                                        return FadeTransition(
                                          opacity: anim1.drive(
                                            Tween(
                                              begin: 0,
                                              end: 1,
                                            ),
                                          ),
                                          child: child,
                                        );
                                      },
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
                                      barrierDismissible: true,
                                      selectableDayPredicate: (dateTime) {
                                        // Disable 25th Feb 2023
                                        print("dataeijwoe:  ${dateTime}");
                                        if (dateTime == DateTime(2023, 2, 25)) {
                                          return false;
                                        } else {
                                          return true;
                                        }
                                      },
                                    );
                                    //
                                    print(
                                        "Start dateTime: ${dateTimeList?[0]}");
                                    setState(() {
                                      validDate =
                                          dateTimeList?[0].toIso8601String();
                                      expireDate =
                                          dateTimeList?[1].toIso8601String();
                                    });
                                    print("End dateTime: ${dateTimeList?[1]}");
                                  },
                                  text: validDate == null
                                      ? selectcupponvaliddate
                                      : "$validDate to $expireDate",
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color(0x004B39EF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              )
                            : Container(),
                        selectcuppontype == 'course'
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(27, 10, 27, 0),
                                child: Container(
                                  child: DropdownButton<String>(
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    underline: Container(),
                                    isExpanded: true,
                                    // // Step 3.
                                    value: tempcoursename,
                                    // Step 4.

                                    items: globals.courseList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: loadingcoursefeild == true
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Text(
                                                  value,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Lexend Deca',
                                                        color: Color.fromARGB(
                                                            255, 147, 152, 155),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                        ),
                                      );
                                    }).toList(),
                                    // Step 5.
                                    onChanged: (String? newValue) async {
                                      await getdocid(newValue);
                                      print('eeeeeeee:$docid');
                                      setState(() {
                                        tempcoursename = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                        loadingcoursefeild == true
                            ? Container()
                            : Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    27, 30, 27, 0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    // var reurn = await CreateCouponApi.verifyCoupon("sos");
                                    // print("wefjwjfoiw");
                                    // print(reurn);
                                    // var value = json.decode(reurn['message']);
                                    // print("reurn: ${value['result']['couponCode']}");

                                    if (true) {
                                      // Toast.show(reurn);
                                      if (selectcuppontype == 'course') {
                                        if (tempcoursename ==
                                            'Select Course Name') {
                                          Toast.show(
                                              "Please select course name");
                                          return;
                                        }
                                      }
                                      if (selectcuppontype !=
                                          'Select Coupon Type') {
                                        if (selectcupponvaluetype !=
                                            'Select Coupon Value Type') {
                                          if (selectcuppontype ==
                                              'individual') {
                                            if (validhours.text == "") {
                                              Toast.show(
                                                  "Please enter valid hours");
                                              return;
                                            }
                                            if (isNumeric(validhours.text) ==
                                                false) {
                                              Toast.show(
                                                  "Please enter valid hours");
                                              return;
                                            }
                                            // function for know if their is intiger in string or not

                                            setState(() {
                                              loading = true;
                                            });
                                            CreateCouponModel createCouponInfo =
                                                CreateCouponModel(
                                              course: docid,
                                              couponName: couponName.text,
                                              couponType: couponType.text,
                                              couponValue: CouponValue(
                                                  type: valueType.text,
                                                  value: couponValue.text),
                                              couponStartDate: validDate,
                                              couponExpiryDate: expireDate,
                                              couponImage: couponImageUrl.text,
                                              couponCode: couponCode.text,
                                              validforhours: validhours.text,
                                              couponDescription:
                                                  couponDescription.text,
                                              couponStatus: "not purchased",
                                            );
                                            var result = '';
                                            result = await CreateCouponApi
                                                .createCoupon(
                                                    createCouponInfo);
                                            Toast.show(result);
                                            if (result != '') {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          } else if (selectcuppontype ==
                                                  'global' &&
                                              validDate != null) {
                                            setState(() {
                                              loading = true;
                                            });
                                            CreateCouponModel createCouponInfo =
                                                CreateCouponModel(
                                              course: docid,
                                              couponName: couponName.text,
                                              couponType: couponType.text,
                                              couponValue: CouponValue(
                                                  type: valueType.text,
                                                  value: couponValue.text),
                                              couponStartDate: validDate,
                                              couponExpiryDate: expireDate,
                                              couponImage: couponImageUrl.text,
                                              couponCode: couponCode.text,
                                              couponDescription:
                                                  couponDescription.text,
                                              couponStatus: "not purchased",
                                            );
                                            var result = '';
                                            result = await CreateCouponApi
                                                .createCoupon(
                                                    createCouponInfo);
                                            Toast.show(result);
                                            if (result != '') {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          } else if (selectcuppontype ==
                                                  'course' &&
                                              validDate != null) {
                                            setState(() {
                                              loading = true;
                                            });
                                            CreateCouponModel createCouponInfo =
                                                CreateCouponModel(
                                                  course: docid,
                                              couponName: couponName.text,
                                              couponType: couponType.text,
                                              couponValue: CouponValue(
                                                  type: valueType.text,
                                                  value: couponValue.text),
                                              couponStartDate: validDate,
                                              couponExpiryDate: expireDate,
                                              couponImage: couponImageUrl.text,
                                              couponCode: couponCode.text,
                                              couponDescription:
                                                  couponDescription.text,
                                              couponStatus: "not purchased",
                                            );
                                            var result = '';
                                            result = await CreateCouponApi
                                                .createCoupon(
                                                    createCouponInfo);
                                            Toast.show(result);
                                            if (result != '') {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          } else {
                                            Toast.show(
                                                'Please Select Coupon Valid Date');
                                          }
                                        } else {
                                          Toast.show(
                                              'Please Select Coupon Value Type');
                                        }
                                      } else {
                                        Toast.show('Please Select Coupon Type');
                                      }
                                    }
                                  },
                                  text:
                                      loading ? 'Loading...' : 'Upload Coupon',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color.fromARGB(107, 86, 113, 250),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(0, 21, 0, 64),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
