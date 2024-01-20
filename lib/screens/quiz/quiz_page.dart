import 'dart:math';
import 'dart:ui';
import 'package:cloudyml_app2/screens/coupon/coupon_api.dart';
import 'package:cloudyml_app2/screens/coupon/models/createCouponModel.dart';
import 'package:cloudyml_app2/screens/quiz/certificatemodel.dart';
import 'package:cloudyml_app2/screens/quiz/congralutation_scholarship.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/screens/quiz/quizsolution.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:toast/toast.dart';
import '../../global_variable.dart' as globals;
import 'certificate_api.dart';
import 'model/quiztrackmodel.dart';
import 'quiz_model.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'congralutation_screen.dart';

class QuizPage extends StatefulWidget {
  var quizdata;
  bool? scholarshipQuiz;
  String? docid;
  QuizPage(this.quizdata, this.scholarshipQuiz, this.docid, {Key? key})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool showquestion = false;

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  List quizdata = [];
  String timer = "00:00:00";

  @override
  void initState() {
    super.initState();
    print("uuuiiioookljlk");
    quizdata = widget.quizdata['questionbucket'];
    // quizdata.shuffle();
    var temquiz = quizdata;
    try {
      quizdata =
          quizdata.take(widget.quizdata['numberofquestiontodisplay']).toList();
    } catch (e) {
      quizdata = temquiz;
    }
    getQuiz();
  }

  var userName = '';
  var email = '';
  var contactnumber = '';

