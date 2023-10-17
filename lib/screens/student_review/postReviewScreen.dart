import 'package:cloudyml_app2/global_variable.dart';
import 'package:cloudyml_app2/screens/student_review/ReviewApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

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

  DateTime? experienceStartDate;
  DateTime? experienceEndDate;

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

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        width: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Let us know your experience with us! \u{1F60A}',
                          style: TextStyle(
                              fontFamily: GoogleFonts.abhayaLibre().fontFamily,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 35, 176, 40)),
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
                    width: screenWidth * 1 / 2,
                    padding: const EdgeInsets.all(26.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _courseController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'LinkedIn Url',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, index) {
                              Text textData;
                              switch (index) {
                                case 0:
                                  textData = Text(
                                    '\u{1F922}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                                case 1:
                                  textData = Text(
                                    '\u{1F612}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                                case 2:
                                  textData = Text(
                                    '\u{1F642}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                                case 3:
                                  textData = Text(
                                    '\u{1F60A}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                                case 4:
                                  textData = Text(
                                    '\u{1F929}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                                default:
                                  textData = Text(
                                    '\u{1FAE0}', // Unicode escape sequence for the emoji
                                    style: TextStyle(
                                      fontSize:
                                          36, // Adjust the font size as needed
                                    ),
                                  );
                                  break;
                              }

                              return textData;
                            },
                            onRatingUpdate: (rating) {
                              _ratingController.text = rating.toString();
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Write a Review',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          SizedBox(height: 32.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_nameController.text.isEmpty) {
                                  // Name is required. Show an error message or handle it as needed.
                                  Toast.show('Name is required');
                                } else if (!isValidEmail(
                                    _emailController.text)) {
                                  // Email is not valid. Show an error message or handle it as needed.
                                  Toast.show(
                                      'Please enter a valid email address');
                                } else if (_courseController.text.isEmpty) {
                                  // Course is required. Show an error message or handle it as needed.
                                  Toast.show('Course is required');
                                } else if (!isValidLinkedInUrl(
                                    _linkdinlinkController.text)) {
                                  // LinkedIn URL is not in the correct format. Show an error message or handle it as needed.
                                  Toast.show(
                                      'Please enter a valid LinkedIn URL');
                                } else if (_ratingController.text.isEmpty) {
                                  // Rating is required. Show an error message or handle it as needed.
                                  Toast.show('Rating is required');
                                } else if (_reviewdescriptionController
                                    .text.isEmpty) {
                                  // Review description is required. Show an error message or handle it as needed.
                                  Toast.show('Review description is required');
                                } else if (experienceStartDate == null ||
                                    experienceEndDate == null) {
                                  // Experience dates are required. Show an error message or handle it as needed.
                                  Toast.show(
                                      'Please select start and end dates for your experience');
                                } else {
                                  // All input is valid; proceed with submission
                                  setState(() {
                                    loading = true;
                                  });
                                  Toast.show(await postReview({
                                    "name": _nameController.text,
                                    "email": _emailController.text,
                                    "course": _courseController.text,
                                    "linkdinlink": _linkdinlinkController.text,
                                    "reviewdescription":
                                        _reviewdescriptionController.text,
                                    "rating": _ratingController.text,
                                    "experience":
                                        "${experienceStartDate!.day}/${experienceStartDate!.month}/${experienceStartDate!.year} to ${experienceEndDate!.day}/${experienceEndDate!.month}/${experienceEndDate!.year}",
                                    "date": DateTime.now().toString(),
                                  }));

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
                                primary: Colors.blue, // Background color
                                onPrimary: Colors.white, // Text color
                                padding: EdgeInsets.all(
                                    16), // Padding inside the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the radius as needed
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
                                        fontSize: 18, // Text size
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
