import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/global_variable.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_theme.dart';
import 'package:cloudyml_app2/screens/student_review/ReviewApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart';
import 'package:toast/toast.dart';
import 'package:easy_formz_inputs/easy_formz_inputs.dart';

class ShowReviewDialog extends StatefulWidget {
  @override
  State<ShowReviewDialog> createState() => _ShowReviewDialogState();
}

class _ShowReviewDialogState extends State<ShowReviewDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _linkdinlinkController = TextEditingController();
  TextEditingController _reviewdescriptionController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  var tempcoursename = "Course Name";
  DateTime? experienceStartDate;
  DateTime? experienceEndDate;
  bool courseloading = false;
  final dateInput = DateInput.dirty(value: '09/03/2022');

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: experienceStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != experienceStartDate) {
      setState(() {
        experienceStartDate = picked;
      });
    }
  }

  getallcoursename() async {
    setState(() {
      courseloading = true;
    });
    try {
      var courseMap = {};
      await FirebaseFirestore.instance
          .collection('courses')
          .get()
          .then((value) {
        try {
          List tepcourse = [];
          value.docs.forEach((element) {
            try {
              for (var k in element['curriculum1']['${element['name']}']) {
                print('start3');
                try {
                  print('start4');
                  tepcourse.add(k['modulename']);
                  print('start5');
                } catch (e) {
                  print('start6');
                  print("error lll $e");
                }
              }
            } catch (e) {
              print("start error ${e}");
            }

            try {
              print('start7');
              coursemoduelmap["${element['name']}"] = tepcourse;
              print('start8');
              courseList.add(element['name']);
              print('start9');
              tepcourse = [];
            } catch (e) {
              print("error hhh $e");
            }
          });
        } catch (e) {
          print("error kkkl $e");
        }
      }).whenComplete(() {
        setState(() {
          courseloading = false;
        });
      });
    } catch (e) {
      setState(() {
        courseloading = false;
      });
    }
    setState(() {
      courseList;
    });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: experienceEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != experienceEndDate) {
      setState(() {
        experienceEndDate = picked;
      });
    }
  }

  bool isExpanded = false;

  double fontSize = 15.0;
  double fontSize1 = 15.0;
  double fontSize2 = 15.0;
  double fontSize3 = 15.0;
  double fontSize4 = 15.0;

  var rating = 5;

  @override
  void initState() {
    super.initState();
    getallcoursename();
    courseList = ["Course Name"];
  }

  void toggleExpansion(int i) {
    rating = i + 1;
    setState(() {
      isExpanded = !isExpanded;
      if (i == 0) {
        fontSize = 30.0;
        fontSize1 = 15.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 1) {
        fontSize = 15.0;
        fontSize1 = 30.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 2) {
        fontSize = 15.0;
        fontSize1 = 15.0;
        fontSize2 = 30.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 3) {
        fontSize = 15.0;
        fontSize2 = 15.0;
        fontSize1 = 15.0;
        fontSize3 = 30.0;
        fontSize4 = 15.0;
      }
      if (i == 4) {
        fontSize = 15.0;
        fontSize1 = 15.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 30.0;
      }
    });
  }

  bool loading = false;

  final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define breakpoints for different screen sizes
    final isPhone =
        screenWidth < 600; // Adjust the value as needed for laptop screens
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Let us know your experience with us! \u{1F60A}',
              style: TextStyle(
                fontFamily: GoogleFonts.abhayaLibre().fontFamily,
                fontSize: 14.sp, // Adjust font size for different screen sizes
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 35, 176, 40),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(0, 222, 214, 248),
                border: Border.all(width: 0.3),
                borderRadius: BorderRadius.circular(15.sp),
              ),
              width: isPhone
                  ? Adaptive.w(70)
                  : Adaptive.w(40), // Adjust width for different screen sizes
              padding: isPhone
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Your Email',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Course Enrolled In',
                      style: textStyle,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.grey,
                    //     ),
                    //     borderRadius: BorderRadius.circular(10.sp),
                    //   ),
                    //   height: courseloading ? 20.sp : 35.sp,
                    //   child: Padding(
                    //       padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    //       child: courseloading
                    //           ? Center(
                    //               child: Padding(
                    //                 padding: EdgeInsets.all(10.sp),
                    //                 child: SizedBox(
                    //                     height: 12.sp,
                    //                     width: 12.sp,
                    //                     child: CircularProgressIndicator()),
                    //               ),
                    //             )
                    //           :
                    //       DropdownButton<String>(
                    //         focusColor: Colors.white,
                    //         underline: Container(),
                    //         isExpanded: true,
                    //         // // Step 3.
                    //         value: tempcoursename,
                    //         // Step 4.
                    //
                    //         items: courseList
                    //             .map<DropdownMenuItem<String>>(
                    //                 (value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(
                    //                   value,
                    //                   // style: FlutterFlowTheme.of(context)
                    //                   //     .bodyText1
                    //                   //     .override(
                    //                   //   fontFamily: 'Lexend Deca',
                    //                   //   color: Colors.black,
                    //                   //   fontSize: 12.sp,
                    //                   //   fontWeight: FontWeight.bold,
                    //                   // ),
                    //                 ),
                    //               );
                    //             }).toList(),
                    //         // Step 5.
                    //         onChanged: (String? newValue) {
                    //           try {
                    //             _courseController.text = newValue!;
                    //             setState(() {
                    //               print('ft1');
                    //               print(newValue);
                    //               print(
                    //                   '${coursemoduelmap[newValue].runtimeType}');
                    //               try {} catch (e) {
                    //                 print(e);
                    //               }
                    //
                    //               print('ft3');
                    //               tempcoursename = newValue!;
                    //               print('ft4');
                    //             });
                    //           } catch (e) {
                    //             print("rrrrrrr: ${e}");
                    //           }
                    //         },
                    //       ),
                    //       ),
                    // ),
                    SizedBox(height: 8.sp),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'LinkedIn Url',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _linkdinlinkController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Rate Your Experience',
                      style: textStyle,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 2300),
                      width: Adaptive.w(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(0);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F922}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(1);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F612}',
                                style: TextStyle(
                                  fontSize: fontSize1,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(2);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F642}',
                                style: TextStyle(
                                  fontSize: fontSize2,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(3);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F60A}',
                                style: TextStyle(
                                  fontSize: fontSize3,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(4);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F929}',
                                style: TextStyle(
                                  fontSize: fontSize4,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Write a Review',
                      style: textStyle,
                    ),
                    TextFormField(
                      controller: _reviewdescriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        contentPadding: EdgeInsets.all(10.sp),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Date of Experience',
                      style: textStyle,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              experienceStartDate != null
                                  ? '${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year}'
                                  : 'Select Start Date',
                              style: textStyle,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              experienceEndDate != null
                                  ? '${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}'
                                  : 'Select End Date',
                              style: textStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            10.sp), // Adjust spacing for different screen sizes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Adaptive.w(15),
                          height: 20.sp,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                // Navigator.pop(widget.value);
                                BotToast.cleanAll();
                              },
                              child: Text(
                                "I'll do it later",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              )),
                        ),
                        SizedBox(
                          width: Adaptive.w(15),
                          height: 20.sp,
                          child: ElevatedButton(
                            onPressed: () async {
                              print('wew1');
                              if (_nameController.text.isEmpty) {
                                Toast.show('Name is required');
                                print('wew2');
                              } else if (!isValidEmail(_emailController.text)) {
                                print('wew3');
                                Toast.show(
                                    'Please enter a valid email address');
                              } else if (_courseController.text.isEmpty) {
                                print('wew4');
                                Toast.show('Course is required');
                                print('wew5');
                              } else if (!isValidLinkedInUrl(
                                  _linkdinlinkController.text)) {
                                print('wew6');
                                Toast.show('Please enter a valid LinkedIn URL');
                                print('wew7');
                              } else if (_reviewdescriptionController
                                  .text.isEmpty) {
                                print('wew8');
                                Toast.show('Review description is required');
                              }
                              // else if (experienceStartDate == null ||
                              //     experienceEndDate == null) {
                              //   print('wew9');
                              //   Toast.show(
                              //       'Please select start and end dates for your experience');
                              // }
                              else {
                                setState(() {
                                  loading = true;
                                });
                                print('wew10');
                                Toast.show(await postReview({
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "course": _courseController.text,
                                  "linkdinlink": _linkdinlinkController.text,
                                  "reviewdescription":
                                      _reviewdescriptionController.text,
                                  "rating": rating.toString(),
                                  "experience":
                                      "${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year} to ${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}",
                                  "date": DateTime.now().toString(),
                                }));
                                BotToast.cleanAll();
                                print('wew11');
                                setState(() {
                                  loading = false;
                                  _nameController.text = '';
                                  _emailController.text = '';
                                  _courseController.text = '';
                                  _linkdinlinkController.text = '';
                                  _reviewdescriptionController.text = '';
                                  _ratingController.text = '';
                                  experienceStartDate = null;
                                  experienceEndDate = null;
                                });

                                // Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Submit Review',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidLinkedInUrl(String url) {
    return url.contains('linkedin.com');
  }
}

class MobileReviewDialog extends StatefulWidget {
  @override
  State<MobileReviewDialog> createState() => _MobileReviewDialogState();
}

class _MobileReviewDialogState extends State<MobileReviewDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _linkdinlinkController = TextEditingController();
  TextEditingController _reviewdescriptionController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  var tempcoursename = "Course Name";
  DateTime? experienceStartDate;
  DateTime? experienceEndDate;
  bool courseloading = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: experienceStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != experienceStartDate) {
      setState(() {
        experienceStartDate = picked;
      });
    }
  }

  getallcoursename() async {
    setState(() {
      courseloading = true;
    });
    try {
      var courseMap = {};
      await FirebaseFirestore.instance
          .collection('courses')
          .get()
          .then((value) {
        try {
          List tepcourse = [];
          value.docs.forEach((element) {
            try {
              for (var k in element['curriculum1']['${element['name']}']) {
                try {
                  tepcourse.add(k['modulename']);
                } catch (e) {
                  print("error lll $e");
                }
              }
            } catch (e) {
              print("start error ${e}");
            }

            try {
              print('start7');
              coursemoduelmap["${element['name']}"] = tepcourse;
              print('start8');
              courseList.add(element['name']);
              print('start9');
              tepcourse = [];
            } catch (e) {
              print("error hhh $e");
            }
          });
        } catch (e) {
          print("error kkkl $e");
        }
      }).whenComplete(() {
        setState(() {
          courseloading = false;
        });
      });
    } catch (e) {
      setState(() {
        courseloading = false;
      });
    }
    setState(() {
      courseList;
    });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: experienceEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != experienceEndDate) {
      setState(() {
        experienceEndDate = picked;
      });
    }
  }

  bool isExpanded = false;

  double fontSize = 15.0;
  double fontSize1 = 15.0;
  double fontSize2 = 15.0;
  double fontSize3 = 15.0;
  double fontSize4 = 15.0;

  var rating = 5;

  @override
  void initState() {
    super.initState();
    getallcoursename();
    courseList = ["Course Name"];
  }

  void toggleExpansion(int i) {
    rating = i + 1;
    setState(() {
      isExpanded = !isExpanded;
      if (i == 0) {
        fontSize = 30.0;
        fontSize1 = 15.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 1) {
        fontSize = 15.0;
        fontSize1 = 30.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 2) {
        fontSize = 15.0;
        fontSize1 = 15.0;
        fontSize2 = 30.0;
        fontSize3 = 15.0;
        fontSize4 = 15.0;
      }
      if (i == 3) {
        fontSize = 15.0;
        fontSize2 = 15.0;
        fontSize1 = 15.0;
        fontSize3 = 30.0;
        fontSize4 = 15.0;
      }
      if (i == 4) {
        fontSize = 15.0;
        fontSize1 = 15.0;
        fontSize2 = 15.0;
        fontSize3 = 15.0;
        fontSize4 = 30.0;
      }
    });
  }

  bool loading = false;

  final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adaptive.h(58),
      width: Adaptive.w(100),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Let us know your experience with us! \u{1F60A}',
              style: TextStyle(
                fontFamily: GoogleFonts.abhayaLibre().fontFamily,
                fontSize: 14.sp, // Adjust font size for different screen sizes
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 35, 176, 40),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(0, 222, 214, 248),
                border: Border.all(width: 0.3),
                borderRadius: BorderRadius.circular(15.sp),
              ),
              width: Adaptive.w(65), // Adjust width for different screen sizes
              padding: EdgeInsets.only(
                  left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      'Your Email',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      'Course Enrolled In',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.grey,
                    //     ),
                    //     borderRadius: BorderRadius.circular(10.sp),
                    //   ),
                    //   height: 20.sp,
                    //   child: Padding(
                    //     padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    //     child: courseloading
                    //         ? Center(
                    //             child: Padding(
                    //               padding: EdgeInsets.all(10.sp),
                    //               child: SizedBox(
                    //                   height: 12.sp,
                    //                   width: 12.sp,
                    //                   child: CircularProgressIndicator()),
                    //             ),
                    //           )
                    //         :
                    //
                    //     DropdownButton<String>(
                    //             focusColor: Colors.white,
                    //             underline: Container(),
                    //             isExpanded: true,
                    //             // // Step 3.
                    //             value: tempcoursename,
                    //             // Step 4.
                    //
                    //             items: courseList
                    //                 .map<DropdownMenuItem<String>>((value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(
                    //                   value,
                    //                   style: FlutterFlowTheme.of(context)
                    //                       .bodyText1
                    //                       .override(
                    //                         fontFamily: 'Lexend Deca',
                    //                         color: Colors.black,
                    //                         fontSize: 12.sp,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                 ),
                    //               );
                    //             }).toList(),
                    //             // Step 5.
                    //             onChanged: (String? newValue) {
                    //               try {
                    //                 _courseController.text = newValue!;
                    //                 setState(() {
                    //                   print('ft1');
                    //                   print(newValue);
                    //                   print(
                    //                       '${coursemoduelmap[newValue].runtimeType}');
                    //                   try {} catch (e) {
                    //                     print(e);
                    //                   }
                    //
                    //                   print('ft3');
                    //                   tempcoursename = newValue!;
                    //                   print('ft4');
                    //                 });
                    //               } catch (e) {
                    //                 print("rrrrrrr: ${e}");
                    //               }
                    //             },
                    //           )
                    //     ,
                    //   ),
                    // ),
                    SizedBox(height: 12.sp),
                    Text(
                      'LinkedIn Url',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 20.sp,
                      child: TextFormField(
                        controller: _linkdinlinkController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          contentPadding: EdgeInsets.all(10.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      'Rate Your Experience',
                      style: textStyle,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 2300),
                      width: Adaptive.w(35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(0);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F922}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(1);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F612}',
                                style: TextStyle(
                                  fontSize: fontSize1,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(2);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F642}',
                                style: TextStyle(
                                  fontSize: fontSize2,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(3);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F60A}',
                                style: TextStyle(
                                  fontSize: fontSize3,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleExpansion(4);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 2300),
                              child: Text(
                                '\u{1F929}',
                                style: TextStyle(
                                  fontSize: fontSize4,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      'Write a Review',
                      style: textStyle,
                    ),
                    TextFormField(
                      controller: _reviewdescriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        contentPadding: EdgeInsets.all(10.sp),
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      'Date of Experience',
                      style: textStyle,
                    ),
                    SizedBox(height: 12.sp),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              experienceStartDate != null
                                  ? '${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year}'
                                  : 'Select Start Date',
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        GestureDetector(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              experienceEndDate != null
                                  ? '${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}'
                                  : 'Select End Date',
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            15.sp), // Adjust spacing for different screen sizes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Adaptive.w(25),
                          height: 20.sp,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                // BotToast.closeAllLoading();
                                BotToast.cleanAll();
                              },
                              child: Text(
                                "I'll do it later",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              )),
                        ),
                        SizedBox(
                          width: Adaptive.w(25),
                          height: 20.sp,
                          child: ElevatedButton(
                            onPressed: () async {
                              print('wew1');
                              if (_nameController.text.isEmpty) {
                                Toast.show('Name is required');
                                print('wew2');
                              } else if (!isValidEmail(_emailController.text)) {
                                print('wew3');
                                Toast.show(
                                    'Please enter a valid email address');
                              } else if (_courseController.text.isEmpty) {
                                print('wew4');
                                Toast.show('Course is required');
                                print('wew5');
                              } else if (!isValidLinkedInUrl(
                                  _linkdinlinkController.text)) {
                                print('wew6');
                                Toast.show('Please enter a valid LinkedIn URL');
                                print('wew7');
                              } else if (_reviewdescriptionController
                                  .text.isEmpty) {
                                print('wew8');
                                Toast.show('Review description is required');
                              } else if (experienceStartDate == null ||
                                  experienceEndDate == null) {
                                print('wew9');
                                Toast.show(
                                    'Please select start and end dates for your experience');
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                print('wew10');
                                Toast.show(await postReview({
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "course": _courseController.text,
                                  "linkdinlink": _linkdinlinkController.text,
                                  "reviewdescription":
                                      _reviewdescriptionController.text,
                                  "rating": rating.toString(),
                                  "experience":
                                      "${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year} to ${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}",
                                  "date": DateTime.now().toString(),
                                }));
                                BotToast.cleanAll();
                                print('wew11');
                                setState(() {
                                  loading = false;
                                  _nameController.text = '';
                                  _emailController.text = '';
                                  _courseController.text = '';
                                  _linkdinlinkController.text = '';
                                  _reviewdescriptionController.text = '';
                                  _ratingController.text = '';
                                  experienceStartDate = null;
                                  experienceEndDate = null;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Submit Review',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidLinkedInUrl(String url) {
    return url.contains('linkedin.com');
  }
}