  Future<String> handlingCasesAccoridingToTotal(
      double total, List quizdata, String courseid, var correctint) async {
    print("total is $total");
    // coursequizwindowindays
    int coursequizwindowindays = 0;
    int modulerquizwindowinhours = 0;
    int coursequizpassingpercentage = 0;
    int modulequizpassingpercentage = 0;
    QuizTrackModel? quizTrackModel;
    String returningString = "";
    int coursequizwindowindaysmorethan50percent = 0;

    if (globals.quizCleared) {
      if (total >= coursequizpassingpercentage ||
          total >= modulequizpassingpercentage) {
        return "Congratulations!";
      } else {
        return "You didn't clear the quiz but it won't affect your result";
      }
    }

    // removing the quiz from the quiztrack list
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        var data = value.data()!['quiztrack'];
        print("data id iwjore9fjwj3r32r1 ${data.length}");
        int customIndex = 0;
        for (var i in data) {
          try {
            i = QuizTrackModel.fromJson(i);
            if (widget.quizdata['name'] == i.quizname) {
              print("wwiejfowjeojwefjwjfe $customIndex ${i.quizname}");
              await data.removeAt(customIndex);
              print("data $customIndex id iwjore9fjwj3r32r1 ${data.length}");
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "quiztrack": await data,
              });
              print("data id iwjore9fjwj3r32r2 ${data.length}");
            }
          } catch (e) {
            print("errorid: sdfwefwef323: ${e}");
          }
          customIndex = customIndex + 1;
        }
      });
    } catch (e) {
      print("errorid: fwf9398wfeu: ${e}");
    }

    // getting the variables from the controllers collection
    try {
      await FirebaseFirestore.instance
          .collection("Controllers")
          .doc("variables")
          .get()
          .then((value) {
        coursequizwindowindays = value.data()!['coursequizwindowindays'];
        print("coursequizwindowindays: $coursequizwindowindays");
        modulerquizwindowinhours = value.data()!['modulerquizwindowinhours'];
        coursequizpassingpercentage =
            value.data()!['coursequizpassingpercentage'];
        coursequizwindowindaysmorethan50percent =
            value.data()!['coursequizwindowindaysmorethan50percent'];
        modulequizpassingpercentage =
            value.data()!['modulequizpassingpercentage'];
      });
    } catch (e) {
      print("errorid: ff93u98e9w: ${e}");
    }

    // course quiz cleared condition
    try {
      if (total >= coursequizpassingpercentage &&
          widget.quizdata['quizlevel'] == "courselevel") {
        print("course quiz cleared");
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then(
          (value) {
            userName = value.data()!['name'];
            email = value.data()!['email'];
            contactnumber = value.data()!['mobilenumber'];
          },
        );
        // track this quiz in user's doc
        quizTrackModel = QuizTrackModel(
          scholarshipQuiz: widget.scholarshipQuiz,
          quizname: widget.quizdata['name'],
          quizScore: total,
          date: DateTime.now(),
          quizlevel: widget.quizdata['quizlevel'],
          courseName: widget.quizdata['courseName'],
          courseId: courseid,
          quizCleared: true,
          quizAttemptGapForModularQuiz:
              DateTime.now().add(Duration(hours: modulerquizwindowinhours)),
          quizAttemptGapForCourseQuiz:
              DateTime.now().add(Duration(days: coursequizwindowindays)),
          quizTakenTime: countUsedTime(),
          quizMark: correctint.toString(),
          quizdata: quizdata,
        );
        returningString = "Congratulations!";
      }
    } catch (e) {
      print("errorid: f32ifjwejjfiwe: ${e}");
    }

    // course quiz not cleared condition with above 50% condition
    try {
      if (total >= 50 &&
          total < coursequizpassingpercentage &&
          widget.quizdata['quizlevel'] == "courselevel") {
        print("course quiz not cleared");
        // open this quiz after 3 days
        quizTrackModel = QuizTrackModel(
            scholarshipQuiz: widget.scholarshipQuiz,
            quizname: widget.quizdata['name'],
            quizdata: quizdata,
            quizScore: total,
            date: DateTime.now(),
            quizlevel: widget.quizdata['quizlevel'],
            courseName: widget.quizdata['courseName'],
            courseId: courseid,
            quizCleared: false,
            quizAttemptGapForModularQuiz:
                DateTime.now().add(Duration(hours: modulerquizwindowinhours)),
            quizAttemptGapForCourseQuiz:
                DateTime.now().add(Duration(days: coursequizwindowindays)),
            quizTakenTime: countUsedTime(),
            quizMark: correctint.toString());
        returningString =
            "  You have not cleared the quiz${'\n'}You can attempt this quiz again${'\n'}                after ${coursequizwindowindaysmorethan50percent} days";
        if (widget.scholarshipQuiz == true) {
          returningString =
              "It appears that your performance on this quiz did not meet the expected standards";
        }
      }
    } catch (e) {
      print("errorid: r82u93r9fw3: ${e}");
    }

    // course quiz not cleared condition with below 50% condition
    try {
      if (total < 50 && widget.quizdata['quizlevel'] == "courselevel") {
        print("course quiz not cleared with less than 50%");
        // open this quiz after 7 days
        quizTrackModel = QuizTrackModel(
            scholarshipQuiz: widget.scholarshipQuiz,
            quizname: widget.quizdata['name'],
            quizdata: quizdata,
            quizScore: total,
            date: DateTime.now(),
            quizlevel: widget.quizdata['quizlevel'],
            courseName: widget.quizdata['courseName'],
            courseId: courseid,
            quizCleared: false,
            quizAttemptGapForModularQuiz:
                DateTime.now().add(Duration(hours: modulerquizwindowinhours)),
            quizAttemptGapForCourseQuiz: DateTime.now()
                .add(Duration(days: coursequizwindowindaysmorethan50percent)),
            quizTakenTime: countUsedTime(),
            quizMark: correctint.toString());
        returningString =
            "  You have not cleared the quiz${'\n'}You can attempt this quiz again${'\n'}                after ${coursequizwindowindays} days";
        if (widget.scholarshipQuiz == true) {
          returningString =
              "It appears that your performance on this quiz did not meet the expected standards";
        }
      }
    } catch (e) {
      print("errorid: i23rjo23jio2: ${e}");
    }

    // module quiz cleared condition
    try {
      if (total >= modulequizpassingpercentage &&
          widget.quizdata['quizlevel'] == "modulelevel") {
        print("module quiz cleared");
        quizTrackModel = QuizTrackModel(
          scholarshipQuiz: widget.scholarshipQuiz,
          quizname: widget.quizdata['name'],
          quizdata: quizdata,
          quizScore: total,
          date: DateTime.now(),
          quizlevel: widget.quizdata['quizlevel'],
          courseName: widget.quizdata['courseName'],
          courseId: courseid,
          quizCleared: true,
          quizAttemptGapForModularQuiz:
              DateTime.now().add(Duration(hours: modulerquizwindowinhours)),
          quizAttemptGapForCourseQuiz:
              DateTime.now().add(Duration(days: coursequizwindowindays)),
        );
        returningString = "Congratulations!";
      }
    } catch (e) {
      print("errorid: wuhfiw3r23r23: ${e}");
    }

    // module quiz not cleared condition
    try {
      if (total < modulequizpassingpercentage &&
          widget.quizdata['quizlevel'] == "modulelevel") {
        print("module quiz not cleared");
        // open this quiz after 6 hours
        quizTrackModel = QuizTrackModel(
          scholarshipQuiz: widget.scholarshipQuiz,
          quizname: widget.quizdata['name'],
          quizdata: quizdata,
          quizScore: total,
          date: DateTime.now(),
          quizlevel: widget.quizdata['quizlevel'],
          courseName: widget.quizdata['courseName'],
          courseId: courseid,
          quizCleared: false,
          quizAttemptGapForModularQuiz:
              DateTime.now().add(Duration(hours: modulerquizwindowinhours)),
          quizAttemptGapForCourseQuiz:
              DateTime.now().add(Duration(days: coursequizwindowindays)),
        );
        returningString =
            "  You have not cleared the quiz${'\n'}You can attempt this quiz again${'\n'}                after ${modulerquizwindowinhours} hours";
        if (widget.scholarshipQuiz == true) {
          returningString =
              "It appears that your performance on this quiz did not meet the expected standards";
        }
      }
    } catch (e) {
      print("errorid: fif3sdwf: ${e}");
    }

    // update the quiztrack in user's doc
    try {
      print("update the quiztrack in user's doc ${quizTrackModel!.toJson()}");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "quiztrack": FieldValue.arrayUnion([quizTrackModel!.toJson()])
      });
    } catch (e) {
      print("errorid: efwif23r2r3ref: ${e}");
    }

    return returningString;
  }

  countDownTimer(quiztiming) async {
    try {
      int timerCount = int.parse("$quiztiming") * 60;

      for (int x = timerCount; x > 0; x--) {
        await Future.delayed(Duration(seconds: 1)).then((_) {
          if (timerCount == 1) {
            submit();
            print("stop timing now");
          }
          setState(() {
            timerCount -= 1;
          });
          final now = Duration(seconds: timerCount);
          setState(() {
            timer = _printDuration(now);
          });
          print("${_printDuration(now)}");
        });
      }
    } catch (e) {}
  }

  bool submitvalue = false;

  bool listsHaveSameElements(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    list1.sort();
    list2.sort();

    for (var i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  String generateRandomCode() {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    StringBuffer codeBuffer = StringBuffer();

    for (int i = 0; i < 6; i++) {
      int randomIndex = random.nextInt(charset.length);
      codeBuffer.write(charset[randomIndex]);
    }

    return codeBuffer.toString();
  }

  createCoupon(total) async {
    var couponcode = generateRandomCode();
    // Get the current date and time
    DateTime now = DateTime.now();

    // Add 3 hours to the current date and time
    int validforhours = 3;
    DateTime newDateTime = now.add(Duration(hours: validforhours));

    // Convert the updated DateTime to ISO 8601 string
    String couponExpiryDate = newDateTime.toIso8601String();
    CreateCouponModel createCouponInfo = CreateCouponModel(
      course: widget.docid,
      couponName: '',
      couponType: 'scholarship',
      couponValue: CouponValue(
          type: 'number', value: "${(total * 20).toStringAsFixed(0)}"), //
      couponStartDate: DateTime.now().toIso8601String(),
      couponExpiryDate: couponExpiryDate,
      couponImage: '',
      couponCode: couponcode,
      validforhours: validforhours.toString(),
      couponDescription: '',
      couponStatus: "not purchased",
    );
    await CreateCouponApi.createCoupon(createCouponInfo);
    hitApiEndpoint(couponcode, couponExpiryDate);
  }

  Future<void> hitApiEndpoint(couponcode, couponExpiryDate) async {
    final String apiUrl =
        'https://us-central1-cloudyml-app.cloudfunctions.net/mailapi/discouponmail';

    final Map<String, dynamic> requestBody = {
      "couponcode": couponcode,
      "cname": widget.quizdata['courseName'],
      "sname": globals.name,
      "semail": globals.email,
      "validtilltime": couponExpiryDate
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('API Request Successful');
        print('Response: ${response.body}');
        // You can handle the response here
      } else {
        print('API Request Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        // You can handle the error response here
      }
    } catch (e) {
      print('Error during API request: $e');
      // Handle any exceptions that occurred during the request
    }
  }

  void showQuizConfirmationDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return QuizConfirmationDialog();
      },
    ).then((value) {
      // Handle the result (true for submit, false for cancel)
      if (value == true) {
        submit();
        print('Quiz submitted!');
      } else {
        // User canceled submission
        print('Quiz submission canceled.');
      }
    });
  }

  submit() async {
    print("lll1");
    try {
// Navigation
      print("lll001");
      setState(() {
        submitvalue = true;
      });
      // upload quiz data
      var correctint = 0;
      print("lll002: $quizdata");

      for (var i in quizdata) {
        print(i['question']);
        print(i['answeredValue']);
        print(i['answerIndex']);
        if (i['answer'].length > 1) {
          try {
            if (listsHaveSameElements(
                i['answeredValueList'], i['answerIndex'])) {
              correctint += 1;
            }
          } catch (e) {
            print("errorid: 2r3r23r23r: ${e}");
          }
        } else {
          try {
            if (i['answeredValue'] == i['answerIndex'][0]) {
              correctint += 1;
            }
          } catch (e) {
            print("errorid: 2r3r23r23r: ${e}");
          }
        }
      }
      print("lll2");
      var unanswered = 0;
      print("dsfosweweweeeeeeeee");
      for (var i in quizdata) {
        print(i['question']);
        print(i['answeredValue']);

        try {
          if (i['answer'].length > 1) {
            try {
              if (i['answeredValueList'].length == 0) {
                unanswered += 1;
              }
            } catch (e) {
              print("errorid: 2r3r23r23r: ${e}");
            }
          } else {
            if (i['answeredValue'] == null) {
              unanswered += 1;
            }
          }
        } catch (e) {
          print("errorid: 2r3r23r23rffffff: ${e}");
        }
      }
      var wronganswered = 0;
      print("ijofijweio");
      for (var i in quizdata) {
        print(i['question']);
        var answeredvaluelist = [i['answeredValue']];
        try {
          if (i['answer'].length > 1) {
            try {
              if (listsHaveSameElements(
                      i['answeredValueList'], i['answerIndex']) ==
                  false) {
                wronganswered += 1;
              }
            } catch (e) {
              print("errorid: 2r3r23r23r: ${e}");
            }
          } else {
            if (answeredvaluelist[0] != null) {
              print("lllpp");
              print(i['answerIndex']);
              if (answeredvaluelist[0] != i['answerIndex'][0]) {
                print("equallleeii");
                wronganswered += 1;
              }
            }
          }
        } catch (e) {
          print("errorid: 2r3r23r23ruuuuuu: ${e}");
        }
        print(answeredvaluelist);
      }
      print("lll4");
      var total = (correctint / quizdata.length) * 100;
      print("lll5");
      var courseid = "";
      await FirebaseFirestore.instance
          .collection("courses")
          .where("name", isEqualTo: widget.quizdata['courseName'])
          .get()
          .then((value) async {
        courseid = await value.docs[0]['id'];
      });
      print("****************");
      print(widget.quizdata['courseName']);
      print("the course id is-----lklklkl$courseid");

      var resultString = await handlingCasesAccoridingToTotal(
          total, quizdata, courseid, correctint);
      // await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get()
      //     .then(
      //   (value) {
      //     userName = value.data()!['name'];
      //   },
      // );

      if (total > 0 && widget.scholarshipQuiz == true) {
        resultString = "Congratulations!";
        await createCoupon(total);
      }

      if (widget.quizdata['quizlevel'] == "courselevel") {
        if (resultString == "Congratulations!") {
          if (widget.scholarshipQuiz == true) {
            // await createCoupon(total);
          } else {
            CertificateModel Model = CertificateModel(
                uid: FirebaseAuth.instance.currentUser!.uid,
                name: userName,
                course: courseid,
                finishdate: DateTime.now().day.toString() +
                    "-" +
                    DateTime.now().month.toString() +
                    "-" +
                    DateTime.now().year.toString());
            await certificateApi.getCertificate(Model);
          }
        }
      }

      if (widget.scholarshipQuiz == true) {
        try {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "list_of_attempted_scholarshipquiz":
                FieldValue.arrayUnion([widget.docid]),
          });
        } catch (e) {
          print("$e");
        }
      }

      await FirebaseFirestore.instance.collection("quizTaken").add({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "quizInfo": quizdata,
        "finishdate": DateTime.now().day.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().year.toString(),
        "course": courseid,
        "name": userName,
        "quizlevel": widget.quizdata['quizlevel'],
      });

      print("lll6");
      print("isfojsoiefj${total} ${unanswered} ${wronganswered} ${correctint}");
      print("lll7");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CongratulationsWidget(
                quizdata,
                total,
                unanswered,
                wronganswered,
                correctint,
                widget.quizdata,
                resultString,
                countUsedTime(),
                quizdata.length.toString(),
                widget.scholarshipQuiz)),
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Certificate(),
      //   ),
      // );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => QuizSolutionCopyWidget(
      //         quizdata, total, unanswered, wronganswered, correctint),
      //   ),
      // );
      print("lll8");
    } catch (e) {
      print("llllllllll//: ${e.toString()}");
      setState(() {
        submitvalue = false;
      });
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String quiztiming = '';
  int questionindex = 0;
  bool markreview = false;
  int savedcount = 0;

  int lengthofquizquestion = 0;

  bool A = false;
  bool B = false;
  bool C = false;
  bool D = false;

  int answeredM = 0;
  int notAnsweredM = 0;
  int notVisitedM = 0;
  int MFR_M = 0;
  int AMFR_M = 0;

  saveNext(fromRightcircles) {
    setState(() {
      if (true) {
        // logic for visited
        if (questionindex != quizdata.length - 1) {
          quizdata[questionindex + 1]["visited"] = true;
        }

        // logic for keeping not answered value
        if (A == false &&
            B == false &&
            C == false &&
            D == false &&
            quizdata[questionindex]["answeredValue"] != 'A' &&
            quizdata[questionindex]["answeredValue"] != 'B' &&
            quizdata[questionindex]["answeredValue"] != 'C' &&
            quizdata[questionindex]["answeredValue"] != 'D') {
          quizdata[questionindex]["notAnswered"] = true;
          if (markreview) {
            quizdata[questionindex]["MFR"] = true;
            markreview = false;
          }
        } else {
          if (markreview) {
            quizdata[questionindex]["AMFR"] = true;
            markreview = false;
          }
        }

        // logic for keeping answered value
        List<String> answeredValueList = [];
        if (A == true) {
          answeredValueList.add("A");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "A";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            A = false;
          });
        }
        if (B == true) {
          answeredValueList.add("B");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "B";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            B = false;
          });
        }
        if (C == true) {
          answeredValueList.add("C");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "C";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            C = false;
          });
        }
        if (D == true) {
          answeredValueList.add("D");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "D";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            D = false;
          });
        }
        if (quizdata.length != questionindex + 1) {
          if (!fromRightcircles) {
            questionindex += 1;
          }
        }
        try {
          quizdata[questionindex]["OptionsImage"]['A'];
          print(
              'ijfoiweofjw1: ${quizdata[questionindex]["OptionsImage"]['A']}');
          if (quizdata[questionindex]["OptionsImage"]['A'] != "") {
            setState(() {
              showimagea = true;
            });
          }
          print('ijfoiweofjw2: $showimagea');
          if (quizdata[questionindex]["OptionsImage"]['A'] == '' ||
              quizdata[questionindex]["OptionsImage"]['A'] == null) {
            setState(() {
              showimagea = false;
            });
          }
        } catch (e) {
          setState(() {
            showimagea = false;
          });
          print("error: $e");
        }

        try {
          quizdata[questionindex]["OptionsImage"]['B'];
          if (quizdata[questionindex]["OptionsImage"]['B'] != "") {
            setState(() {
              showimageb = true;
            });
          }

          if (quizdata[questionindex]["OptionsImage"]['B'] == '' ||
              quizdata[questionindex]["OptionsImage"]['B'] == null) {
            setState(() {
              showimageb = false;
            });
          }
        } catch (e) {
          setState(() {
            showimageb = false;
          });
          print("error: $e");
        }

        try {
          quizdata[questionindex]["OptionsImage"]['C'];
          if (quizdata[questionindex]["OptionsImage"]['C'] != "") {
            setState(() {
              showimagec = true;
            });
          }

          if (quizdata[questionindex]["OptionsImage"]['C'] == '' ||
              quizdata[questionindex]["OptionsImage"]['C'] == null) {
            setState(() {
              showimagec = false;
            });
          }
        } catch (e) {
          setState(() {
            showimagec = false;
          });
          print("error: $e");
        }

        try {
          quizdata[questionindex]["OptionsImage"]['D'];
          if (quizdata[questionindex]["OptionsImage"]['D'] != "") {
            setState(() {
              showimaged = true;
            });
          }
          try {
            print(
                "tghrthrt  ${quizdata[questionindex]["question"].toString().split("(--image--)")[1]}");
            setState(() {
              showquestion = true;
            });
          } catch (e) {
            setState(() {
              showquestion = false;
            });
            print("eifjwgvygvu1 $e");
          }
          print("eifjweoj ${quizdata[questionindex]["OptionsImage"]['D']}");
          setState(() {
            if (quizdata[questionindex]["OptionsImage"]['D'] != "") {
              showimaged = true;
            }
          });

          if (quizdata[questionindex]["OptionsImage"]['D'] == '' ||
              quizdata[questionindex]["OptionsImage"]['D'] == null) {
            setState(() {
              showimaged = false;
            });
          }
        } catch (e) {
          setState(() {
            showimaged = false;
          });
          print("error: $e");
        }
      }
    });
    countParameter('saveNext');
  }

  bool showimagea = false;
  bool showimageb = false;
  bool showimagec = false;
  bool showimaged = false;

  save() {
    setState(() {
      if (true) {
        // logic for visited
        if (questionindex != quizdata.length - 1) {
          quizdata[questionindex + 1]["visited"] = true;
        }

        // logic for keeping not answered value
        if (A == false &&
            quizdata[questionindex]["answeredValue"] != 'A' &&
            quizdata[questionindex]["answeredValue"] != 'B' &&
            quizdata[questionindex]["answeredValue"] != 'C' &&
            quizdata[questionindex]["answeredValue"] != 'D' &&
            B == false &&
            C == false &&
            D == false) {
          quizdata[questionindex]["notAnswered"] = true;
        }

        // logic for keeping answered value
        List<String> answeredValueList = [];
        if (A == true) {
          answeredValueList.add("A");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "A";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            A = false;
          });
        }
        if (B == true) {
          answeredValueList.add("B");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "B";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            B = false;
          });
        }
        if (C == true) {
          answeredValueList.add("C");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "C";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            C = false;
          });
        }
        if (D == true) {
          answeredValueList.add("D");
          quizdata[questionindex]["answeredValueList"] = answeredValueList;
          quizdata[questionindex]["answeredValue"] = "D";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            D = false;
          });
        }
      }
    });
    try {
      quizdata[questionindex]["OptionsImage"]['A'];
      if (quizdata[questionindex]["OptionsImage"]['A'] != "") {
        setState(() {
          showimagea = true;
        });
      }

      if (quizdata[questionindex]["OptionsImage"]['A'] == '' ||
          quizdata[questionindex]["OptionsImage"]['A'] == null) {
        setState(() {
          showimagea = false;
        });
      }
    } catch (e) {
      setState(() {
        showimagea = false;
      });
      print("error: $e");
    }

    try {
      quizdata[questionindex]["OptionsImage"]['B'];
      if (quizdata[questionindex]["OptionsImage"]['B'] != "") {
        setState(() {
          showimageb = true;
        });
      }

      if (quizdata[questionindex]["OptionsImage"]['B'] == '' ||
          quizdata[questionindex]["OptionsImage"]['B'] == null) {
        setState(() {
          showimageb = false;
        });
      }
    } catch (e) {
      setState(() {
        showimageb = false;
      });
      print("error: $e");
    }

    try {
      quizdata[questionindex]["OptionsImage"]['C'];
      if (quizdata[questionindex]["OptionsImage"]['C'] != "") {
        setState(() {
          showimagec = true;
        });
      }

      if (quizdata[questionindex]["OptionsImage"]['C'] == '' ||
          quizdata[questionindex]["OptionsImage"]['C'] == null) {
        setState(() {
          showimagec = false;
        });
      }
    } catch (e) {
      setState(() {
        showimagec = false;
      });
      print("error: $e");
    }

    try {
      quizdata[questionindex]["OptionsImage"]['D'];
      if (quizdata[questionindex]["OptionsImage"]['D'] != "") {
        setState(() {
          showimaged = true;
        });
      }
      try {
        print(
            "tghrthrt  ${quizdata[questionindex]["question"].toString().split("(--image--)")[1]}");
        setState(() {
          showquestion = true;
        });
      } catch (e) {
        setState(() {
          showquestion = false;
        });
        print("eifjwgvygvu2 $e");
      }
      print("eifjweoj ${quizdata[questionindex]["OptionsImage"]['D']}");

      if (quizdata[questionindex]["OptionsImage"]['D'] == '' ||
          quizdata[questionindex]["OptionsImage"]['D'] == null) {
        setState(() {
          showimaged = false;
        });
      }
    } catch (e) {
      setState(() {
        showimaged = false;
      });
      print("error: $e");
    }

    countParameter("save");
  }

  countParameter(fun) async {
    answeredM = 0;
    notAnsweredM = 0;
    if (fun == 'saveNext') {
      notVisitedM = lengthofquizquestion;
    }
    print('ijoejioe');
    MFR_M = 0;
    AMFR_M = 0;
    // counting answeredM
    for (var i in quizdata) {
      print('ijoejioe1');
      try {
        if (i["Answered"] == true) {
          setState(() {
            answeredM += 1;
          });
        }
      } catch (e) {
        print("answeredM error: $e");
      }
    }
    print("ijoejioe001");
    // counting notAnsweredM
    for (var j in quizdata) {
      try {
        if (j["notAnswered"] == true) {
          setState(() {
            notAnsweredM += 1;
          });
        }
      } catch (e) {
        print("notAnsweredM error: $e");
      }
    }
    print("ijoejioe002");
    // counting notVisitedM
    if (fun == 'saveNext') {
      for (var k in quizdata) {
        try {
          if (k["visited"] == true) {
            setState(() {
              notVisitedM -= 1;
            });
            print("notvisitedm $notVisitedM");
          }
        } catch (e) {
          print("notVisitedM error: $e");
        }
      }
    }

    print('ijoejioe2');
    // counting MFR_M
    for (var l in quizdata) {
      try {
        if (l["MFR"] == true) {
          setState(() {
            MFR_M += 1;
          });
        }
      } catch (e) {
        print("MFR_M error: $e");
      }
    }
    print('ijoejioe3');
    // counting AMFR_M
    for (var m in quizdata) {
      try {
        if (m["AMFR"] == true) {
          setState(() {
            AMFR_M += 1;
          });
        }
      } catch (e) {
        print("AMFR_M error: $e");
      }
    }
    print('ijoejioe4');
    try {
      quizdata[questionindex]["OptionsImage"]['A'];
      setState(() {
        showimagea = true;
      });
      if (quizdata[questionindex]["OptionsImage"]['A'] == '' ||
          quizdata[questionindex]["OptionsImage"]['A'] == null) {
        setState(() {
          showimagea = false;
        });
      }
    } catch (e) {
      setState(() {
        showimagea = false;
      });
      print("error: $e");
    }
    print('ijoejioe5');
    try {
      quizdata[questionindex]["OptionsImage"]['B'];
      setState(() {
        showimageb = true;
      });
      if (quizdata[questionindex]["OptionsImage"]['B'] == '' ||
          quizdata[questionindex]["OptionsImage"]['B'] == null) {
        setState(() {
          showimageb = false;
        });
      }
    } catch (e) {
      setState(() {
        showimageb = false;
      });
      print("error: $e");
    }
    print('ijoejioe6');
    try {
      quizdata[questionindex]["OptionsImage"]['C'];
      setState(() {
        showimagec = true;
      });
      if (quizdata[questionindex]["OptionsImage"]['C'] == '' ||
          quizdata[questionindex]["OptionsImage"]['C'] == null) {
        setState(() {
          showimagec = false;
        });
      }
    } catch (e) {
      setState(() {
        showimagec = false;
      });
      print("error: $e");
    }

    try {
      quizdata[questionindex]["OptionsImage"]['D'];
      setState(() {
        showimaged = true;
      });
      if (quizdata[questionindex]["OptionsImage"]['D'] == '' ||
          quizdata[questionindex]["OptionsImage"]['D'] == null) {
        setState(() {
          showimaged = false;
        });
      }
    } catch (e) {
      setState(() {
        showimaged = false;
      });
      print("error: $e");
    }
    print('ijoejioe7');
  }

  getQuiz() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (value) {
          setState(() {
            userName = value.data()!['name'];
            email = value.data()!['email'];
            contactnumber = value.data()!['mobilenumber'];
          });
        },
      );
    } catch (e) {
      print("kkkmijojo: ${e}");
    }

    try {
      quiztiming = widget.quizdata['quiztiming'];
      setState(() {
        quizdata;
      });
      quizdata[0]["visited"] = true;
      for (var i in quizdata) {
        i['answeredValueList'] = [];
      }
      print("quizdata:  ${quizdata}");
      notVisitedM = quizdata.length;
      lengthofquizquestion = quizdata.length;
      countParameter("saveNext");
      countDownTimer(widget.quizdata['quiztiming']);
      try {
        quizdata[questionindex]["OptionsImage"]['A'];
        setState(() {
          showimagea = true;
        });
        if (quizdata[questionindex]["OptionsImage"]['A'] == '' ||
            quizdata[questionindex]["OptionsImage"]['A'] == null) {
          setState(() {
            showimagea = false;
          });
        }
      } catch (e) {
        setState(() {
          showimagea = false;
        });
        print("error: $e");
      }
      try {
        quizdata[questionindex]["OptionsImage"]['B'];
        setState(() {
          showimageb = true;
        });
        if (quizdata[questionindex]["OptionsImage"]['B'] == '' ||
            quizdata[questionindex]["OptionsImage"]['B'] == null) {
          setState(() {
            showimageb = false;
          });
        }
      } catch (e) {
        setState(() {
          showimageb = false;
        });
        print("error: $e");
      }
      try {
        quizdata[questionindex]["OptionsImage"]['C'];
        setState(() {
          showimagec = true;
        });
        if (quizdata[questionindex]["OptionsImage"]['C'] == '' ||
            quizdata[questionindex]["OptionsImage"]['C'] == null) {
          setState(() {
            showimagec = false;
          });
        }
      } catch (e) {
        setState(() {
          showimagec = false;
        });
        print("error: $e");
      }
      try {
        quizdata[questionindex]["OptionsImage"]['D'];
        setState(() {
          showimaged = true;
        });
        if (quizdata[questionindex]["OptionsImage"]['D'] == '' ||
            quizdata[questionindex]["OptionsImage"]['D'] == null) {
          setState(() {
            showimaged = false;
          });
        }
      } catch (e) {
        setState(() {
          showimaged = false;
        });
        print("error: $e");
      }
    } catch (e) {
      print("jjoijoijo: ${e}");
    }
    try {
      print(
          "tghrthrt  ${quizdata[questionindex]["question"].toString().split("(--image--)")[1]}");
      setState(() {
        showquestion = true;
      });
    } catch (e) {
      setState(() {
        showquestion = false;
      });
      print("eifjwgvygvu3 $e");
    }
  }

  String countUsedTime() {
    String totalTime =
        "${int.parse(widget.quizdata['quiztiming']) ~/ 60}:${int.parse(widget.quizdata['quiztiming']) % 60}:00";
    String remainingTime = timer;

    List<int> totalParts = totalTime.split(':').map(int.parse).toList();
    List<int> remainingParts = remainingTime.split(':').map(int.parse).toList();

    int totalSeconds =
        totalParts[0] * 3600 + totalParts[1] * 60 + totalParts[2];
    int remainingSeconds =
        remainingParts[0] * 3600 + remainingParts[1] * 60 + remainingParts[2];
    int usedSeconds = totalSeconds - remainingSeconds;

    int usedHours = usedSeconds ~/ 3600;
    int usedMinutes = (usedSeconds % 3600) ~/ 60;
    int usedSecondsRemaining = usedSeconds % 60;

    return "${usedHours.toString().padLeft(2, '0')}:${usedMinutes.toString().padLeft(2, '0')}:${usedSecondsRemaining.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Stack(children: [
        !submitvalue
            ? SafeArea(
                child: GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(_unfocusNode),
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (responsiveVisibility(
                              context: context,
                              tablet: false,
                              tabletLandscape: false,
                              desktop: false,
                            ))
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF19F80F),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  '$answeredM',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Text(
                                                'Answered',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  '$notAnsweredM',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Text(
                                                'Not Answered',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF868585),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  '$notVisitedM',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Text(
                                                'Not Visited',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Text(
                                                    '$MFR_M',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Text(
                                                'Marked for \nReview',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 50),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Color(0x8F1487DD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Text(
                                                    '$AMFR_M',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  'Answered and Marked for review\n(will be considered for evaluation )',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1,
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
                            if (responsiveVisibility(
                              context: context,
                              tablet: false,
                              tabletLandscape: false,
                              desktop: false,
                            ))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 20, 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Container(
                                    width: 100,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 20, 20),
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 1,
                                        ),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: quizdata.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: (quizdata[index]['AMFR'] != null &&
                                                      quizdata[index]['AMFR'] !=
                                                          false
                                                  ? Color.fromARGB(
                                                      255, 80, 142, 218)
                                                  : quizdata[index]['MFR'] != null &&
                                                          quizdata[index]
                                                                  ['MFR'] !=
                                                              false
                                                      ? Color.fromARGB(
                                                          255, 50, 41, 219)
                                                      : quizdata[index]['Answered'] !=
                                                                  null &&
                                                              quizdata[index]['Answered'] !=
                                                                  false
                                                          ? Color.fromARGB(
                                                              255, 5, 217, 76)
                                                          : quizdata[index]['notAnswered'] !=
                                                                      null &&
                                                                  quizdata[index]
                                                                          ['notAnswered'] !=
                                                                      false
                                                              ? Color.fromARGB(255, 233, 26, 26)
                                                              : quizdata[index]['visited'] == null
                                                                  ? Color.fromARGB(255, 207, 196, 196)
                                                                  : Color.fromARGB(255, 207, 196, 196)),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Text(
                                                '${index + 1}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (responsiveVisibility(
                              context: context,
                              phone: false,
                            ))
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Visibility(
                                  visible: responsiveVisibility(
                                    context: context,
                                    phone: false,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (responsiveVisibility(
                                          context: context,
                                          phone: false,
                                        ))
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 10, 0, 0),
                                              child: Text(
                                                '',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyText1
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          valueOrDefault<Color>(
                                                        random_data
                                                            .randomColor(),
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground,
                                                      ),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Container(
                                            width: 325.9,
                                            height: 62.4,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                            ),
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: Visibility(
                                              visible: responsiveVisibility(
                                                context: context,
                                                phone: false,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    -1, -1),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    10, 0),
                                                        child: Icon(
                                                          Icons
                                                              .fullscreen_exit_sharp,
                                                          color: Colors.black,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 0),
                                                        child: Text(
                                                          'Remaining Time:',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .title3
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 18,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 0),
                                                      child: SizedBox(
                                                        height: 50,
                                                        width: 110,
                                                        child: Card(
                                                          // clipBehavior:
                                                          //     Clip.antiAliasWithSaveLayer,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                          elevation: 1,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0, 0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          10),
                                                              child: Text(
                                                                '$timer',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .title3
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-0.9, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              380,
                                          height: 71.2,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          alignment:
                                              AlignmentDirectional(-0.9, 0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(60, 0, 60, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          if (responsiveVisibility(
                                                            context: context,
                                                            phone: false,
                                                          ))
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -0.05, 0),
                                                              child: Card(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          15,
                                                                          10,
                                                                          15,
                                                                          10),
                                                                  child: Text(
                                                                    '${widget.quizdata['name']}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          fontSize:
                                                                              17,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          if (responsiveVisibility(
                                                            context: context,
                                                            phone: false,
                                                          ))
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Card(
                                                                  clipBehavior:
                                                                      Clip.antiAliasWithSaveLayer,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            15,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .clipboardList,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          size:
                                                                              24,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            15,
                                                                            10,
                                                                            15,
                                                                            10),
                                                                        child:
                                                                            Text(
                                                                          'Question Paper',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyText1
                                                                              .override(
                                                                                fontFamily: 'Poppins',
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                fontSize: 16,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (responsiveVisibility(
                                                    context: context,
                                                    tablet: false,
                                                    tabletLandscape: false,
                                                    desktop: false,
                                                  ))
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.05, -1),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.05, 0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          5),
                                                              child: SizedBox(
                                                                height: 50,
                                                                width: 100,
                                                                child: Card(
                                                                  // clipBehavior:
                                                                  //     Clip.antiAliasWithSaveLayer,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  elevation: 1,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        '$timer',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .title3
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 14,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      QuizReportDialog(
                                                    coursename: widget
                                                        .quizdata['courseName'],
                                                    modulename: widget
                                                        .quizdata['module'],
                                                    sname: userName,
                                                    email: email,
                                                    cno: contactnumber,
                                                    quiznumber:
                                                        questionindex + 1,
                                                    quizname:
                                                        widget.quizdata['name'],
                                                    subcname: '',
                                                    description: '',
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Report an error',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(width: 30),
                                            Container(
                                              width: 150,
                                              height: 71.2,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    100, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showQuizConfirmationDialog(
                                                          context);
                                                    },
                                                    child: Container(
                                                      width: 140,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF0A9E04),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          'SUBMIT',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(-0.55, -1),
                                          child: Container(
                                            width: 874,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                1.3,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Wrap(
                                              spacing: 0,
                                              runSpacing: 0,
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              runAlignment: WrapAlignment.start,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              clipBehavior: Clip.none,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1, -1),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      if (responsiveVisibility(
                                                        context: context,
                                                        tablet: false,
                                                        tabletLandscape: false,
                                                        desktop: false,
                                                      ))
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Question ${questionindex + 1}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .title3
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      if (responsiveVisibility(
                                                          context: context,
                                                          phone: false,
                                                          tablet: false))
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Question ${questionindex + 1}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .title3
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  // for multiple correct options

                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            40,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child: quizdata[questionindex]["answer"].length >
                                                                                1
                                                                            ? Text(
                                                                                '(Multiple Correct Option),',
                                                                                style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                              )
                                                                            : Text(
                                                                                'Single Correct Option,',
                                                                                style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                              ),
                                                                      ),
                                                                      Text(
                                                                        ' +1.00, ',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Color(0xFF4AAF0D),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        ' -0.00',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Color(0xFFDD2D68),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      Divider(
                                                        thickness: 1,
                                                        color:
                                                            Color(0xFF918888),
                                                      ),
                                                      // height: 500,
                                                      quizdata[questionindex]
                                                                      ["answer"]
                                                                  .length >
                                                              1
                                                          ? Container(
                                                              width: 1000,
                                                              height: 600,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            70,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Wrap(
                                                                          spacing:
                                                                              0,
                                                                          runSpacing:
                                                                              0,
                                                                          alignment:
                                                                              WrapAlignment.start,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.start,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          runAlignment:
                                                                              WrapAlignment.start,
                                                                          verticalDirection:
                                                                              VerticalDirection.down,
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: [
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1, 0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 30),
                                                                                child: Text(
                                                                                  '${quizdata[questionindex]["question"].toString().split("(--image--)")[0]}',
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontSize: 17,
                                                                                        fontWeight: FontWeight.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            quizdata[questionindex]["questionImage"] == null || quizdata[questionindex]["questionImage"] == ''
                                                                                ? Container()
                                                                                : Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 30),
                                                                                    child: SizedBox(child: Image.network('${quizdata[questionindex]["questionImage"]}', fit: BoxFit.cover)),
                                                                                  ),
                                                                            showquestion
                                                                                ? Align(
                                                                                    alignment: AlignmentDirectional(-1, 0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 30),
                                                                                      child: Text(
                                                                                        '${quizdata[questionindex]["question"].toString().split("(--image--)")[1]}',
                                                                                        textAlign: TextAlign.start,
                                                                                        style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontSize: 17,
                                                                                              fontWeight: FontWeight.normal,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    quizdata[questionindex]["options"]['A'] ==
                                                                            ""
                                                                        ? Container()
                                                                        : Align(
                                                                            alignment:
                                                                                AlignmentDirectional(-1, 0),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  A = !A;
                                                                                  print("clicked A: $A");
                                                                                });
                                                                                save();
                                                                              },
                                                                              child: quizdata[questionindex]["options"]['A'] == ""
                                                                                  ? Container()
                                                                                  : Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        quizdata[questionindex]["options"]['A'] == ""
                                                                                            ? Container()
                                                                                            : Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                                                                                child: Container(
                                                                                                  width: 50,
                                                                                                  height: 50,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: quizdata[questionindex]["answeredValueList"].contains("A") || A == true ? Color.fromARGB(255, 117, 255, 121) : Color(0xFFC9C1C1),
                                                                                                  ),
                                                                                                  child: Align(
                                                                                                    alignment: AlignmentDirectional(0.05, 0),
                                                                                                    child: Text(
                                                                                                      'A',
                                                                                                      style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                            fontFamily: 'Poppins',
                                                                                                            fontSize: 22,
                                                                                                            fontWeight: FontWeight.normal,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                        quizdata[questionindex]["options"]['A'] == ""
                                                                                            ? Container()
                                                                                            : Expanded(
                                                                                                child: Align(
                                                                                                  alignment: AlignmentDirectional(-1, 0),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          '${quizdata[questionindex]["options"]['A']}',
                                                                                                          textAlign: TextAlign.start,
                                                                                                          style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                                fontFamily: 'Poppins',
                                                                                                                fontSize: 17,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                              ),
                                                                                                        ),
                                                                                                        showimagea
                                                                                                            ? SizedBox(
                                                                                                                height: 200,
                                                                                                                width: 300,
                                                                                                                child: Image.network(quizdata[questionindex]["OptionsImage"]['A']),
                                                                                                              )
                                                                                                            : Container(),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                      ],
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                    quizdata[questionindex]["options"]['B'] ==
                                                                            ""
                                                                        ? Container()
                                                                        : Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                5,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Wrap(
                                                                              spacing: 0,
                                                                              runSpacing: 0,
                                                                              alignment: WrapAlignment.start,
                                                                              crossAxisAlignment: WrapCrossAlignment.start,
                                                                              direction: Axis.horizontal,
                                                                              runAlignment: WrapAlignment.start,
                                                                              verticalDirection: VerticalDirection.down,
                                                                              clipBehavior: Clip.none,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(-1, 0),
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        B = !B;
                                                                                      });
                                                                                      save();
                                                                                    },
                                                                                    child: quizdata[questionindex]["options"]['B'] == ""
                                                                                        ? Container()
                                                                                        : Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                                                                                child: Container(
                                                                                                  width: 50,
                                                                                                  height: 50,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: quizdata[questionindex]["answeredValueList"].contains("B") || B == true ? Color.fromARGB(255, 117, 255, 121) : Color(0xFFC9C1C1),
                                                                                                  ),
                                                                                                  child: Align(
                                                                                                    alignment: AlignmentDirectional(0.05, 0),
                                                                                                    child: Text(
                                                                                                      'B',
                                                                                                      style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                            fontFamily: 'Poppins',
                                                                                                            fontSize: 22,
                                                                                                            fontWeight: FontWeight.normal,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Align(
                                                                                                  alignment: AlignmentDirectional(-1, 0),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          '${quizdata[questionindex]["options"]['B']}',
                                                                                                          textAlign: TextAlign.start,
                                                                                                          style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                                fontFamily: 'Poppins',
                                                                                                                fontSize: 17,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                              ),
                                                                                                        ),
                                                                                                        showimageb
                                                                                                            ? SizedBox(
                                                                                                                height: 200,
                                                                                                                width: 300,
                                                                                                                child: Image.network(quizdata[questionindex]["OptionsImage"]['B']),
                                                                                                              )
                                                                                                            : Container(),
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
                                                                    quizdata[questionindex]["options"]['C'] ==
                                                                            ""
                                                                        ? Container()
                                                                        : Align(
                                                                            alignment:
                                                                                AlignmentDirectional(-1, -1),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                                                              child: Wrap(
                                                                                spacing: 0,
                                                                                runSpacing: 0,
                                                                                alignment: WrapAlignment.start,
                                                                                crossAxisAlignment: WrapCrossAlignment.start,
                                                                                direction: Axis.horizontal,
                                                                                runAlignment: WrapAlignment.start,
                                                                                verticalDirection: VerticalDirection.down,
                                                                                clipBehavior: Clip.none,
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: AlignmentDirectional(-1, 0),
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          C = !C;
                                                                                        });
                                                                                        save();
                                                                                      },
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                                                                            child: Container(
                                                                                              width: 50,
                                                                                              height: 50,
                                                                                              decoration: BoxDecoration(
                                                                                                color: quizdata[questionindex]["answeredValueList"].contains("C") || C == true ? Color.fromARGB(255, 117, 255, 121) : Color(0xFFC9C1C1),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: AlignmentDirectional(0.05, 0),
                                                                                                child: Text(
                                                                                                  'C',
                                                                                                  style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                        fontFamily: 'Poppins',
                                                                                                        fontSize: 22,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(-1, 0),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      '${quizdata[questionindex]["options"]['C']}',
                                                                                                      textAlign: TextAlign.start,
                                                                                                      style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                            fontFamily: 'Poppins',
                                                                                                            fontSize: 17,
                                                                                                            fontWeight: FontWeight.normal,
                                                                                                          ),
                                                                                                    ),
                                                                                                    showimagec
                                                                                                        ? SizedBox(
                                                                                                            height: 200,
                                                                                                            width: 300,
                                                                                                            child: Image.network(quizdata[questionindex]["OptionsImage"]['C']),
                                                                                                          )
                                                                                                        : Container(),
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
                                                                          ),
                                                                    quizdata[questionindex]["options"]['D'] ==
                                                                            ""
                                                                        ? Container()
                                                                        : Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                5,
                                                                                0,
                                                                                110),
                                                                            child:
                                                                                Wrap(
                                                                              spacing: 0,
                                                                              runSpacing: 0,
                                                                              alignment: WrapAlignment.start,
                                                                              crossAxisAlignment: WrapCrossAlignment.start,
                                                                              direction: Axis.horizontal,
                                                                              runAlignment: WrapAlignment.start,
                                                                              verticalDirection: VerticalDirection.down,
                                                                              clipBehavior: Clip.none,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(-1, 0),
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        D = !D;
                                                                                      });
                                                                                      save();
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                                                                          child: Container(
                                                                                            width: 50,
                                                                                            height: 50,
                                                                                            decoration: BoxDecoration(
                                                                                              color: quizdata[questionindex]["answeredValueList"].contains("D") || D == true ? Color.fromARGB(255, 117, 255, 121) : Color(0xFFC9C1C1),
                                                                                            ),
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(0.05, 0),
                                                                                              child: Text(
                                                                                                'D',
                                                                                                style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                      fontFamily: 'Poppins',
                                                                                                      fontSize: 22,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Align(
                                                                                            alignment: AlignmentDirectional(-1, 0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    '${quizdata[questionindex]["options"]['D']}',
                                                                                                    textAlign: TextAlign.start,
                                                                                                    style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                          fontFamily: 'Poppins',
                                                                                                          fontSize: 17,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                        ),
                                                                                                  ),
                                                                                                  showimaged
                                                                                                      ? SizedBox(
                                                                                                          height: 200,
                                                                                                          width: 300,
                                                                                                          child: Image.network(quizdata[questionindex]["OptionsImage"]['D']),
                                                                                                        )
                                                                                                      : Container(),
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
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 1000,
                                                              height: 600,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child: SingleChildScrollView(
                                                                  child:
                                                                      OptionsChoices()),
                                                              // Container()),
                                                            ),
                                                      Divider(
                                                        thickness: 1,
                                                        color:
                                                            Color(0xFF918888),
                                                      ),
                                                      if (responsiveVisibility(
                                                        context: context,
                                                        phone: false,
                                                        tablet: false,
                                                        tabletLandscape: false,
                                                        desktop: false,
                                                      ))
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 92.8,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            saveNext(false);
                                                                          },
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () {
                                                                              print('Button pressed ...');
                                                                            },
                                                                            text:
                                                                                'SAVE & NEXT1',
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 100,
                                                                              height: 30,
                                                                              color: Color(0xFF0AAB4E),
                                                                              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Colors.white,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          saveNext(
                                                                              false);
                                                                        },
                                                                        child:
                                                                            FFButtonWidget(
                                                                          onPressed:
                                                                              () {
                                                                            print('Button pressed ...');
                                                                          },
                                                                          text:
                                                                              'MARK FOR REVIEW & NEXT',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            width:
                                                                                180,
                                                                            height:
                                                                                30,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryColor,
                                                                            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: Colors.white,
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.normal,
                                                                                ),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.transparent,
                                                                              width: 0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              A = false;
                                                                              B = false;
                                                                              C = false;
                                                                              D = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () {
                                                                              print('Button pressed ...');
                                                                            },
                                                                            text:
                                                                                'CLEAR RESPONSE',
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 125,
                                                                              height: 30,
                                                                              color: Color(0xFF9A98A9),
                                                                              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Colors.white,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) => QuizReportDialog(
                                                                                coursename: widget.quizdata['courseName'],
                                                                                modulename: widget.quizdata['module'],
                                                                                sname: userName,
                                                                                email: email,
                                                                                cno: contactnumber,
                                                                                quiznumber: questionindex + 1,
                                                                                quizname: widget.quizdata['name'],
                                                                                subcname: '',
                                                                                description: '',
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Report an error',
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                fontFamily: 'Poppins',
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.red),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(
                                                                                () {
                                                                                  if (questionindex != 0) {
                                                                                    questionindex -= 1;
                                                                                    save();
                                                                                  }
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                FFButtonWidget(
                                                                              onPressed: () {
                                                                                print('Button pressed ...');
                                                                              },
                                                                              text: 'PREVIOUS1..',
                                                                              options: FFButtonOptions(
                                                                                width: 90,
                                                                                height: 30,
                                                                                color: Color(0xFF918888),
                                                                                textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.transparent,
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  if (questionindex != quizdata.length) {
                                                                                    questionindex += 1;
                                                                                  }
                                                                                });
                                                                              },
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  questionindex += 1;
                                                                                },
                                                                                child: FFButtonWidget(
                                                                                  onPressed: () {
                                                                                    print('Button pressed ...');
                                                                                  },
                                                                                  text: 'NEXT QUESTION',
                                                                                  options: FFButtonOptions(
                                                                                    width: 115,
                                                                                    height: 30,
                                                                                    color: FlutterFlowTheme.of(context).primaryColor,
                                                                                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          color: Colors.white,
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                    borderSide: BorderSide(
                                                                                      color: Colors.transparent,
                                                                                      width: 1,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showQuizConfirmationDialog(context);
                                                                          },
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () {
                                                                              showQuizConfirmationDialog(context);
                                                                            },
                                                                            text:
                                                                                'SUBMIT',
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 90,
                                                                              height: 30,
                                                                              color: Color(0xFF00C356),
                                                                              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Colors.white,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xFFC39A9A),
                                                                                width: 0,
                                                                              ),
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
                                                      GestureDetector(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (questionindex + 1 ==
                                                                              quizdata.length) {
                                                                            showQuizConfirmationDialog(context);
                                                                          } else {
                                                                            saveNext(false);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFF0A9E04),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0, 0),
                                                                            child: questionindex + 1 == quizdata.length
                                                                                ? Text(
                                                                                    'SUBMIT',
                                                                                    style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                  )
                                                                                : Text(
                                                                                    'SAVE & NEXT',
                                                                                    style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        markreview =
                                                                            true;
                                                                        saveNext(
                                                                            false);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryColor,
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'MARK FOR REVIEW',
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                  fontSize: 10,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          A = false;
                                                                          B = false;
                                                                          C = false;
                                                                          D = false;
                                                                          quizdata[questionindex]["Answered"] =
                                                                              false;
                                                                          quizdata[questionindex]['notAnswered'] =
                                                                              true;
                                                                          quizdata[questionindex]['answeredValue'] =
                                                                              null;
                                                                          countParameter(
                                                                              'save');
                                                                        });
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFF868585),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Text(
                                                                              'CLEAR RESPONCE',
                                                                              style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                    fontSize: 10,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (questionindex != 0) {
                                                                                save();
                                                                                questionindex -= 1;
                                                                                try {
                                                                                  quizdata[questionindex]["OptionsImage"]['A'];
                                                                                  if (quizdata[questionindex]["OptionsImage"]['A'] != "") {
                                                                                    setState(() {
                                                                                      showimagea = true;
                                                                                    });
                                                                                  }
                                                                                } catch (e) {
                                                                                  setState(() {
                                                                                    showimagea = false;
                                                                                  });
                                                                                  print("error: $e");
                                                                                }

                                                                                try {
                                                                                  quizdata[questionindex]["OptionsImage"]['B'];
                                                                                  if (quizdata[questionindex]["OptionsImage"]['B'] != "") {
                                                                                    setState(() {
                                                                                      showimageb = true;
                                                                                    });
                                                                                  }
                                                                                } catch (e) {
                                                                                  setState(() {
                                                                                    showimageb = false;
                                                                                  });
                                                                                  print("error: $e");
                                                                                }

                                                                                try {
                                                                                  quizdata[questionindex]["OptionsImage"]['C'];
                                                                                  if (quizdata[questionindex]["OptionsImage"]['C'] != "") {
                                                                                    setState(() {
                                                                                      showimagec = true;
                                                                                    });
                                                                                  }
                                                                                } catch (e) {
                                                                                  setState(() {
                                                                                    showimagec = false;
                                                                                  });
                                                                                  print("error: $e");
                                                                                }

                                                                                try {
                                                                                  quizdata[questionindex]["OptionsImage"]['D'];
                                                                                  if (quizdata[questionindex]["OptionsImage"]['D'] != "") {
                                                                                    setState(() {
                                                                                      showimaged = true;
                                                                                    });
                                                                                  }
                                                                                } catch (e) {
                                                                                  setState(() {
                                                                                    showimaged = false;
                                                                                  });
                                                                                  print("error: $e");
                                                                                }
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                40,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xFF0A9E04),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0, 0),
                                                                              child: Text(
                                                                                'PREVIOUS2',
                                                                                style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                      fontSize: 10,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (quizdata.length != questionindex + 1) {
                                                                                questionindex += 1;
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                saveNext(false);
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 100,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFF868585),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: AlignmentDirectional(0, 0),
                                                                                child: Text(
                                                                                  'NEXT QUESTION',
                                                                                  style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0,
                                                                        0.05),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          60,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0,
                                                                            1),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) => QuizReportDialog(
                                                                                coursename: widget.quizdata['courseName'],
                                                                                modulename: widget.quizdata['module'],
                                                                                sname: userName,
                                                                                email: email,
                                                                                cno: contactnumber,
                                                                                quiznumber: questionindex + 1,
                                                                                quizname: widget.quizdata['name'],
                                                                                subcname: '',
                                                                                description: '',
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Report an error',
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                fontFamily: 'Poppins',
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.red),
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (responsiveVisibility(
                                        context: context,
                                        phone: false,
                                        desktop: true,
                                        tablet: false,
                                        tabletLandscape: false,
                                      ))
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 100,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                1.1,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              border: Border.all(
                                                color: Color(0x95000000),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    20, 0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFF19F80F),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Text(
                                                                  '$answeredM',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBtnText,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                'Answered',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    20, 0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Text(
                                                                  '$notAnsweredM',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBtnText,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Not Answered',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    20, 0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0x8F57636C),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Text(
                                                                  '$notVisitedM',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBtnText,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Not Visited',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    20, 0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Text(
                                                                  '$MFR_M',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBtnText,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Marked For \nReview',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1,
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
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 50),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      20, 0, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0x8F1487DD),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    '$AMFR_M',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBtnText,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Answered & Marked For Review\n( will be considered for evaluation )',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1,
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
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1, 0),
                                                    child: Container(
                                                      width: 400,
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    20, 20, 20),
                                                        child: GridView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 6,
                                                            crossAxisSpacing:
                                                                10,
                                                            mainAxisSpacing: 10,
                                                            childAspectRatio: 1,
                                                          ),
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              quizdata.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            print(
                                                                quizdata[index]
                                                                    ['AMRF']);
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  questionindex =
                                                                      index;
                                                                  saveNext(
                                                                      true);
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: (quizdata[index]['AMFR'] !=
                                                                              null &&
                                                                          quizdata[index]['AMFR'] !=
                                                                              false
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          142,
                                                                          218)
                                                                      : quizdata[index]['MFR'] != null &&
                                                                              quizdata[index]['MFR'] !=
                                                                                  false
                                                                          ? Color.fromARGB(
                                                                              255,
                                                                              50,
                                                                              41,
                                                                              219)
                                                                          : quizdata[index]['Answered'] != null && quizdata[index]['Answered'] != false
                                                                              ? Color.fromARGB(255, 5, 217, 76)
                                                                              : quizdata[index]['notAnswered'] != null && quizdata[index]['notAnswered'] != false
                                                                                  ? Color.fromARGB(255, 233, 26, 26)
                                                                                  : quizdata[index]['visited'] == null
                                                                                      ? Color.fromARGB(255, 207, 196, 196)
                                                                                      : Color.fromARGB(255, 207, 196, 196)),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    '${index + 1}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBtnText,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (responsiveVisibility(
                                        context: context,
                                        phone: false,
                                        desktop: false,
                                      ))
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 100,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                1,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              border: Border.all(
                                                color: Color(0x95000000),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            '$notAnsweredM',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          'Not nswered',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20, 20, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF19F80F),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                              child: Text(
                                                                '$answeredM',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBtnText,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              'Answered',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20, 20, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x8F57636C),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                              child: Text(
                                                                '$notVisitedM',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBtnText,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              'Not Visited',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            '$MFR_M',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          'Marked For\n Review',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 50),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      20, 0, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0x8F1487DD),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    '$AMFR_M',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBtnText,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: Text(
                                                                    'Answered & Marked For Review\n(will be considered for evaluation)',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              12,
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
                                                Container(
                                                  width: 400,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBtnText,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20, 20, 20, 20),
                                                    child: GridView.builder(
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 6,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                        childAspectRatio: 1,
                                                      ),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          quizdata.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: (quizdata[index]['AMFR'] !=
                                                                        null &&
                                                                    quizdata[index]['AMFR'] !=
                                                                        false
                                                                ? Color.fromARGB(
                                                                    255,
                                                                    80,
                                                                    142,
                                                                    218)
                                                                : quizdata[index]['MFR'] != null &&
                                                                        quizdata[index]['MFR'] !=
                                                                            false
                                                                    ? Color.fromARGB(
                                                                        255,
                                                                        50,
                                                                        41,
                                                                        219)
                                                                    : quizdata[index]['Answered'] != null &&
                                                                            quizdata[index]['Answered'] !=
                                                                                false
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            217,
                                                                            76)
                                                                        : quizdata[index]['notAnswered'] != null && quizdata[index]['notAnswered'] != false
                                                                            ? Color.fromARGB(255, 233, 26, 26)
                                                                            : quizdata[index]['visited'] == null
                                                                                ? Color.fromARGB(255, 207, 196, 196)
                                                                                : Color.fromARGB(255, 207, 196, 196)),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0, 0),
                                                            child: Text(
                                                              '${index + 1}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBtnText,
                                                                  ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        submitvalue
            ? Center(
                child: Container(
                  width: 700,
                  height: 400,
                  color: Color.fromARGB(26, 195, 64, 64),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            : Container()
      ]),
    );
  }

  Widget OptionsChoices() {
    print('iefjow1');

    var answervalue = quizdata[questionindex]["answeredValue"];
    if (answervalue == null) {
      answervalue = "";
    }
    print('iefjow2 $answervalue');

    var question =
        quizdata[questionindex]["question"].toString().split("(--image--)")[0];
    print('iefjow3 $question');

    var optiona = quizdata[questionindex]["options"]['A'].toString().trim();
    print('iefjow4 $optiona');
    var optionb = quizdata[questionindex]["options"]['B'].toString().trim();
    print('iefjow5 $optionb');
    var optionc = quizdata[questionindex]["options"]['C'].toString().trim();
    print('iefjow6 $optionc');
    var optiond = quizdata[questionindex]["options"]['D'].toString().trim();
    print('iefjow7 $optiond');
    var questionimage;
    var optionaimage;
    var optionbimage;
    var optioncimage;
    var optiondimage;

    try {
      questionimage = quizdata[questionindex]["questionImage"];
      print('iefjow08 $questionimage');
    } catch (e) {
      questionimage = "";
      print('iefjow081 $questionimage');
    }
    try {
      optionaimage = quizdata[questionindex]["OptionsImage"]['A'];
      print('iefjow9 $optionaimage');
    } catch (e) {
      optionaimage = "";
      print('iefjow91 $optionaimage');
    }

    try {
      optionbimage = quizdata[questionindex]["OptionsImage"]['B'];
      print('iefjow10 $optionbimage');
    } catch (e) {
      optionbimage = "";
      print('iefjow101 $optionbimage');
    }

    try {
      optioncimage = quizdata[questionindex]["OptionsImage"]['C'];
      print('iefjow11 $optioncimage');
    } catch (e) {
      optioncimage = "";
      print('iefjow111 $optioncimage');
    }

    try {
      optiondimage = quizdata[questionindex]["OptionsImage"]['D'];
      print('iefjow12 $optiondimage');
    } catch (e) {
      optiondimage = "";
      print('iefjow121 $optiondimage');
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: AlignmentDirectional(-1, 0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              verticalDirection: VerticalDirection.down,
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 30),
                    child: Text(
                      '${question}',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                questionimage == null || questionimage == ''
                    ? Container()
                    : Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 30),
                        // child: Image.network("${quizdata[questionindex]["questionImage"]}"),
                        child: SizedBox(
                          child: Image.network('${questionimage}',
                              fit: BoxFit.cover),
                        ),
                      ),
              ],
            ),
          ),
        ),
        optiona == ""
            ? Container()
            : Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              C = false;
                              B = false;
                              A = !A;
                              D = false;
                            });
                            save();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: answervalue == "A" || A == true
                                        ? Color.fromARGB(255, 117, 255, 121)
                                        : Color(0xFFC9C1C1),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.05, 0),
                                    child: Text(
                                      'A',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${optiona}',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        optionaimage != ""
                                            ? SizedBox(
                                                height: 200,
                                                width: 300,
                                                child:
                                                    Image.network(optionaimage),
                                              )
                                            : Container(),
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
              ),
        optionb == ""
            ? Container()
            : Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              C = false;
                              B = !B;
                              A = false;
                              D = false;
                            });
                            save();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: answervalue == "B" || B == true
                                        ? Color.fromARGB(255, 117, 255, 121)
                                        : Color(0xFFC9C1C1),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.05, 0),
                                    child: Text(
                                      'B',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${optionb}',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        optionbimage != ""
                                            ? SizedBox(
                                                height: 200,
                                                width: 300,
                                                child:
                                                    Image.network(optionbimage),
                                              )
                                            : Container(),
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
              ),
        optionc == ""
            ? Container()
            : Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              C = !C;
                              B = false;
                              A = false;
                              D = false;
                            });
                            save();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: answervalue == "C" || C == true
                                        ? Color.fromARGB(255, 117, 255, 121)
                                        : Color(0xFFC9C1C1),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.05, 0),
                                    child: Text(
                                      'C',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${optionc}',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        optioncimage != ""
                                            ? SizedBox(
                                                height: 200,
                                                width: 300,
                                                child:
                                                    Image.network(optioncimage),
                                              )
                                            : Container(),
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
              ),
        optiond == ""
            ? Container()
            : Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 110),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            D = !D;
                            B = false;
                            C = false;
                            A = false;
                          });
                          save();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: answervalue == "D" || D == true
                                      ? Color.fromARGB(255, 117, 255, 121)
                                      : Color(0xFFC9C1C1),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.05, 0),
                                  child: Text(
                                    'D',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30, 0, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${optiond}',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      optiondimage != ""
                                          ? SizedBox(
                                              height: 200,
                                              width: 300,
                                              child:
                                                  Image.network(optiondimage),
                                            )
                                          : Container(),
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
    );
  }
}

