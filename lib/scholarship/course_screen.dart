// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudyml_app2/scholarship/quiz.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'dart:html' as html;

// class CourseScholarshipQuiz extends StatefulWidget {
//   CourseScholarshipQuiz({Key? key}) : super(key: key);

//   @override
//   State<CourseScholarshipQuiz> createState() => _ScholarshipQuizState();
// }

// class _ScholarshipQuizState extends State<CourseScholarshipQuiz> {
//   List<dynamic> ScholarshipQuizList = [];
//   String courseName = '';

//   @override
//   void initState() {
//     super.initState();
//     getScholarshipQuiz();
//     print('wjefoiwjo:0');
//   }

//   var docid;
//   Future<List<dynamic>> getScholarshipQuiz() async {
//     String currentURL = html.window.location.href;
//     print('currentURL: $currentURL');
//     docid = currentURL.split('wadsf')[1];
//     try {
//       await FirebaseFirestore.instance
//           .collection("courses")
//           .get()
//           .then((value) {
//         List quiz = [];
//         print('wjefoiwjo:1');
//         for (var i in value.docs) {
//           print('wjefoiwjo:2');
//           if (i.data()['docid'] == docid) {
//             print('wjefoiwjo:3 ${i.data()}');
//             quiz.addAll(i.data()['scholarshipQuiz']);
//             print('wjefoiwjo:4');
//             courseName = i.data()['name'];
//             print('wjefoiwjo:5');
//           }
//         }
//         setState(() {
//           ScholarshipQuizList = quiz;
//         });
//       }).catchError((onError) {
//         print('wjefoiwjo:9${onError}');
//       });
//     } catch (e) {
//       print('wjefoiwjo:8$e');
//     }

