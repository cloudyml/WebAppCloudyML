import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/controller/combo_course_controller.dart';
import 'package:cloudyml_app2/screens/quiz/model/quiztrackmodel.dart';
import 'package:cloudyml_app2/screens/quiz/quiz_page.dart';
import 'package:cloudyml_app2/screens/quiz/quizentry.dart';
import 'package:cloudyml_app2/screens/quiz/quizinstructions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:toast/toast.dart';
import '../global_variable.dart';
import '../globals.dart';
import '../module/video_screen.dart';
import 'dart:html' as html;

class ScholarshipQuiz extends StatefulWidget {
  String? fullpath;
  ScholarshipQuiz(this.fullpath, {Key? key}) : super(key: key);

  @override
  State<ScholarshipQuiz> createState() => _ScholarshipQuizState();
}

class _ScholarshipQuizState extends State<ScholarshipQuiz> {
  List<dynamic> ScholarshipQuizList = [];
  String courseName = '';

  @override
  void initState() {
    super.initState();
    print('currentURL1: ${widget.fullpath}');
    getScholarshipQuiz();
    checkIfQuizAlreadyGiven();
    print('wjefoiwjo:0');
  }

  checkIfQuizAlreadyGiven() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      try {
        list_of_attempted_scholarshipquiz =
            value.data()!['list_of_attempted_scholarshipquiz'];
        print("yuyguguygyug: ${list_of_attempted_scholarshipquiz}");
        if (list_of_attempted_scholarshipquiz == null) {
          list_of_attempted_scholarshipquiz = [];
        }
        print("yuyguguygyug1: ${list_of_attempted_scholarshipquiz}");
        if (list_of_attempted_scholarshipquiz.toString() == 'null') {
          list_of_attempted_scholarshipquiz = [];
        }
        if (list_of_attempted_scholarshipquiz.isEmpty) {
          list_of_attempted_scholarshipquiz = [];
        }
        print("yuyguguygyug2: ${list_of_attempted_scholarshipquiz}");
      } catch (e) {
        if (list_of_attempted_scholarshipquiz == null) {
          list_of_attempted_scholarshipquiz = [];
        }
        if (list_of_attempted_scholarshipquiz.toString() == 'null') {
          list_of_attempted_scholarshipquiz = [];
        }
        if (list_of_attempted_scholarshipquiz.isEmpty) {
          list_of_attempted_scholarshipquiz = [];
        }
        print('wijefowi: $e');
      }
    });
  }

  var docid;
  Future<List<dynamic>> getScholarshipQuiz() async {
    String currentURL = widget.fullpath!;
    print('currentURL: $currentURL');
    docid = currentURL.split('wadsf')[1];
    try {
      await FirebaseFirestore.instance
          .collection("courses")
          .get()
          .then((value) {
        List quiz = [];
        print('wjefoiwjo:1');
        for (var i in value.docs) {
          print('wjefoiwjo:2');
          if (i.data()['docid'] == docid) {
            print('wjefoiwjo:3 ${i.data()}');
            quiz.addAll(i.data()['scholarshipQuiz']);
            print('wjefoiwjo:4');
            courseName = i.data()['name'];
            print('wjefoiwjo:5');
          }
        }
        setState(() {
          ScholarshipQuizList = quiz;
        });
      }).catchError((onError) {
        print('wjefoiwjo:9${onError}');
      }); //scholarship/wadsaEGX6kMfHzQrVgP3WCwU
    } catch (e) {
      print('wjefoiwjo:8$e');
    }

    print("wjefoiwjo: ${ScholarshipQuizList}");
    return ScholarshipQuizList;
  }

  var list_of_attempted_scholarshipquiz = [];

  checkQuizStatusOrNavigate(quizdata, courseName, bollen) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      try {
        list_of_attempted_scholarshipquiz =
            value.data()!['list_of_attempted_scholarshipquiz'];
        globals.name = value.data()!['name'];
        globals.email = value.data()!['email'];
        var data = value.data()!['quiztrack'];
        bool attemptingquizforthefirsttime = true;
        for (var i in data) {
          if (i != null) {
            i = QuizTrackModel.fromJson(i);
            print(i.quizname);
            print(quizdata['name']);
            try {
              print('joifweofwoefjowjeof1');
              if (courseName == i!.courseName) {
                var quiznameNumbers =
                    i!.quizname.replaceAll(RegExp(r'[^0-9]'), '');
                var quiznamenumbercount =
                    quizdata['name'].replaceAll(RegExp(r'[^0-9]'), '');
                if (quiznameNumbers == '') {
                  if (quizdata['name'] == i!.quizname) {
                    attemptingquizforthefirsttime = false;
                    print("quiz found");
                    print("quiz cleared ppppppppppppp ${i.quizCleared}");
                    if (i.quizCleared == true) {
                      print("quiz cleared ppppppppppppp");
                      Toast.show('You have already aced this quiz!');
                      globals.quizCleared = true;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuizPage(quizdata, bollen, docid)),
                      );
                    } else {
                      // condition for quiz not cleared
                      print("quiz not cleared");
                      // condition for course quiz
                      if (i.quizlevel == "courselevel") {
                        if (i.quizAttemptGapForCourseQuiz!
                                .compareTo(DateTime.now()) <
                            0) {
                          print("quiz attempt gap over");
                          print(i.quizAttemptGapForCourseQuiz);
                          print(DateTime.now());
                          // navigate to quiz page
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuizPage(quizdata, bollen, docid)));
                        } else {
                          print("quiz attempt gap not over");
                          Toast.show(
                            'You can attempt this quiz after ${i.quizAttemptGapForCourseQuiz}',
                          );
                        }
                      } else {
                        print("quiz attempt gap not over");
                        // condition for modular quiz
                        if (i.quizAttemptGapForModularQuiz!
                                .compareTo(DateTime.now()) <
                            0) {
                          // navigate to quiz page
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuizPage(quizdata, bollen, docid)));
                        } else {
                          print('quiz attempt gap not over');
                          Toast.show(
                              'You can attempt this quiz after ${i.quizAttemptGapForModularQuiz}');
                        }
                      }
                    }
                  }
                } else {
                  if (quiznameNumbers == quiznamenumbercount) {
                    attemptingquizforthefirsttime = false;
                    print("quiz found");
                    print("quiz cleared ppppppppppppp ${i.quizCleared}");
                    if (i.quizCleared == true) {
                      print("quiz cleared ppppppppppppp");
                      Toast.show('You have already aced this quiz!');
                      globals.quizCleared = true;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuizPage(quizdata, bollen, docid)));
                    } else {
                      // condition for quiz not cleared
                      print("quiz not cleared");
                      // condition for course quiz
                      if (i.quizlevel == "courselevel") {
                        if (i.quizAttemptGapForCourseQuiz!
                                .compareTo(DateTime.now()) <
                            0) {
                          print("quiz attempt gap over");
                          print(i.quizAttemptGapForCourseQuiz);
                          print(DateTime.now());
                          // navigate to quiz page
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuizPage(quizdata, bollen, docid)));
                        } else {
                          print("quiz attempt gap not over");
                          Toast.show(
                            'You can attempt this quiz after ${i.quizAttemptGapForCourseQuiz}',
                          );
                        }
                      } else {
                        print("quiz attempt gap not over");
                        // condition for modular quiz
                        if (i.quizAttemptGapForModularQuiz!
                                .compareTo(DateTime.now()) <
                            0) {
                          // navigate to quiz page
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuizPage(quizdata, bollen, docid)));
                        } else {
                          print('quiz attempt gap not over');
                          Toast.show(
                              'You can attempt this quiz after ${i.quizAttemptGapForModularQuiz}');
                        }
                      }
                    }
                  }
                }
              }
            } catch (e) {
              print("error id: ifwjoefjwoeivfff: ${e.toString()}");
            }
          }
        }
        if (attemptingquizforthefirsttime) {
          print("quiz is taken for the first time");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizPage(quizdata, bollen, docid)));
        }
      } catch (e) {
        print("error id: efwefwe32232321: ${e.toString()}");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => QuizPage(quizdata, bollen, docid)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: list_of_attempted_scholarshipquiz.contains(docid)
          ? Container(
              child:
                  Center(child: Text("You have already attempted this quiz!")),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/BG.png"), fit: BoxFit.fill),
                    color: HexColor("#fef0ff"),
                  ),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "CloudyML Scholarship Quiz: Unleash Your Learning Potential and Secure Hefty Discounts on Course Purchases!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: width < 850
                                      ? width < 430
                                          ? 25
                                          : 30
                                      : 40,
                                  color: Colors.black)),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(
                            horizontal: width > 700 ? width / 7 : width / 50,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 15),
                              width: width < 1700
                                  ? width < 1300
                                      ? width < 850
                                          ? constraints.maxWidth - 20
                                          : constraints.maxWidth - 200
                                      : constraints.maxWidth - 400
                                  : constraints.maxWidth - 700,
                              height: width > 700
                                  ? 550
                                  : width < 300
                                      ? 550
                                      : 550,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    flex: width < 600 ? 6 : 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Quiz: ${ScholarshipQuizList[index]['name']}",
                                                style: TextStyle(
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width > 700
                                                      ? 25
                                                      : width < 540
                                                          ? 15
                                                          : 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Estimates learning time : ${ScholarshipQuizList[index]['quiztiming']}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: width <
                                                                    540
                                                                ? width < 420
                                                                    ? 11
                                                                    : 13
                                                                : 14,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 400,
                                                          child: InstructionspageWidget(
                                                              ScholarshipQuizList[
                                                                  index],
                                                              ScholarshipQuizList[
                                                                      index][
                                                                  'courseName'],
                                                              true,
                                                              docid),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        // Text(
                                                        //   "Explore our ${ScholarshipQuizList[index]['courseName']} Scholarship Quiz, where scoring high in quizzes not only expands your knowledge but also unlocks exclusive discounts on course fees. Transform learning into savings and embark on a rewarding educational journey!",
                                                        //   overflow:
                                                        //       TextOverflow.visible,
                                                        //   style: TextStyle(
                                                        //     fontSize: width < 540
                                                        //         ? width < 420
                                                        //             ? 11
                                                        //             : 13
                                                        //         : 14,
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        width < 450
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: width <
                                                                            400
                                                                        ? 160
                                                                        : 190,
                                                                    child:
                                                                        MaterialButton(
                                                                      height: width >
                                                                              700
                                                                          ? 50
                                                                          : 40,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      minWidth: width >
                                                                              700
                                                                          ? 100
                                                                          : 60,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "start quiz0");
                                                                        checkQuizStatusOrNavigate(
                                                                            ScholarshipQuizList[index],
                                                                            ScholarshipQuizList[index]['courseName'],
                                                                            true);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              "START QUIZ",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: width < 500 ? 10 : null,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      color: Colors
                                                                          .purple,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 190,
                                                                    child:
                                                                        MaterialButton(
                                                                      height:
                                                                          50,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      minWidth:
                                                                          100,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "start quiz");
                                                                        checkQuizStatusOrNavigate(
                                                                            ScholarshipQuizList[index],
                                                                            ScholarshipQuizList[index]['courseName'],
                                                                            true);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              "START QUIZ",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: width < 500 ? 10 : null,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      color: Colors
                                                                          .purple,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )),
                );
              },
            ),
    );
  }
}