class QuizReportDialog extends StatefulWidget {
  final String coursename;
  final String subcname;
  final String modulename;
  final String quizname;
  final int quiznumber;
  final String description;
  final String sname;
  final String email;
  final String cno;

  QuizReportDialog({
    required this.coursename,
    required this.subcname,
    required this.modulename,
    required this.quizname,
    required this.quiznumber,
    required this.description,
    required this.sname,
    required this.email,
    required this.cno,
  });

  @override
  _QuizReportDialogState createState() => _QuizReportDialogState();
}

class _QuizReportDialogState extends State<QuizReportDialog> {
  final Map<String, dynamic> data = {
    "cname": "",
    "subcname": "",
    "mname": "",
    "qname": "",
    "qno": "",
    "description": "",
    "sname": "",
    "email": "",
    "cno": "",
  };

  Future<void> sendQuizReport() async {
    final String apiUrl =
        'https://us-central1-cloudyml-app.cloudfunctions.net/mailapi/quizreportmail';

    try {
      final dio = Dio();
      final response = await dio.post(
        apiUrl,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
        Toast.show('Data sent successfully');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        Toast.show(
          'Failed to send data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize data with values from widget properties
    setState(() {
      data["cname"] = widget.coursename;
      data["subcname"] = widget.subcname;
      data["mname"] = widget.modulename;
      data["qname"] = widget.quizname;
      data["qno"] = widget.quiznumber.toString();
      data["description"] = widget.description;
      data["sname"] = widget.sname;
      data["email"] = widget.email;
      data["cno"] = widget.cno;
    });
    print("sfowiejfow: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error Report'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField('Course Name', 'cname'),
              buildTextField('Subcourse Name', 'subcname'),
              buildTextField('Module Name', 'mname'),
              buildTextField('Quiz Name', 'qname'),
              buildTextField('Quiz Number', 'qno'),
              buildTextField('Description', 'description'),
              buildTextField('Student Name', 'sname'),
              buildTextField('Email', 'email'),
              buildTextField('Contact Number', 'cno'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await sendQuizReport();
                  Navigator.of(context)
                      .pop(); // Close the dialog after sending data
                },
                child: Text('Send Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String fieldName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: data[fieldName],
        decoration: InputDecoration(labelText: labelText),
        onChanged: (value) {
          setState(() {
            data[fieldName] = value;
          });
        },
      ),
    );
  }
}

class QuizConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Submit Quiz'),
      content: Text('Are you sure you want to submit the quiz?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // User pressed the Cancel button
            Navigator.of(context).pop(false);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // User pressed the Submit button
            Navigator.of(context).pop(true);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
