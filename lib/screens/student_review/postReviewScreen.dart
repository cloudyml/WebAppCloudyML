import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/global_variable.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_theme.dart';
import 'package:cloudyml_app2/screens/student_review/ReviewApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';
import 'package:toast/toast.dart';
import '../../global_variable.dart' as globals;

class PostReviewScreen extends StatefulWidget {
  @override
  State<PostReviewScreen> createState() => _PostReviewScreenState();
}

class _PostReviewScreenState extends State<PostReviewScreen> {
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
          print('start1');
          value.docs.forEach((element) {
            print('start2');
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
          loading = false;
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
    print("jjjjjjjjjjjjjj1: ${courseList}");
    print("jjjjjjjjjjjjjj2: ${coursemoduelmap}");
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

  double fontSize = 30.0;
  double fontSize1 = 30.0;
  double fontSize2 = 30.0;
  double fontSize3 = 30.0;
  double fontSize4 = 30.0;

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
        fontSize = 46.0;
        fontSize1 = 30.0;
        fontSize2 = 30.0;
        fontSize3 = 30.0;
        fontSize4 = 30.0;
      }
      if (i == 1) {
        fontSize = 30.0;
        fontSize1 = 46.0;
        fontSize2 = 30.0;
        fontSize3 = 30.0;
        fontSize4 = 30.0;
      }
      if (i == 2) {
        fontSize = 30.0;
        fontSize1 = 30.0;
        fontSize2 = 46.0;
        fontSize3 = 30.0;
        fontSize4 = 30.0;
      }
      if (i == 3) {
        fontSize = 30.0;
        fontSize1 = 30.0;
        fontSize2 = 30.0;
        fontSize3 = 46.0;
        fontSize4 = 30.0;
      }
      if (i == 4) {
        fontSize = 30.0;
        fontSize1 = 30.0;
        fontSize2 = 30.0;
        fontSize3 = 30.0;
        fontSize4 = 46.0;
      }
    });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define breakpoints for different screen sizes
    final isPhone =
        screenWidth < 600; // Adjust the value as needed for laptop screens

    return Scaffold(
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(isPhone
            ? 16.0
            : 32.0), // Adjust the padding for different screen sizes
        child: Material(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(
                        width: isPhone
                            ? 5.0
                            : 30.0, // Adjust spacing for different screen sizes
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Let us know your experience with us! \u{1F60A}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.abhayaLibre().fontFamily,
                            fontSize: isPhone
                                ? 14.0
                                : 25.0, // Adjust font size for different screen sizes
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 35, 176, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 222, 214, 248),
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: isPhone
                        ? screenWidth
                        : 500, // Adjust width for different screen sizes
                    padding: EdgeInsets.all(26.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Your Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Course Enrolled In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                              child: courseloading
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator()),
                                      ),
                                    )
                                  : DropdownButton<String>(
                                      focusColor: Colors.white,
                                      underline: Container(),
                                      isExpanded: true,
                                      // // Step 3.
                                      value: tempcoursename,
                                      // Step 4.

                                      items: courseList
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Lexend Deca',
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      // Step 5.
                                      onChanged: (String? newValue) {
                                        try {
                                          _courseController.text = newValue!;
                                          setState(() {
                                            print('ft1');
                                            print(newValue);
                                            print(
                                                '${coursemoduelmap[newValue].runtimeType}');
                                            try {} catch (e) {
                                              print(e);
                                            }

                                            print('ft3');
                                            tempcoursename = newValue!;
                                            print('ft4');
                                          });
                                        } catch (e) {
                                          print("rrrrrrr: ${e}");
                                        }
                                      },
                                    ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'LinkedIn Url',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _linkdinlinkController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Rate Your Experience',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 2300),
                            width: 300,
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
                          SizedBox(height: 16.0),
                          Text(
                            'Write a Review',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _reviewdescriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Date of Experience',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _selectStartDate(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    experienceStartDate != null
                                        ? '${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year}'
                                        : 'Select Start Date',
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => _selectEndDate(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    experienceEndDate != null
                                        ? '${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}'
                                        : 'Select End Date',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: isPhone
                                  ? 32.0
                                  : 64.0), // Adjust spacing for different screen sizes
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                print('wew1');
                                if (_nameController.text.isEmpty) {
                                  Toast.show('Name is required');
                                  print('wew2');
                                } else if (!isValidEmail(
                                    _emailController.text)) {
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
                                  Toast.show(
                                      'Please enter a valid LinkedIn URL');
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
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                        fontSize: 18.0,
                                      ),
                                    ),
                            ),
                          )
                        ],
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

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidLinkedInUrl(String url) {
    return url.contains('linkedin.com');
  }
}