//     print("wjefoiwjo: ${ScholarshipQuizList}");
//     return ScholarshipQuizList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage("assets/BG.png"), fit: BoxFit.fill),
//               color: HexColor("#fef0ff"),
//             ),
//             width: constraints.maxWidth,
//             height: constraints.maxHeight,
//             child: SingleChildScrollView(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     GoRouter.of(context).pushReplacementNamed('home');
//                   },
//                   child: Container(
//                       child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
//                           child: Icon(Icons.arrow_back_rounded),
//                         ),
//                         Text(
//                           'Back',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   )),
//                 ),
//                 RichText(
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text:
//                             "CloudyML Scholarship Quiz: Unleash Your Learning Potential and Secure Hefty Discounts on Course Purchases!",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w200,
//                             fontSize: width < 850
//                                 ? width < 430
//                                     ? 25
//                                     : 30
//                                 : 40,
//                             color: Colors.black)),
//                   ]),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   child: ListView.builder(
//                     itemCount: ScholarshipQuizList.length > 0 ? 1 : 0,
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: width > 700 ? width / 7 : width / 50,
//                     ),
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       print("lllllllll: ${ScholarshipQuizList}");
//                       return Container(
//                         padding: EdgeInsets.all(8),
//                         margin: EdgeInsets.only(bottom: 15),
//                         width: width < 1700
//                             ? width < 1300
//                                 ? width < 850
//                                     ? constraints.maxWidth - 20
//                                     : constraints.maxWidth - 200
//                                 : constraints.maxWidth - 400
//                             : constraints.maxWidth - 700,
//                         height: width > 700
//                             ? 200
//                             : width < 300
//                                 ? 190
//                                 : 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               width: 50,
//                             ),
//                             Expanded(
//                               flex: width < 600 ? 6 : 4,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Quiz: ${ScholarshipQuizList[index]['courseName']}",
//                                           style: TextStyle(
//                                             height: 1,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: width > 700
//                                                 ? 25
//                                                 : width < 540
//                                                     ? 15
//                                                     : 16,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   // Text(
//                                                   //   "Estimates learning time : ${ScholarshipQuizList[index]['quiztiming']}",
//                                                   //   overflow:
//                                                   //       TextOverflow.ellipsis,
//                                                   //   style: TextStyle(
//                                                   //     fontSize: width < 540
//                                                   //         ? width < 420
//                                                   //             ? 11
//                                                   //             : 13
//                                                   //         : 14,
//                                                   //   ),
//                                                   // ),
//                                                   // Container(
//                                                   //   height: 400,
//                                                   //   child:
//                                                   //       InstructionspageWidget(
//                                                   //           ScholarshipQuizList[
//                                                   //               index],
//                                                   //           ScholarshipQuizList[
//                                                   //                   index]
//                                                   //               ['courseName'],
//                                                   //           true),
//                                                   // ),
//                                                   SizedBox(
//                                                     height: 3,
//                                                   ),
//                                                   Text(
//                                                     "Explore our ${ScholarshipQuizList[index]['courseName']} Scholarship Quiz, where scoring high in quizzes not only expands your knowledge but also unlocks exclusive discounts on course fees. Transform learning into savings and embark on a rewarding educational journey!",
//                                                     overflow:
//                                                         TextOverflow.visible,
//                                                     style: TextStyle(
//                                                       fontSize: width < 540
//                                                           ? width < 420
//                                                               ? 11
//                                                               : 13
//                                                           : 14,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 15,
//                                                   ),
//                                                   width < 450
//                                                       ? Column(
//                                                           children: [
//                                                             SizedBox(
//                                                               width: width < 400
//                                                                   ? 160
//                                                                   : 190,
//                                                               child:
//                                                                   MaterialButton(
//                                                                 height:
//                                                                     width > 700
//                                                                         ? 50
//                                                                         : 40,
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               20),
//                                                                 ),
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(8),
//                                                                 minWidth:
//                                                                     width > 700
//                                                                         ? 100
//                                                                         : 60,
//                                                                 onPressed: () {
//                                                                   print(
//                                                                       "start quiz0");
//                                                                   Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder: (context) => ScholarshipQuiz(
//                                                                             ScholarshipQuizList,
//                                                                             docid)),
//                                                                   );
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     SizedBox(
//                                                                       width: 5,
//                                                                     ),
//                                                                     Expanded(
//                                                                       flex: 1,
//                                                                       child:
//                                                                           Container(),
//                                                                     ),
//                                                                     Expanded(
//                                                                       flex: 3,
//                                                                       child:
//                                                                           Text(
//                                                                         "NEXT",
//                                                                         style:
//                                                                             TextStyle(
//                                                                           color:
//                                                                               Colors.white,
//                                                                           fontSize: width < 500
//                                                                               ? 10
//                                                                               : null,
//                                                                         ),
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 color: Colors
//                                                                     .purple,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               height: 10,
//                                                             ),
//                                                           ],
//                                                         )
//                                                       : Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .end,
//                                                           children: [
//                                                             SizedBox(
//                                                               width: 190,
//                                                               child:
//                                                                   MaterialButton(
//                                                                 height: 50,
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               20),
//                                                                 ),
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(8),
//                                                                 minWidth: 100,
//                                                                 onPressed: () {
//                                                                   print(
//                                                                       "start quiz");
//                                                                   Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder: (context) => ScholarshipQuiz(
//                                                                             ScholarshipQuizList,
//                                                                             docid)),
//                                                                   );
//                                                                 },
//                                                                 child: Center(
//                                                                   child: Center(
//                                                                     child: Text(
//                                                                       "NEXT",
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color: Colors
//                                                                             .white,
//                                                                         fontSize: width <
//                                                                                 500
//                                                                             ? 10
//                                                                             : null,
//                                                                       ),
//                                                                       overflow:
//                                                                           TextOverflow
//                                                                               .ellipsis,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 color: Colors
//                                                                     .purple,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 15,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               ],
//             )),
//           );
//         },
//       ),
//     );
//   }
// }
