import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/module/submit_resume.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/widgets/assignment_bottomsheet.dart';
import 'package:cloudyml_app2/widgets/settings_bottomsheet.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;
import '../api/firebase_api.dart';
import '../fun.dart';
import '../models/course_details.dart';
import '../models/firebase_file.dart';
import '../screens/quiz/quizentry.dart';
import 'new_assignment_screen.dart';

class VideoScreen extends StatefulWidget {
  final List<dynamic>? courses;
  final int? sr;
  final bool? isDemo;
  final String? courseName;
  final String? cID;
  static ValueNotifier<double> currentSpeed = ValueNotifier(1.0);

  const VideoScreen(
      {required this.isDemo, this.sr, this.courseName, this.courses, this.cID});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late List<FirebaseFile> futureAssignments;
  late List<FirebaseFile> futureSolutions;
  late List<FirebaseFile> futureDataSets;

  VideoPlayerController? _videoController;
  late String htmltext;
  bool htmlbool = false;
  List pathwaydata = [];
  bool? downloading = false;
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool loading = false;
  bool enablePauseScreen = false;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool stopdownloading = true;
  bool showAssignSol = false;
  bool quizbool = false;
  var quizdata;

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;
  bool submitResume = false;
  List<VideoDetails> _listOfVideoDetails = [];

  ValueNotifier<int> _currentVideoIndex = ValueNotifier(0);
  ValueNotifier<int> _currentVideoIndex2 = ValueNotifier(0);
  ValueNotifier<double> _downloadProgress = ValueNotifier(0);

  // void getData() async {
  //   await setModuleId();
  //   await FirebaseFirestore.instance
  //       .collection('courses')
  //       .doc(courseId)
  //       .collection('Modules')
  //       .doc(moduleId)
  //       .collection('Topics')
  //       .orderBy('sr')
  //       .get()
  //       .then((value) {
  //     for (var video in value.docs) {
  //       _listOfVideoDetails.add(
  //         VideoDetails(
  //           videoId: video.data()['id'] ?? '',
  //           type: video.data()['type'] ?? '',
  //           canSaveOffline: video.data()['Offline'] ?? true,
  //           serialNo: video.data()['sr'].toString(),
  //           videoTitle: video.data()['name'] ?? '',
  //           videoUrl: video.data()['url'] ?? '',
  //         ),
  //       );
  //     }
  //   });
  // }

  Future<void> setModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.cID)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      moduleId = value.docs[0].id;
    });
  }

  String convertToTwoDigits(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  // Widget timeRemainingString() {
  //   final totalDuration =
  //       _videoController!.value.duration.toString().substring(2, 7);
  //   final duration = _duration?.inSeconds ?? 0;
  //   final currentPosition = _position?.inSeconds ?? 0;
  //   final timeRemained = max(0, duration - currentPosition);
  //   final mins = convertToTwoDigits(timeRemained ~/ 60);
  //   final seconds = convertToTwoDigits(timeRemained % 60);
  //   // timeRemaining = '$mins:$seconds';
  //   return Text(
  //     totalDuration,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  Widget timeElapsedString() {
    var timeElapsedString = "00.00";
    final currentPosition = _position?.inSeconds ?? 0;
    final mins = convertToTwoDigits(currentPosition ~/ 60);
    final seconds = convertToTwoDigits(currentPosition % 60);
    timeElapsedString = '$mins:$seconds';
    return Text(
      timeElapsedString,
      style: TextStyle(
          color: Colors.white,
          // fontSize: 12,
          fontWeight: FontWeight.bold),
    );
  }

  void _onVideoControllerUpdate() async {
    print("this is video ------ $videoTitle");
    print("----$moduleName");
    print("------$moduleId");
    print("-----$videoId");
    print("---total duration $totalDuration");
    print("----percent ${((currentPosition / totalDuration) * 100).toInt()}");

    print(_getVideoPercentageList);

    if (_disposed) {
      return;
    }
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_delayToInvokeonControlUpdate > now) {
      return;
    }
    _delayToInvokeonControlUpdate = now + 500;
    final controller = _videoController;
    if (controller == null) {
      debugPrint("The video controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("The video controller cannot be initialized");
      return;
    }
    if (_duration == null) {
      _duration = _videoController!.value.duration;
    }
    if (!(_videoController!.value.duration >
            _videoController!.value.position) &&
        !_videoController!.value.isPlaying) {
      VideoScreen.currentSpeed.value = 1.0;
      // updateCourseCompletionPercentage(videoPercentageList);

      _currentVideoIndex.value++;
      initializeVidController(
          _listOfVideoDetails[_currentVideoIndex.value].videoUrl,
          _listOfVideoDetails[_currentVideoIndex.value].videoTitle,
          "",
          "",
          "");
    }
    var duration = _duration;
    if (duration == null) return;
    if (_getVideoPercentageList != null) {
      for (var i in _getVideoPercentageList!) {
        if (i[moduleId.toString()] != null) {
          for (var j in i[moduleId.toString()]) {
            print("0kkkkk");
            if(j[videoId.toString()]!=null)
              {
                if(j[videoId.toString()]>=100)
                  {
                              j[videoId.toString()] = 100;
                  }
                else
                  {
                   if(((currentPosition / totalDuration) * 100) >99.60)
                      {
                        j[videoId.toString()] = 100;
                      }
                       else
                         {

                           if(j[videoId.toString()]<
                               ((currentPosition / totalDuration) * 100).toInt()
                           )
                           {
                             j[videoId.toString()] =
                                 ((currentPosition / totalDuration) * 100).toInt();
                           }
                         }
                  }
              }
            // j[videoId.toString()] != null &&
            //         j[videoId.toString()] <
            //             ((currentPosition / totalDuration) * 100).toInt()
            //     ? j[videoId.toString()] =
            //         ((currentPosition / totalDuration) * 100).toInt()
            //     : null;
          }
        }
      }
      //
      int total = 0, count = 0;
      try {
        for (int i = 0; i < _getVideoPercentageList!.length; i++) {
          for (var j in _getVideoPercentageList![i].entries) {
            // j.value.forEach((element) {
            //   Map<String, int> dic = element as Map<String, int>;
            //   int t = dic.values.first;
            //   total += t;
            //   count += 1;
            // });
            try {
              j.value.forEach((element) {
                // Map<String, int> dic = element as Map<String, int>;
                // int t = dic.values.first;
                print(element.values.first);
                total += int.parse(element.values.first.toString()).toInt();
                count += 1;
                // print(dic);
              });
            } catch (err) {
              print("j--$j");
              print("Errrrrrrrrrrrrrr");
            }
          }
        }
      } catch (err) {
        print("errrororor");
      }
      CourseID != null
          ? FirebaseFirestore.instance
              .collection("courseprogress")
              .doc(_auth.currentUser!.uid)
              .update({
              CourseID.toString(): _getVideoPercentageList,
              CourseID.toString() + "percentage":
                  ((total / (count * 100)) * 100).toInt(),
            })
          : null;
    }

    var position = _videoController?.value.position;
    setState(() {
      _position = position;
      currentPosition = _videoController!.value.position.inSeconds.toInt();
    });
    final buffering = controller.value.isBuffering;
    setState(() {
      _isBuffering = buffering;
    });
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    } else {
      // updateCourseCompletionPercentage(videoPercentageList);
    }
    _isPlaying = playing;
  }

  int totalDuration = 0;
  int currentPosition = 0;
  String? moduleName, moduleId, videoId;
  void initializeVidController(String url, String name, String modulename,
      String moduleID, String videoID) async {
    print('this is -- $url ');
    try {
      final oldVideoController = _videoController;
      if (oldVideoController != null) {
        oldVideoController.removeListener(_onVideoControllerUpdate);
        oldVideoController.pause();
        oldVideoController.dispose();
      }
      final _localVideoController = await VideoPlayerController.network(url);
      setState(() {
        _videoController = _localVideoController;
      });
      playVideo = _localVideoController.initialize().then((value) {
        setState(() {
          print('this is -- $name ');
          videoTitle = name.toString();
          moduleName = modulename.toString();
          moduleId = moduleID;
          videoId = videoID;
          totalDuration =
              _localVideoController.value.duration.inSeconds.toInt();
          selectedVideoIndexName = url.toString();
          _localVideoController.addListener(_onVideoControllerUpdate);
          _localVideoController.play();
          _duration = _localVideoController.value.duration;
        });
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  var courseData;
  String courseName = '';
  var curriculumdata;
  var sectionName = [];

  Map<String, List> datamap = {};

  List<VideoDetails> _videodetails = [];
  var listData = [];
  var listOfVideo = [];
  var dataList = [];
  var videoPercentageList = [];
  var totalPercentageList = {};

  // Future<Map<String, dynamic>> getDataFrom(sectionName, curriculumdata) async {
  //   var data = {};
  //   await sectionName.entries.forEach((element) async {
  //     curriculumdata.entries.forEach((entry) {
  //       if (element.key.toString() == entry.key) {
  //         entry.value.forEach((name) {
  //           listOfVideo.add(name);
  //         });
  //         data[element] = listOfVideo.toList();
  //         dataList.add({element: listOfVideo.toList()});
  //         listOfVideo = [];
  //       }
  //     });
  //   });
  //   Map<String, dynamic> done = {};
  //
  //   for (var t in data.entries) {
  //     print("t = ${t.key}");
  //     for (var name in t.value) {
  //       print("Name = == = ${name}");
  //       await FirebaseFirestore.instance
  //           .collection('courses')
  //           .doc(courseId)
  //           .collection('Modules')
  //           .doc(moduleId)
  //           .collection('Topics')
  //           .where("name", isEqualTo: "${name.toString()}")
  //           .get()
  //           .then((value) {
  //         print("YY");
  //         print(value.docs.length);
  //         for (var video in value.docs) {
  //           listOfVideo.add(VideoDetails(
  //             videoId: video.data()['id'] ?? '',
  //             type: video.data()['type'] ?? '',
  //             canSaveOffline: video.data()['Offline'] ?? true,
  //             serialNo: video.data()['sr'].toString(),
  //             videoTitle: video.data()['name'] ?? '',
  //             videoUrl: video.data()['url'] ?? '',
  //           ));
  //           print("oo");
  //           String str = t.key.toString();
  //           str = str.replaceRange(0, 9, "");
  //           var st = "";
  //           for (int i = 0; i < str.length; i++) {
  //             if (str[i] == ":") {
  //               break;
  //             }
  //             st += str[i];
  //           }
  //           done[st] = listOfVideo.toList();
  //           print("oopp");
  //         }
  //         // print(value.docs.length);
  //       });
  //     }
  //     listOfVideo = [];
  //   }
  //   print("done = $done");
  //   print("length= = ${dataList.length}");
  //
  //   print("yes");
  //   print(listOfVideo.length);
  //   return done;
  // }

  var dataa;
  var curriculum1;

/*-------------- Video Percentage Srinivas Code ------------- */

  var _initialVideoPercentageList = {};
  List<dynamic>? _getVideoPercentageList;
  String? CourseID;

  getProgressData() async {
    await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print("vvvvvvvvvvvvvvvvvvvvvvvvv");
      print(_auth.currentUser!.uid.toString());
      print(value.exists);
      var res = await FirebaseFirestore.instance
          .collection("courses")
          .doc(widget.cID)
          .get();
      CourseID = await res.get("id");
      print('course id - $CourseID ');

      var list = await res.get("curriculum1")[widget.courseName];

      // if (value.exists && value.data()![CourseID]!=null)
      // {
      //
      //   print("List-----$list");
      //   for(int i=0;i<list.length;i++)
      //   {
      //     for(int j=0;j<list[i]["videos"].length;j++)
      //     {
      //       list[i]["videos"][j]["type"]=="video"?null:list[i]["videos"].removeAt(j);
      //     }
      //   }
      //   list.sort((a, b) {
      //     if (a["sr"] > b["sr"]) {
      //       return 1;
      //     }
      //     return -1;
      //   });
      //
      //   /* check */
      //   var finalProgressData = [];
      //   var progressData = value.data()![CourseID];
      //
      //   for(int i=0;i<list.length;i++)
      //   {
      //     for(int k=0;k<progressData.length;k++)
      //       {
      //         if(progressData[k][list[i]["id"]]!=null)
      //           {
      //             print("((((((( ${progressData[k]}");
      //             finalProgressData.add(progressData[k]);
      //           }
      //       }
      //   }
      //
      //   print("UUUUUUUUU $finalProgressData");
      //
      //
      //   await FirebaseFirestore.instance.collection("courseprogress").doc(_auth.currentUser!.uid).update({CourseID.toString():finalProgressData});
      //
      //
      //   print("yyyyyyy $list");
      //   value.data()![CourseID][0][list[0]["id"]];
      //
      //   for(int k=0;k<list.length;k++)
      //     {
      //       if(finalProgressData[k][list[k]["id"]]!=null){
      //
      //       }
      //       else{
      //
      //       }
      //     }
      //   // print("&&&&&&&& ${_initialVideoPercentageList[widget.courseName]}");
      //
      //
      //
      //   print("data((--- ${finalProgressData}");
      //   var data = finalProgressData;
      //   print("oooo ${list.length}");
      //   if(list.length==finalProgressData.length)
      //   {
      //     for(int k=0;k<list.length;k++)
      //     {
      //       if(list[k]["videos"].length==finalProgressData[k][list[k]["id"]].length)
      //       {
      //
      //       }
      //       else
      //       {
      //         if(list[k]["videos"].length>finalProgressData[k][list[k]["id"]].length)
      //         {
      //           for(int g=0;g<list[k]["videos"].length;g++)
      //           {
      //             int count = 0;
      //             finalProgressData[k][list[k]["id"]].forEach((ele)=>{
      //               if(ele.containsKey(list[k]["videos"][g]["id"]))
      //                 {
      //                   // print("True")
      //                   count =1
      //                 }
      //               else{
      //                 print("false")
      //                 // data[k][list[k]["id"]].add(ele)
      //               }
      //             });
      //             count==1?null:data[k][list[k]["id"]].add({list[k]["videos"][g]["id"].toString():0});
      //           }
      //         }
      //         else
      //         {
      //           for(int g=0;g<data[k][list[k]["id"]].length;g++)
      //           {
      //             int count = 0;
      //             print("====${data[k][list[k]["id"]][g]}");
      //             list[k]["videos"].forEach((ele)=>{
      //               if(data[k][list[k]["id"]][g].containsKey(ele["id"]))
      //                 {
      //                   count =1
      //                 }
      //               else{
      //                 print("false ${ele["id"]}")
      //               }
      //             });
      //             count==0?data[k][list[k]["id"]].removeAt(g):null;
      //           }
      //         }
      //       }
      //     }
      //   }
      //   else
      //   {
      //     if(list.length>finalProgressData.length)
      //     {
      //       for(int i=0;i<list.length;i++)
      //       {
      //         int count = 0;
      //         finalProgressData.forEach((ele)=>{
      //           // print("tyypypypyp $ele")
      //           if(ele.containsKey(list[i]["id"]))
      //             {
      //               // print("True")
      //               count =1
      //             }
      //           else{
      //             print("false")
      //             // data[k][list[k]["id"]].add(ele)
      //           }
      //         });
      //         var listOfID = [];
      //         for(int j=0;j<list[i]["videos"].length;j++)
      //         {
      //           listOfID.add({list[i]["videos"][j]["id"]:0});
      //         }
      //         print("iddddddd");
      //         print(listOfID);
      //         count==1?null:data.add({list[i]["id"].toString():listOfID});
      //       }
      //     }
      //     else
      //     {
      //       for(int j=0;j<data.length;j++)
      //       {
      //         int count =0;
      //         list.forEach((ele){
      //           if(data[j].containsKey(ele["id"]))
      //           {
      //             count =1;
      //           }
      //         });
      //         count==1?null:data.removeAt(j);
      //       }
      //     }
      //   }
      //
      //   await FirebaseFirestore.instance.collection("courseprogress").doc(_auth.currentUser!.uid).update({CourseID.toString():data});
      //   print("finally  $data");
      //   _getVideoPercentageList = data;
      // }
      // else if(value.data()![CourseID]!=null){
      //   var list = await res.get("curriculum1")[widget.courseName];
      //   _initialVideoPercentageList[widget.courseName.toString()] = [];
      //   for (int i = 0; i < list.length; i++) {
      //     print(_initialVideoPercentageList[widget.courseName.toString()]
      //         .runtimeType);
      //     _initialVideoPercentageList[widget.courseName.toString()]
      //         .add({list[i]["id"].toString(): []});
      //     for (int j = 0; j < list[i]["videos"].length; j++) {
      //       list[i]["videos"][j]["type"]=="video"?_initialVideoPercentageList[widget.courseName][i]
      //       [list[i]["id"]]
      //           .add({list[i]["videos"][j]["id"]: 0}):null;
      //     }
      //   }
      //   print("**** $_initialVideoPercentageList");
      //   await getUserRole();
      //   await FirebaseFirestore.instance
      //       .collection("courseprogress")
      //       .doc(_auth.currentUser!.uid.toString())
      //       .update({
      //     CourseID.toString():
      //     _initialVideoPercentageList[widget.courseName.toString()],
      //     "email": userEmail,
      //   }).catchError((err)=>print("Error$err"));
      //   print("done----");
      //   _getVideoPercentageList =
      //   _initialVideoPercentageList[widget.courseName.toString()];
      // }
      // else{
      //   var list = await res.get("curriculum1")[widget.courseName];
      //   _initialVideoPercentageList[widget.courseName.toString()] = [];
      //   for (int i = 0; i < list.length; i++) {
      //     print(_initialVideoPercentageList[widget.courseName.toString()]
      //         .runtimeType);
      //     _initialVideoPercentageList[widget.courseName.toString()]
      //         .add({list[i]["id"].toString(): []});
      //     for (int j = 0; j < list[i]["videos"].length; j++) {
      //       list[i]["videos"][j]["type"]=="video"?_initialVideoPercentageList[widget.courseName][i]
      //       [list[i]["id"]]
      //           .add({list[i]["videos"][j]["id"]: 0}):null;
      //     }
      //   }
      //   print("**** $_initialVideoPercentageList");
      //   await getUserRole();
      //   await FirebaseFirestore.instance
      //       .collection("courseprogress")
      //       .doc(_auth.currentUser!.uid.toString())
      //       .set({
      //     CourseID.toString():
      //     _initialVideoPercentageList[widget.courseName.toString()],
      //     "email": userEmail,
      //   }).catchError((err)=>print("Error$err"));
      //   print("done----");
      //   _getVideoPercentageList =
      //   _initialVideoPercentageList[widget.courseName.toString()];
      // }

      if (value.exists) {
        if (value.data()![CourseID] != null) {
          print("List-----$list");
       for(int i=0;i<list.length;i++)
          {
           await list[i]["videos"].removeWhere((item) => item['type'] != "video");
          }

          print(await list);
          list.sort((a, b) {
            if (a["sr"] > b["sr"]) {
              return 1;
            }
            return -1;
          });

          /* check */
          var finalProgressData = [];
          var progressData = value.data()![CourseID];

          for (int i = 0; i < list.length; i++) {
            // int counter = 0;
            for (int k = 0; k < progressData.length; k++) {
              if (progressData[k][list[i]["id"]] != null) {
                print("((((((( ${progressData[k]}");
                finalProgressData.add(progressData[k]);
                // counter=1;
              }
            }
            for(int i=0;i<finalProgressData.length;i++)
          {
            for(var items in finalProgressData[i].entries)
            {
              int count = 0;
              for(var k in items.value){
//         print(k.values.first);
//         print("**");
                finalProgressData[i][items.key]![count][k.keys.first]>100?finalProgressData[i][items.key]![count][k.keys.first]=100:null;
                count++;
              }
            }
          }
            // Map<String,dynamic> moduleNew = {};
            // if(counter==0)
            //   {
            //     for(int k=0;k<list[i]["videos"].length;k++)
            //       {
            //         moduleNew[list[i]["id"].toString()]!.add({list[i]["videos"][k]["id"]:0});
            //       }
            //     // print("dic===$dic");
            //   }
            // counter==0?print("RRRTTT    ${list[i]["videos"]}  $moduleNew"):null;
          }
          Map<String, int> tempMap = {};

  var uniqueList = [];

          var removeDuplicateList = [];
          for(int h=0;h<progressData.length;h++)
            {
             await progressData[h].forEach((key,val)async{
               print("9jdeiuwbw$val");
                await val.forEach((map)async{
                  print("Malppppp");
                    await map.forEach((key, value) {
                      print("PLOPOPO");
                    if (!tempMap.containsKey(key)) {
                      tempMap.putIfAbsent(key, () => value);
                      print(map);
                      uniqueList.add(map);
                      print("Map------$map");
                    }
                    print("Map--------");
                  });
                });
                print("plplplplplplp");
                print(uniqueList);
                removeDuplicateList.add({key:uniqueList});
                uniqueList = [];
                tempMap = {};
              });
            }
          finalProgressData = removeDuplicateList;

          print("UUUUUUUUU $finalProgressData");

          await FirebaseFirestore.instance
              .collection("courseprogress")
              .doc(_auth.currentUser!.uid)
              .update({CourseID.toString(): finalProgressData});

          print("yyyyyyy $list");
          // value.data()![CourseID][0][list[0]["id"]];

          // print("&&&&&&&& ${_initialVideoPercentageList[widget.courseName]}");

          print("data((--- ${finalProgressData}");
          var data = finalProgressData;
          print("oooo ${list.length}");
          if (list.length == finalProgressData.length) {
            for (int k = 0; k < list.length; k++) {
              if (list[k]["videos"].length ==
                  finalProgressData[k][list[k]["id"]].length) {
              } else {
                if (list[k]["videos"].length >
                    finalProgressData[k][list[k]["id"]].length) {
                  for (int g = 0; g < list[k]["videos"].length; g++) {
                    int count = 0;
                    finalProgressData[k][list[k]["id"]].forEach((ele) => {
                          if (ele.containsKey(list[k]["videos"][g]["id"]))
                            {
                              // print("True")
                              count = 1
                            }
                          else
                            {
                              print("false")
                              // data[k][list[k]["id"]].add(ele)
                            }
                        });
                    count == 1
                        ? null
                        : data[k][list[k]["id"]]
                            .add({list[k]["videos"][g]["id"].toString(): 0});
                  }
                } else {
                  for (int g = 0; g < data[k][list[k]["id"]].length; g++) {
                    int count = 0;
                    print("====${data[k][list[k]["id"]][g]}");
                    list[k]["videos"].forEach((ele) => {
                          if (data[k][list[k]["id"]][g].containsKey(ele["id"]))
                            {count = 1}
                          else
                            {print("false ${ele["id"]}")}
                        });
                    count == 0 ? data[k][list[k]["id"]].removeAt(g) : null;
                  }
                }
              }
            }
          } else {
            if (list.length > finalProgressData.length) {
              for (int i = 0; i < list.length; i++) {
                int count = 0;
                finalProgressData.forEach((ele) => {
                      // print("tyypypypyp $ele")
                      if (ele.containsKey(list[i]["id"]))
                        {
                          // print("True")
                          count = 1
                        }
                      else
                        {
                          print("false")
                          // data[k][list[k]["id"]].add(ele)
                        }
                    });
                var listOfID = [];
                for (int j = 0; j < list[i]["videos"].length; j++) {
                  listOfID.add({list[i]["videos"][j]["id"]: 0});
                }
                print("iddddddd");
                print(listOfID);
                count == 1
                    ? null
                    : data.add({list[i]["id"].toString(): listOfID});
              }
            } else {
              for (int j = 0; j < data.length; j++) {
                int count = 0;
                list.forEach((ele) {
                  if (data[j].containsKey(ele["id"])) {
                    count = 1;
                  }
                });
                count == 1 ? null : data.removeAt(j);
              }
            }
          }

          await FirebaseFirestore.instance
              .collection("courseprogress")
              .doc(_auth.currentUser!.uid)
              .update({CourseID.toString(): data});
          print("finally  $data");
          _getVideoPercentageList = data;
        } else {
          var list = await res.get("curriculum1")[widget.courseName];
          list.sort((a, b) {
            if (a["sr"] > b["sr"]) {
              return 1;
            }
            return -1;
          });
          _initialVideoPercentageList[widget.courseName.toString()] = [];
          for (int i = 0; i < list.length; i++) {
            print(_initialVideoPercentageList[widget.courseName.toString()]
                .runtimeType);
            _initialVideoPercentageList[widget.courseName.toString()]
                .add({list[i]["id"].toString(): []});
            for (int j = 0; j < list[i]["videos"].length; j++) {
              list[i]["videos"][j]["type"] == "video"
                  ? _initialVideoPercentageList[widget.courseName][i]
                          [list[i]["id"]]
                      .add({list[i]["videos"][j]["id"]: 0})
                  : null;
            }
          }
          print("**** $_initialVideoPercentageList");
          await getUserRole();
          await FirebaseFirestore.instance
              .collection("courseprogress")
              .doc(_auth.currentUser!.uid.toString())
              .update({
            CourseID.toString():
                _initialVideoPercentageList[widget.courseName.toString()],
            "email": userEmail,
          }).catchError((err) => print("Error$err"));
          print("done----");
          _getVideoPercentageList =
              _initialVideoPercentageList[widget.courseName.toString()];
        }
      } else {
        var list = await res.get("curriculum1")[widget.courseName];
        list.sort((a, b) {
          if (a["sr"] > b["sr"]) {
            return 1;
          }
          return -1;
        });
        _initialVideoPercentageList[widget.courseName.toString()] = [];
        for (int i = 0; i < list.length; i++) {
          print(_initialVideoPercentageList[widget.courseName.toString()]
              .runtimeType);
          _initialVideoPercentageList[widget.courseName.toString()]
              .add({list[i]["id"].toString(): []});
          for (int j = 0; j < list[i]["videos"].length; j++) {
            list[i]["videos"][j]["type"] == "video"
                ? _initialVideoPercentageList[widget.courseName][i]
                        [list[i]["id"]]
                    .add({list[i]["videos"][j]["id"]: 0})
                : null;
          }
        }
        print("**** $_initialVideoPercentageList");
        await getUserRole();
        await FirebaseFirestore.instance
            .collection("courseprogress")
            .doc(_auth.currentUser!.uid.toString())
            .set({
          CourseID.toString():
              _initialVideoPercentageList[widget.courseName.toString()],
          "email": userEmail,
        }).catchError((err) => print("Error$err"));
        print("done----");
        _getVideoPercentageList =
            _initialVideoPercentageList[widget.courseName.toString()];
      }
    });
    setState(() {
      _getVideoPercentageList;
    });
  }

  Future download({
    Dio? dio,
    String? url,
    String? savePath,
    String? fileName,
    String? courseName,
    String? topicName,
  }) async {
    getPermission();
    var directory = await getApplicationDocumentsDirectory();
    try {
      setState(() {
        downloading = true;
      });
      Response response = await dio!.get(
        url!,
        onReceiveProgress: (rec, total) {
          _downloadProgress.value = rec / total;
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(response.headers);
      File file = File(savePath!);
      var raf = file.openSync(mode: FileMode.write);
      print('savePath--$savePath');

      raf.writeFromSync(response.data);
      await raf.close();
      DatabaseHelper _dbhelper = DatabaseHelper();
      OfflineModel video = OfflineModel(
          topic: topicName,
          path: '${directory.path}/${fileName!.replaceAll(' ', '')}.mp4');
      _dbhelper.insertTask(video);

      setState(() {
        downloading = false;
        downloaded = true;
      });
    } catch (e) {
      print('e::$e');
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  // updateCourseCompletionPercentage(videoPercentageListUpdate) async {
  //   // await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
  //   //   courseName : videoPercentageListUpdate,
  //   // }).then((value) => print(videoPercentageListUpdate)).catchError((error) => print('dipen = $error'));
  //   // print('I am uid = ${FirebaseAuth.instance.currentUser!.uid}');
  //   print("Videosssssssssssss ${videoPercentageList.length}");
  //   int total = 0;
  //   int count = 0;
  //   if (videoPercentageListUpdate.length != 0) {
  //     print("ppop = ${videoPercentageListUpdate}");
  //     for (int i = 0; i < videoPercentageListUpdate.length; i++) {
  //       print("999999999999");
  //       print("dddddddddd ${videoPercentageListUpdate[i].toString()}");
  //       for (int j = 0;
  //           j < videoPercentageListUpdate[i][sectionName[i]]!.length;
  //           j++) {
  //         print("lllllllllllllllllllllllll");
  //         for (var kv
  //             in videoPercentageListUpdate[i][sectionName[i]]![j].entries) {
  //           print("ppppppppppppppppppppppppppp");
  //           print(kv.value);
  //           total += int.parse(kv.value.toString());
  //           count += 1;
  //         }
  //       }
  //     }
  //   }
  //
  //   videoPercentageListUpdate != null
  //       ? await FirebaseFirestore.instance
  //           .collection('courseprogress')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get()
  //           .then((value) async {
  //           print('srinivas ${value.data().toString()}');
  //           if (value.exists && videoPercentageListUpdate.length != 0) {
  //             await FirebaseFirestore.instance
  //                 .collection('courseprogress')
  //                 .doc(_auth.currentUser!.uid)
  //                 .update({
  //               courseName: videoPercentageListUpdate,
  //               'email': _auth.currentUser!.email,
  //               courseName.toString() + "percentage":
  //                   total != 0 && count != 0 ? total / count : 0
  //             }).catchError((onError) {
  //               print('srinnn = $onError');
  //             });
  //           } else {
  //             videoPercentageListUpdate.length != 0
  //                 ? await FirebaseFirestore.instance
  //                     .collection('courseprogress')
  //                     .doc(_auth.currentUser!.uid)
  //                     .set({
  //                     courseName: videoPercentageListUpdate,
  //                     'email': FirebaseAuth.instance.currentUser!.email,
  //                     courseName.toString() + "percentage":
  //                         total != 0 && count != 0 ? (total / count).toInt() : 0
  //                   })
  //                 : null;
  //           }
  //         }).catchError((onError) {
  //           print('srinu $onError');
  //         })
  //       : null;
  // }

  @override
  void dispose() {
    super.dispose();
    print("disposeeeee");
    _videoController!.dispose();
    AutoOrientation.portraitUpMode();
    _disposed = true;
    _videoController = null;
  }

  String? role;
  String? userEmail;
   String? studentId;
 String? studentName;
  getUserRole() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        role = value.exists ? value.data()!["role"] : null;
        userEmail = value.exists ? value.data()!['email'] : null;
          studentId = value.exists ? value.data()!['id'] : null;
        studentName = value.exists ? value.data()!['name'] : null;
      });
    });
  }

  streamVideoData() async {
    print("Videoss;");
    print(widget.cID);
    await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.cID)
        .get()
        .then((value) async {
      print("!!!!!!!!!!!!!!!!!!!!!!! ${value.data()}");
      Map<String, dynamic>? data = await value.data();
      Counter.counterSinkVideos.add(data != null ? data : null);
    });
  }

  String? currentPlayingVideoName;

  getFirstVideo() async {
    print("Firstvideo---");
    var res = await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.cID)
        .get();
    var list = res.get("curriculum1")[widget.courseName];
    list.sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });
    list[0]["videos"].sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });
    setState(() {
      currentPlayingVideoName = list[0]["videos"][0]["name"].toString();
    });
    initializeVidController(
      list[0]["videos"][0]["url"].toString(),
      list[0]["videos"][0]["name"].toString(),
      list[0]["modulename"].toString(),
      list[0]["id"].toString(),
      list[0]["videos"][0]["id"].toString(),
    );
  }

  @override
  void initState() {
    globalquizstatus();
    // html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
    VideoScreen.currentSpeed.value = 1.0;
    // getData();
    // getCourseData();
    streamVideoData();
    getCourseQuiz();
    getUserRole();
    getProgressData();
    getpathway(widget.courseName);
    Future.delayed(Duration(milliseconds: 500), () {
      getFirstVideo();

    });

    super.initState();
  }
  bool _switchValue = false;
  globalquizstatus() async {
    await FirebaseFirestore.instance
        .collection("Controllers")
        .doc('variables')
        .get()
        .then((value) {
      setState(() {
        _switchValue = value.data()!['globalquiz'];
      });
    });
  }

  List coursequiz = [];

  getCourseQuiz() async {
    try {
      await FirebaseFirestore.instance
          .collection("courses")
          .where("name", isEqualTo: widget.courseName)
          .get()
          .then((value) {
        setState(() {
          try {
            coursequiz = value.docs.first.data()['coursequiz'];
          } catch (e) {
            setState(() {
              coursequiz = [];
            });
          }
        });

        print("coursequiz1: ${coursequiz}");
      });
    } catch (e) {
      setState(() {
        coursequiz = [];
      });
      print(e.toString());
    }
  }

  bool menuClicked = false;
  String solutionUrl = '';
  String assignmentUrl = '';
  int? currentIndex;
  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
        // floatingActionButton: floatingButton(context),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth >= 650) {
        return Container(
          color: Colors.white,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return Row(
                children: [
                  menuClicked
                      ? isPortrait
                          ? Container()
                          : SizedBox()
                      : Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _videoController!.pause();
                                  widget.isDemo == null
                                      ? Navigator.pop(context)
                                      : GoRouter.of(context)
                                          .pushReplacementNamed('myCourses');
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_back_ios),
                                      Text(
                                        'Back to courses',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              Expanded(
                                child: _buildVideoDetails(
                                    // horizontalScale,
                                    // verticalScale,
                                    ),
                              ),
                            ],
                          ),
                        ),
                  !htmlbool
                      ? Expanded(
                          flex: 2,
                          child: showAssignment
                              ? AssignmentScreen(
                                  selectedSection: selectedSection,
                                  courseData: courseData,
                                  courseName: widget.courseName,
                                  assignmentUrl: assignmentUrl,
                                  dataSetUrl: dataSetUrl,
                                  solutionUrl: solutionUrl,
                                  assignmentName: assignmentName,
                                )
                              :submitResume
                                  ? SubmitResume(
                                      studentId: studentId ?? '',
                                      studentEmail: userEmail ?? '',
                                      studentName: studentName ?? '',
                                    )
                                  : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                      future: playVideo,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (ConnectionState.done ==
                                            snapshot.connectionState) {
                                          return Stack(
                                            children: [
                                              Container(
                                                height: menuClicked
                                                    ? screenHeight
                                                    : screenHeight / 1.2,
                                                child: Center(
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: VideoPlayer(
                                                        _videoController!),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      enablePauseScreen =
                                                          !enablePauseScreen;
                                                      // print(
                                                      //     'Container of column clicked');
                                                    });
                                                  },
                                                  child: Container(
                                                    height: menuClicked
                                                        ? screenHeight
                                                        : screenHeight / 1.2,
                                                    width: screenWidth,
                                                  )),
                                              enablePauseScreen
                                                  ? Container(
                                                      height: menuClicked
                                                          ? screenHeight
                                                          : screenHeight / 1.2,
                                                      child: _buildControls(
                                                        context,
                                                        isPortrait,
                                                        horizontalScale,
                                                        verticalScale,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              _isBuffering && !enablePauseScreen
                                                  ? Center(
                                                      heightFactor: 6.2,
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Color.fromARGB(
                                                            114,
                                                            255,
                                                            255,
                                                            255,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          );
                                        } else {
                                          return Container(
                                            height: screenHeight / 1.2,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF7860DC),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    menuClicked
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                              videoTitle.toString() != 'null'
                                                  ? videoTitle.toString()
                                                  : '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'SemiBold'),
                                            ),
                                          ),
                                    isPortrait
                                        ? _buildPartition(
                                            context,
                                            horizontalScale,
                                            verticalScale,
                                          )
                                        : SizedBox(),
                                    isPortrait
                                        ? SizedBox()
                                        // Expanded(
                                        //   flex: 2,
                                        //   child: _buildVideoDetailsListTile(
                                        //     horizontalScale,
                                        //     verticalScale,
                                        //   ),
                                        // )
                                        : SizedBox(),
                                  ],
                                ),
                        )
                      : quizbool
                          ? Expanded(
                              flex: 2,
                              child: QuizentrypageWidget(quizdata))
                          : Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: SingleChildScrollView(
                                    child: HtmlWidget('''
                                                $htmltext
                                                '''),
                                  ),
                                ),
                              ),
                            ),
                ],
              );
            },
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    !htmlbool
                        ? showAssignment
                            ? AssignmentScreen(
                                selectedSection: selectedSection,
                                courseData: courseData,
                                courseName: widget.courseName,
                                assignmentUrl: assignmentUrl,
                                dataSetUrl: dataSetUrl,
                                solutionUrl: solutionUrl,
                                assignmentName: assignmentName,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: playVideo,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (ConnectionState.done ==
                                          snapshot.connectionState) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: screenHeight / 3,
                                              width: screenWidth,
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: VideoPlayer(
                                                      _videoController!),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    enablePauseScreen =
                                                        !enablePauseScreen;
                                                    // print(
                                                    //     'Container of column clicked');
                                                  });
                                                },
                                                child: Container(
                                                  height: screenHeight / 3,
                                                  width: screenWidth,
                                                )),
                                            enablePauseScreen
                                                ? Container(
                                                    height: screenHeight / 3,
                                                    child: _buildControls(
                                                      context,
                                                      isPortrait,
                                                      horizontalScale,
                                                      verticalScale,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            _isBuffering && !enablePauseScreen
                                                ? Center(
                                                    heightFactor: 6.2,
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Color.fromARGB(
                                                          114,
                                                          255,
                                                          255,
                                                          255,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      } else {
                                        return Container(
                                          height: screenHeight / 3,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF7860DC),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      videoTitle.toString() != 'null'
                                          ? videoTitle.toString()
                                          : '',
                                      style: TextStyle(
                                          fontSize: 18, fontFamily: 'SemiBold'),
                                    ),
                                  ),
                                  isPortrait
                                      ? SizedBox()
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: _buildVideoDetailsListTile(
                                      //     horizontalScale,
                                      //     verticalScale,
                                      //   ),
                                      // )
                                      : SizedBox(),
                                ],
                              )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: SingleChildScrollView(
                                child: HtmlWidget('''
                                                   $htmltext
                                                    '''),
                              ),
                            ),
                          ),
                    _buildVideoDetails(),
                  ],
                ),
              );

              //   Row(
              //   children: [
              //     menuClicked
              //         ? isPortrait
              //         ? Container()
              //         : SizedBox()
              //         : Expanded(
              //       flex: 1,
              //       child: Column(
              //         children: [
              //           InkWell(
              //             onTap: () {
              //               widget.isDemo == null
              //                   ? Navigator.of(context).pop()
              //                   : GoRouter.of(context)
              //                   .pushReplacementNamed('myCourses');
              //               // Navigator.pop(context);
              //             },
              //             child: Container(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Row(
              //                     children: [
              //                       Icon(Icons.arrow_back_ios),
              //                       Text(
              //                         'Back to courses',
              //                         style:
              //                         TextStyle(fontWeight: FontWeight.bold),
              //                       )
              //                     ],
              //                   ),
              //                 )),
              //           ),
              //
              //         ],
              //       ),
              //     ),
              //
              //   ],
              // );
            },
          ),
        );
      }
    }));
  }

   String? assignmentFileName;
  Uint8List? uploadedAssignmentFile;

  String? pdfFileName;
  Uint8List? uploadedpdfFile;

  String? datasetFileName;
  Uint8List? uploadedDatasetFile;
  TextEditingController addAssignmentNameController = TextEditingController();
  bool addAssignmentLoading = false;

  TextEditingController assignmentLinkController = TextEditingController();
  TextEditingController pdfLinkController = TextEditingController();
  TextEditingController datasetLinkController = TextEditingController();

  Widget addAssigmentPopUp({required dynamic listOfSectionData}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: width / 50, vertical: height / 50),
        width: width / 2,
        decoration: BoxDecoration(
          color: Color(0xffF2E9FE),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              child: Text(
                'Add Assignment',
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Material(
              child: TextFormField(
                controller: addAssignmentNameController,
                decoration: InputDecoration(
                  fillColor: Color(0xffF2E9FE),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: 'Enter Assignment Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
            addAssignmentBox(
                uploadedFile: uploadedAssignmentFile,
                fileName: assignmentFileName,
                onChooseFile: () async {
                  if (assignmentLinkController.text.isEmpty) {
                    await getAssignmentFile(
                        listOfSectionData: listOfSectionData);
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'Remove Assignment link if you want to attach file');
                  }
                },
                name: 'Assignment',
                controller: assignmentLinkController,
                onDelete: () {
                  setState(() {
                    uploadedAssignmentFile = null;
                    assignmentFileName = '';
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addAssigmentPopUp(
                            listOfSectionData: listOfSectionData);
                      },
                    );
                  });
                }),
            SizedBox(
              height: height / 50,
            ),
            addAssignmentBox(
                uploadedFile: uploadedpdfFile,
                fileName: pdfFileName,
                onChooseFile: () async {
                  if (pdfLinkController.text.isEmpty) {
                    await getPdfFile(listOfSectionData: listOfSectionData);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Remove Pdf link if you want to attach file');
                  }
                },
                name: 'Pdf',
                controller: pdfLinkController,
                onDelete: () {
                  setState(() {
                    uploadedpdfFile = null;
                    pdfFileName = '';
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addAssigmentPopUp(
                            listOfSectionData: listOfSectionData);
                      },
                    );
                  });
                }),
            SizedBox(
              height: height / 50,
            ),
            addAssignmentBox(
                uploadedFile: uploadedDatasetFile,
                fileName: datasetFileName,
                onChooseFile: () async {
                  if (datasetLinkController.text.isEmpty) {
                    await getDatasetFile(listOfSectionData: listOfSectionData);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Remove Dataset link if you want to attach file');
                  }
                },
                name: 'Dataset',
                controller: datasetLinkController,
                onDelete: () {
                  setState(() {
                    uploadedDatasetFile = null;
                    datasetFileName = '';
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addAssigmentPopUp(
                            listOfSectionData: listOfSectionData);
                      },
                    );
                  });
                }),
            SizedBox(
              height: height / 50,
            ),
            Center(
              child: StatefulBuilder(builder: (context, state) {
                return addAssignmentLoading
                    ? CircularProgressIndicator(
                        color: Colors.black, strokeWidth: 2)
                    : ElevatedButton(
                        onPressed: () async {
                          state;
                          addAssignmentLoading = true;
                          addAssignment(listOfSectionData: listOfSectionData)
                              .whenComplete(() {
                            addAssignmentLoading = false;
                            state;
                          });
                        },
                        child: Text("Add Assignment"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                      );
              }),
            )
          ],
        ),
      ),
    );
  }

  Future getAssignmentFile({required dynamic listOfSectionData}) async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedAssignmentFile = uploadFile;
          assignmentFileName = pickedFileName;
        });

        if (uploadedAssignmentFile != null) {
          Fluttertoast.showToast(msg: 'Assignment file is attached');
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return addAssigmentPopUp(listOfSectionData: listOfSectionData);
            },
          );
          print('Asssignment File : ${assignmentFileName.toString()}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  Future getPdfFile({required dynamic listOfSectionData}) async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedpdfFile = uploadFile;
          pdfFileName = pickedFileName;
        });

        if (uploadedpdfFile != null) {
          Fluttertoast.showToast(msg: 'Pdf file is attached');
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return addAssigmentPopUp(listOfSectionData: listOfSectionData);
            },
          );
          print('Pdf File : ${pdfFileName.toString()}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  Future getDatasetFile({required dynamic listOfSectionData}) async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedDatasetFile = uploadFile;
          datasetFileName = pickedFileName;
        });

        if (uploadedDatasetFile != null) {
          Fluttertoast.showToast(msg: 'Dataset file is attached');
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return addAssigmentPopUp(listOfSectionData: listOfSectionData);
            },
          );
          print('Dataset File : ${datasetFileName.toString()}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  Future addAssignment({required dynamic listOfSectionData}) async {
    if (uploadedAssignmentFile == null &&
        uploadedDatasetFile == null &&
        uploadedpdfFile == null &&
        assignmentLinkController.text.isEmpty &&
        pdfLinkController.text.isEmpty &&
        datasetLinkController.text.isEmpty) {
      setState(() {
        Fluttertoast.showToast(
            msg: 'Please Select Assignment Or Pdf Or Dataset');
      });
    } else if (addAssignmentNameController.text.isEmpty) {
      setState(() {
        Fluttertoast.showToast(msg: 'Please Enter Assignment Name');
      });
    } else {
      try {
        String assignmentUrlLink = '';
        String pdfUrlLink = '';
        String datasetUrlLink = '';
        print('Course Name : ${widget.courseName!}');
        print('Course Id : ${widget.cID!}');

        if (uploadedAssignmentFile != null) {
          var assignmentStorageRef = FirebaseStorage.instance
              .ref()
              .child('courses')
              .child(widget.courseName!)
              .child('assignment')
              .child(assignmentFileName!);

          final UploadTask assignmentUploadTask =
              assignmentStorageRef.putData(uploadedAssignmentFile!);

          final TaskSnapshot downloadUrl = await assignmentUploadTask;
          final String fileURL = (await downloadUrl.ref.getDownloadURL());
          assignmentUrlLink = fileURL;
          print('Assignment link :  $fileURL');
        }

        if (uploadedpdfFile != null) {
          var pdfStorageRef = FirebaseStorage.instance
              .ref()
              .child('courses')
              .child(widget.courseName!)
              .child('solution')
              .child(pdfFileName!);

          final UploadTask pdfUploadTask =
              pdfStorageRef.putData(uploadedpdfFile!);

          final TaskSnapshot downloadUrl = await pdfUploadTask;
          final String fileURL = (await downloadUrl.ref.getDownloadURL());
          pdfUrlLink = fileURL;
          print('Pdf link :  $fileURL');
        }

        if (uploadedDatasetFile != null) {
          var dataSetStorageRef = FirebaseStorage.instance
              .ref()
              .child('courses')
              .child(widget.courseName!)
              .child('dataset')
              .child(datasetFileName!);

          final UploadTask dataSetUploadTask =
              dataSetStorageRef.putData(uploadedDatasetFile!);

          final TaskSnapshot downloadUrl = await dataSetUploadTask;
          final String fileURL = (await downloadUrl.ref.getDownloadURL());
          datasetUrlLink = fileURL;
          print('Dataset link :  $fileURL');
        }

        final firestoreInstance = FirebaseFirestore.instance;

        final courseRef = firestoreInstance.collection('courses');

        try {
          listOfSectionData[widget.courseName][editIndex]['videos'].add({
            if (uploadedDatasetFile != null)
              'dataset': [
                {'name': 'Dataset', 'url': datasetUrlLink}
              ]  else if(datasetLinkController.text.isNotEmpty)
              'dataset': [
                {'name': 'Dataset', 'url': datasetLinkController.text}
              ],
            'name': addAssignmentNameController.text,
            if (uploadedAssignmentFile != null) 'url': assignmentUrlLink else if (assignmentLinkController.text.isNotEmpty) 'url': assignmentLinkController.text,
            if (uploadedpdfFile != null) 'pdf': pdfUrlLink else if (pdfLinkController.text.isNotEmpty) 'pdf': pdfLinkController.text,
            'type': 'assignment',
            'sr': listOfSectionData[widget.courseName][editIndex]['videos']
                .length,
          });

          await courseRef.doc(widget.cID).update({
            'curriculum1': {
              widget.courseName: listOfSectionData[widget.courseName]
            }
          }).whenComplete(() {
            setState(() {
              assignmentFileName = null;
              uploadedAssignmentFile = null;

              pdfFileName = null;
              uploadedpdfFile = null;

              datasetFileName = null;
              uploadedDatasetFile = null;
              addAssignmentNameController.text = '';
              assignmentLinkController.clear();
              pdfLinkController.clear();
              datasetLinkController.clear();
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'Assignment Added!!');
              
            });
          });
        } catch (e) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Try Again');

          print('Errrorrr is :: $e');
        }
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Try Again');
      }
    }
  }

  Widget addAssignmentBox(
      {required Uint8List? uploadedFile,
      required String? fileName,
      required VoidCallback onChooseFile,
      required String name,
      required TextEditingController controller,
      required VoidCallback onDelete}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurpleAccent, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onChooseFile,
                  icon: Icon(Icons.upload_file),
                  label: Text("Choose $name",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DefaultTextStyle(
                style: TextStyle(fontSize: 12, color: Colors.black),
                child: Text(
                  "OR",
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Material(
                  child: TextFormField(
                    controller: controller,
                    onTap: uploadedFile != null
                        ? () {
                            Fluttertoast.showToast(
                                msg: 'Please Remove Attached File');
                          }
                        : null,
                    readOnly: uploadedFile != null ? true : false,
                    decoration: InputDecoration(
                      fillColor: Color(0xffF2E9FE),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: '$name Link',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          uploadedFile != null
              ? DefaultTextStyle(
                  style: TextStyle(fontSize: 18, color: Colors.black26),
                  child: Row(
                    children: [
                      Text(
                        fileName!,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : DefaultTextStyle(
                  style: TextStyle(fontSize: 18, color: Colors.black26),
                  child: Text(
                    "No file chosen",
                  ),
                ),
        ],
      ),
    );
  }


  Widget _buildControls(
    BuildContext context,
    bool isPortrait,
    double horizontalScale,
    double verticalScale,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          enablePauseScreen = !enablePauseScreen;
        });
      },
      child: Container(
        height: screenHeight / 3,
        width: screenWidth,
        color: Color.fromARGB(114, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(
                videoTitle.toString() != 'null' ? videoTitle.toString() : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  showSettingsBottomsheet(
                    context,
                    horizontalScale,
                    verticalScale,
                    _videoController!,
                  );
                  // var directory = await getApplicationDocumentsDirectory();
                  // download(
                  //   dio: Dio(),
                  //   fileName: data!['name'],
                  //   url: data!['url'],
                  //   savePath:
                  //       "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                  //   topicName: data!['name'],
                  // );
                  // print(directory.path);
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _currentVideoIndex,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _currentVideoIndex.value >= 1
                        ? InkWell(
                            onTap: () {
                              VideoScreen.currentSpeed.value = 1.0;
                              _currentVideoIndex.value--;
                              initializeVidController(
                                  _listOfVideoDetails[_currentVideoIndex.value]
                                      .videoUrl,
                                  _listOfVideoDetails[_currentVideoIndex.value]
                                      .videoTitle,
                                  "",
                                  "",
                                  "");
                            },
                            child: Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        : SizedBox(),
                    replay10(
                      videoController: _videoController,
                    ),
                    !_isBuffering
                        ? InkWell(
                            onTap: () {
                              if (_isPlaying) {
                                setState(() {
                                  _videoController!.pause();
                                });
                              } else {
                                setState(() {
                                  enablePauseScreen = !enablePauseScreen;
                                  _videoController!.play();
                                });
                              }
                            },
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : CircularProgressIndicator(
                            color: Color.fromARGB(
                              114,
                              255,
                              255,
                              255,
                            ),
                          ),
                    fastForward10(
                      videoController: _videoController,
                    ),
                    _currentVideoIndex.value < _listOfVideoDetails.length - 1
                        ? InkWell(
                            onTap: () {
                              VideoScreen.currentSpeed.value = 1.0;
                              _currentVideoIndex.value++;
                              initializeVidController(
                                  _listOfVideoDetails[_currentVideoIndex.value]
                                      .videoUrl,
                                  _listOfVideoDetails[_currentVideoIndex.value]
                                      .videoTitle,
                                  "",
                                  "",
                                  "");
                            },
                            child: Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    child: VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        backgroundColor: Color.fromARGB(74, 255, 255, 255),
                        bufferedColor: Color(0xFFC0AAF5),
                        playedColor: Color(0xFF7860DC),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          timeElapsedString(),
                          Text(
                            '/${_videoController!.value.duration.toString().substring(2, 7)}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            menuClicked = !menuClicked;
                          });
                          if (menuClicked) {
                            html.document.documentElement?.requestFullscreen();
                          } else {
                            html.document.exitFullscreen();
                            streamVideoData();
                          }
                        },
                        icon: Icon(
                          menuClicked
                              ? Icons.fullscreen_exit_rounded
                              : Icons.fullscreen_rounded,
                          color: Colors.white,
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
    );
  }

  Column _buildPartition(
      BuildContext context, double horizontalScale, double verticalScale) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.courseName!,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Medium",
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Center(
            child: Row(
              children: [
                SizedBox(width: 20),
                Expanded(child: _buildLecturesTab(context)),
                SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: _buildAssignmentTab(
                    context,
                    horizontalScale,
                    verticalScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildLecturesTab(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Lectures',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width * 0.2,
            color: Color(0xFF7860DC),
          )
        ],
      ),
    );
  }

  InkWell _buildAssignmentTab(
      BuildContext context, double horizontalScale, double verticalScale) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController!.pause();
          showAssignmentBottomSheet(
            context,
            horizontalScale,
            verticalScale,
          );
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Assignments',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.25,
              color: Color(0xFF7860DC),
            )
          ],
        ),
      ),
    );
  }

  String selectedSection = '';
  int? selectedIndexOfVideo;
  String? selectedVideoIndexName;
  String? videoTitle;
  List<dynamic> dataSetUrl = [];

  Color color = Colors.black;

  Future<void> getpathway(String? courseName) async {
    List path;
    String jsonString;
    var d;
    try {
      // print("1");
      await FirebaseFirestore.instance
          .collection('courses')
          .where("name", isEqualTo: "${courseName}")
          .get()
          .then((value) async => {
                // print("2"),
                path = await value.docs[0]['pathway'],
                // print("3"),
                for (var i in path)
                  {
                    // print("4"),
                    jsonString = jsonEncode(i),
                    // print("5"),
                    pathwaydata.add(jsonString),
                    // print("6"),
                  },
                // htmltext = pathwaydata[1]['data'],
                d = jsonDecode(pathwaydata[1]),
                htmltext = d['data'],
                // print("7"),
                // print("llll $htmltext")
              });
      // print("pathwaydata ${pathwaydata}");
    } catch (e) {
      // print("pathwaydata -- ${e}");
    }
    ;
  }

  int? dragSectionIndex, dragSubsectionIndex;
  int? subIndex, index;
  bool assignmentDrag = false;
  List<Map<String, dynamic>> listAssignment = [
    {
      "assign": [
        {"assignment": "assignment 1"}
      ],
      "index": 0
    },
    {
      "assign": [
        {"assignment": "assignment 1"}
      ],
      "index": 1
    },
  ];
  String? name, assignmentName;
  bool editModule = false;
  int? editIndex;
  int? editVideoIndex;
  TextEditingController moduleNameController = TextEditingController();
  // int? selectAssignment;
  // int? selectAssignmentSectionIndex;
  Widget _buildVideoDetails() {
    return StreamBuilder<Map<String, dynamic>?>(
        stream: Counter.counterStreamVideos,
        builder: (context, AsyncSnapshot snapshot) {
          print('dishss ${snapshot}');
          if (snapshot.hasData) {
            print("snapdata---------- ${snapshot.hasData}}");
            print('${widget.courseName}');
            var listOfSectionData;
            var id;

            listOfSectionData = snapshot.data["curriculum1"];
            id = snapshot.data["id"];
            print(widget.courseName);
            print(snapshot.data);
            try {
              listOfSectionData[widget.courseName].sort((a, b) {
                print("---========");
                // print(coursequiz.length);
                print(a["sr"]);
                if (a["sr"] > b["sr"]) {
                  return 1;
                }
                return -1;
              });
            } catch (e) {
              print('rooor $e ');
            }
            // print("listtttt ${listOfSectionData}");
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    List.generate(listOfSectionData[widget.courseName].length,
                        (sectionIndex) {
                  // var listOfDraggable = List<List>.generate(listOfSectionSort.length, (index) => []);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      sectionIndex == 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Column(
                                children: [
                                  pathwaydata.isEmpty ? Container() :
                                  Container(
                                    child: ExpansionTile(
                                      title: Text(
                                        'Important Instructions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: List.generate(
                                        pathwaydata.length,
                                        (index1) {
                                          Map valueMap =
                                              json.decode(pathwaydata[index1]);
                                          // print("ppppp ${valueMap}");
                                          return Column(
                                            children: [
                                              // videoPercentageList.length != 0 ?
                                              // Text(videoPercentageList[index][courseData.entries.elementAt(index).key][courseData.entries.elementAt(index).value[index1].videoTitle].toString()) : SizedBox(),
                                              GestureDetector(
                                                onTap: () {
                                                  print(valueMap['name']);
                                                  showAssignment = false;
                                                  setState(() {
                                                    currentPosition = 0;
                                                    videoTitle =
                                                        valueMap['name'];
                                                    totalDuration = 0;
                                                  });
                                                  if (valueMap['type'] ==
                                                      "video") {
                                                    setState(() {
                                                      htmlbool = false;
                                                      enablePauseScreen = false;
                                                    });

                                                    selectedIndexOfVideo =
                                                        index1;
                                                    VideoScreen.currentSpeed
                                                        .value = 1.0;

                                                    initializeVidController(
                                                        valueMap['data'],
                                                        valueMap['name'],
                                                        "",
                                                        "",
                                                        "");
                                                  } else {
                                                    setState(() {
                                                      htmltext =
                                                          valueMap['data'];
                                                      enablePauseScreen = false;
                                                      htmlbool = true;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 60,
                                                      top: 15,
                                                      bottom: 15),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      valueMap['name'],
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      // SizedBox(),
                      Text(
                        " ",
                        style: TextStyle(fontSize: 0.5),
                      ),
                      Container(
                        child: ExpansionTile(
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: editModule && sectionIndex == editIndex
                                      ? Container(
                                          child: TextField(
                                            controller: moduleNameController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter updated module name',
                                                suffix: IconButton(
                                                    onPressed: () {
                                                      // print('hey ${moduleNameController.text}');
                                                      // print('sectionIndex is $editIndex');
                                                      listOfSectionData[widget
                                                                      .courseName]
                                                                  [editIndex]
                                                              ['modulename'] =
                                                          moduleNameController
                                                              .text;

                                                      try {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'courses')
                                                            .doc(widget.cID)
                                                            .update({
                                                          'curriculum1': {
                                                            '${widget.courseName}':
                                                                listOfSectionData[
                                                                    widget
                                                                        .courseName],
                                                          }
                                                        }).whenComplete(() =>
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'Module name updated successfully.'));
                                                      } catch (e) {
                                                        print(e.toString());
                                                      }
                                                      setState(() {
                                                        editModule = false;
                                                        moduleNameController
                                                            .clear();
                                                        streamVideoData();
                                                      });
                                                      print(
                                                          'hello ${moduleNameController.text}');
                                                      // sectionIndex = sectionIndex;
                                                    },
                                                    icon: Icon(Icons.update))),
                                          ),
                                        )
                                      : Text(
                                          listOfSectionData[widget.courseName]
                                                  [sectionIndex]["modulename"]
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                role == 'mentor'
                                    ? PopupMenuButton<int>(
                                        onSelected: (item) {
                                          if (item == 0) {
                                            setState(() {
                                              editIndex = sectionIndex;
                                            });
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      height: 450,
                                                      width: 350,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'Enter video name'),
                                                            controller:
                                                                addVideoName,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'Enter video url'),
                                                            controller:
                                                                addVideoUrl,
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                        Random number = Random();
                                                                        int min = 1;
                                                                        int max = 1000;
                                                                        int randomNumber = min + number.nextInt(max - min);
                                                                        print("$randomNumber is in the range of $min and $max");

                                                                    print('dipen Pau');
                                                                    print('$id' +
                                                                        '${listOfSectionData[widget.courseName][editIndex].length}' +
                                                                        '${listOfSectionData[widget.courseName][editIndex]['videos'].length}');

                                                                    if (addVideoName
                                                                            .text
                                                                            .isNotEmpty &&
                                                                        addVideoUrl
                                                                            .text
                                                                            .isNotEmpty) {
                                                                      listOfSectionData[widget.courseName][editIndex]
                                                                              [
                                                                              'videos']
                                                                          .add({
                                                                        'name':
                                                                            addVideoName.text,
                                                                        'id': '$id' +
                                                                            'V' +
                                                                            '${listOfSectionData[widget.courseName][editIndex].length}' +
                                                                            '$randomNumber',
                                                                        'weburl': addVideoUrl.text,
                                                                        'url': '',
                                                                        'type': 'video',
                                                                        'offline': false,
                                                                        'demo': false,
                                                                        'sr': listOfSectionData[widget.courseName][editIndex]['videos'].length,
                                                                      });
                                                                      try {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'courses')
                                                                            .doc(widget
                                                                                .cID)
                                                                            .update({
                                                                          'curriculum1':
                                                                              {
                                                                            widget.courseName:
                                                                                listOfSectionData[widget.courseName],
                                                                          }
                                                                        }).whenComplete(() =>
                                                                                Fluttertoast.showToast(msg: 'New video added'));
                                                                      } catch (e) {
                                                                        print(e
                                                                            .toString());
                                                                      }
                                                                    }
                                                                    print(
                                                                        'added new video name ${addVideoName.text}');

                                                                    setState(
                                                                        () {
                                                                      addVideoId
                                                                          .clear();
                                                                      addVideoUrl
                                                                          .clear();
                                                                      addVideoName
                                                                          .clear();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      getProgressData();
                                                                      streamVideoData();
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Submit')),
                                                              SizedBox(
                                                                  width: 20),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Close'))
                                                            ],
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }

                                          if (item == 1) {
                                            print('roless $role');
                                            setState(() {
                                              editModule = true;
                                              editIndex = sectionIndex;
                                            });
                                            print('sectionIndex is $editIndex');
                                          }
                                          if (item == 2) {
                                            setState(() {
                                              editIndex = sectionIndex;
                                            });

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return addAssigmentPopUp(
                                                    listOfSectionData:
                                                        listOfSectionData);
                                              },
                                            );
                                          }

                                        },
                                        itemBuilder: (context) => [
                                              PopupMenuItem<int>(
                                                  value: 0,
                                                  child:
                                                      Text('Add a new video')),
                                              PopupMenuItem<int>(
                                                  value: 1,
                                                  child:
                                                      Text('Edit module name')),
                                                       PopupMenuItem<int>(
                                                  value: 2,
                                                  child: Text('Add Assignment'))
                                            ])
                                    : SizedBox(),
                              ],
                            ),
                            children: List.generate(
                                listOfSectionData[widget.courseName]
                                        [sectionIndex]["videos"]
                                    .length, (subsectionIndex) {
                              listOfSectionData[widget.courseName][sectionIndex]
                                      ["videos"]
                                  .sort((a, b) {
                                // print("a=====${a["sr"]}");
                                if (a["sr"] > b["sr"]) {
                                  return 1;
                                }
                                return -1;
                              });

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (subIndex != null &&
                                      subIndex == subsectionIndex &&
                                      index == sectionIndex)
                                    Draggable(
                                      data: 0,
                                      child: Container(
                                        color: Colors.purpleAccent,
                                        child: GestureDetector(
                                            onTap: () {
                                              print(
                                                  'vdo = $videoPercentageList');
                                              htmlbool = false;
                                              showAssignment = false;
                                              if (listOfSectionData[widget
                                                                  .courseName]
                                                              [sectionIndex]
                                                          ["videos"][
                                                      subsectionIndex]["type"] ==
                                                  "video") {
                                                setState(() {
                                                  currentPosition = 0;
                                                  videoTitle = listOfSectionData[
                                                                      widget
                                                                          .courseName]
                                                                  [sectionIndex]
                                                              ["videos"][
                                                          subsectionIndex]["name"]
                                                      .toString();
                                                  totalDuration = 0;
                                                });

                                                VideoScreen.currentSpeed.value =
                                                    1.0;
                                                initializeVidController(
                                                    listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                [subsectionIndex]
                                                            ["url"]
                                                        .toString(),
                                                    listOfSectionData[widget.courseName][sectionIndex]
                                                                ["videos"][subsectionIndex]
                                                            ["name"]
                                                        .toString(),
                                                    listOfSectionData[widget.courseName]
                                                                [sectionIndex]
                                                            ["modulename"]
                                                        .toString(),
                                                    listOfSectionData[widget.courseName]
                                                            [sectionIndex]["id"]
                                                        .toString(),
                                                    listOfSectionData[widget.courseName]
                                                                [sectionIndex]["videos"]
                                                            [subsectionIndex]["id"]
                                                        .toString());
                                              } else if (listOfSectionData[widget
                                                                  .courseName]
                                                              [sectionIndex]
                                                          ["videos"][
                                                      subsectionIndex]["type"] ==
                                                  "quiz") {
                                                //QuizentrypageWidget
                                                print(
                                                    "sdjfosjdfoisjdofjsodifjsoijdfoisdfsodfiosjiofdjosdjfoisidfjiowjofowejojiojbdf");
                                                //  GoRouter.of(context).pushNamed('quizpage');
                                                setState(() {
                                                  quizdata = listOfSectionData[
                                                              widget.courseName]
                                                          [sectionIndex][
                                                      "videos"][subsectionIndex];
                                                  quizbool = true;
                                                  print("iwoe");
                                                  htmlbool = true;
                                                });
                                              } else {
                                                showAssignment = true;
                                                setState(() {
                                                  assignmentUrl = listOfSectionData[
                                                                      widget
                                                                          .courseName]
                                                                  [sectionIndex]
                                                              ["videos"][
                                                          subsectionIndex]["url"]
                                                      .toString();

                                                  assignmentName = listOfSectionData[
                                                                      widget
                                                                          .courseName]
                                                                  [sectionIndex]
                                                              ["videos"][
                                                          subsectionIndex]["name"]
                                                      .toString();
                                                  print(assignmentName);
                                                  solutionUrl = listOfSectionData[
                                                                      widget
                                                                          .courseName]
                                                                  [sectionIndex]
                                                              ["videos"][
                                                          subsectionIndex]["pdf"]
                                                      .toString();
                                                  dataSetUrl = listOfSectionData[
                                                              widget.courseName]
                                                          [
                                                          sectionIndex]["videos"]
                                                      [
                                                      subsectionIndex]["dataset"];
                                                });
                                                print("Eagle");
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 60,
                                                    top: 15,
                                                    bottom: 15),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      listOfSectionData[widget.courseName]
                                                                              [sectionIndex]
                                                                          ["videos"]
                                                                      [subsectionIndex]
                                                                  ["type"] ==
                                                              "video"
                                                          ? Icon(
                                                              Icons.play_circle)
                                                          : listOfSectionData[widget.courseName]
                                                                              [sectionIndex]
                                                                          [
                                                                          "videos"][subsectionIndex]
                                                                      [
                                                                      "type"] ==
                                                                  "quiz"
                                                              ? Icon(Icons.quiz)
                                                              : Icon(Icons
                                                                  .assessment),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        listOfSectionData[widget.courseName][sectionIndex]
                                                                            ["videos"]
                                                                        [subsectionIndex]
                                                                    ["type"] ==
                                                                "video"
                                                            ? listOfSectionData[widget.courseName]
                                                                            [sectionIndex]
                                                                        ["videos"][subsectionIndex]
                                                                    ["name"]
                                                                .toString()
                                                            : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] ==
                                                                    "quiz"
                                                                ? "Quiz : " +
                                                                    listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"]
                                                                        .toString()
                                                                : "Assignment : " +
                                                                    listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]
                                                                            ["name"]
                                                                        .toString(),
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ))
                                                    ],
                                                  ),
                                                ))),
                                      ),
                                      feedback: SizedBox(
                                        height: 50,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 60, top: 15, bottom: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  listOfSectionData[widget.courseName]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "videos"]
                                                                  [subIndex]
                                                              ["type"] ==
                                                          "video"
                                                      ? Icon(Icons.play_circle)
                                                      : Icon(Icons.assessment),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  DefaultTextStyle(
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    child:
                                                        // Expanded(
                                                        //   child:
                                                        Text(
                                                      listOfSectionData[widget.courseName][index]["videos"]
                                                                      [subIndex]
                                                                  ["type"] ==
                                                              "video"
                                                          ? listOfSectionData[widget.courseName][index]
                                                                          ["videos"]
                                                                      [subIndex]
                                                                  ["name"]
                                                              .toString()
                                                          : listOfSectionData[widget.courseName][index]["videos"][subIndex]["type"] ==
                                                                  "quiz"
                                                              ? "Quiz : " +
                                                                  listOfSectionData[widget.courseName][index]["videos"][subIndex]["name"]
                                                                      .toString()
                                                              : "Assignment : " +
                                                                  listOfSectionData[widget.courseName][index]["videos"][subIndex]
                                                                          ["name"]
                                                                      .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    // )
                                                  )
                                                ],
                                              ),
                                            )),
                                        // width: 50,
                                        // height: 50,
                                      ),
                                    )
                                  else
                                    DragTarget<int>(
                                      builder: (context, _, __) =>
                                          GestureDetector(
                                              onDoubleTap: () {
                                                print("doubletap");
                                                if (role != null) {
                                                  if (role == "mentor") {
                                                    setState(() {
                                                      // selectAssignment = null;
                                                      subIndex =
                                                          subsectionIndex;
                                                      index = sectionIndex;
                                                    });
                                                  }
                                                }
                                                print(subsectionIndex);
                                              },
                                              onTap: () {
                                                _videoController!.pause();
                                                setState(() {
                                                  currentPlayingVideoName =
                                                      listOfSectionData[widget
                                                                          .courseName]
                                                                      [
                                                                      sectionIndex]
                                                                  ["videos"][
                                                              subsectionIndex]["name"]
                                                          .toString();
                                                });
                                                if (listOfSectionData[widget
                                                                    .courseName]
                                                                [sectionIndex]
                                                            ["videos"][
                                                        subsectionIndex]["type"] ==
                                                    "video") {
                                                  print(
                                                      'vdo = $videoPercentageList');
                                                  htmlbool = false;
                                                  showAssignment = false;
                                                  submitResume=false;
                                                  setState(() {
                                                    currentPosition = 0;
                                                    videoTitle = listOfSectionData[
                                                                        widget
                                                                            .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                ["videos"][
                                                            subsectionIndex]["name"]
                                                        .toString();
                                                    totalDuration = 0;
                                                  });

                                                  VideoScreen
                                                      .currentSpeed.value = 1.0;

                                                  initializeVidController(
                                                      listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                  [subsectionIndex]
                                                              ["url"]
                                                          .toString(),
                                                      listOfSectionData[widget.courseName]
                                                                      [sectionIndex]["videos"]
                                                                  [subsectionIndex]
                                                              ["name"]
                                                          .toString(),
                                                      listOfSectionData[widget.courseName]
                                                                  [sectionIndex]
                                                              ["modulename"]
                                                          .toString(),
                                                      listOfSectionData[widget.courseName]
                                                                  [sectionIndex]
                                                              ["id"]
                                                          .toString(),
                                                      listOfSectionData[widget.courseName]
                                                                  [sectionIndex]["videos"]
                                                              [subsectionIndex]["id"]
                                                          .toString());
                                                }
                                                else if (listOfSectionData[widget
                                                                    .courseName]
                                                                [sectionIndex]
                                                            ["videos"][
                                                        subsectionIndex]["type"] ==
                                                    "quiz") {
                                                  print(
                                                      "ll;;;;;;;;;;;;;;;;;;;");
                                                      submitResume=false;
                                                  setState(() {
                                                    quizdata = listOfSectionData[
                                                                widget
                                                                    .courseName]
                                                            [sectionIndex][
                                                        "videos"][subsectionIndex];
                                                    htmlbool = true;
                                                    quizbool = true;
                                                  });
                                                } else if (listOfSectionData[widget
                                                                    .courseName]
                                                                [sectionIndex]
                                                            ["videos"][
                                                        subsectionIndex]["type"] ==
                                                    "resume") {
                                                  setState(() {
                                                    quizbool = false;
                                                    !submitResume
                                                        ? submitResume = true
                                                        : null;
                                                  });
                                                } else {
                                                  submitResume=false;
                                                  showAssignment = true;
                                                  
                                                  setState(() {
                                                    assignmentUrl = listOfSectionData[
                                                                        widget
                                                                            .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                ["videos"][
                                                            subsectionIndex]["url"]
                                                        .toString();
                                                    assignmentName = listOfSectionData[
                                                                        widget
                                                                            .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                ["videos"][
                                                            subsectionIndex]["name"]
                                                        .toString();
                                                    solutionUrl = listOfSectionData[
                                                                        widget
                                                                            .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                ["videos"][
                                                            subsectionIndex]["pdf"]
                                                        .toString();
                                                    dataSetUrl = listOfSectionData[widget.courseName]
                                                                            [sectionIndex]
                                                                        ["videos"]
                                                                    [subsectionIndex]
                                                                ["dataset"] !=
                                                            null
                                                        ? listOfSectionData[widget
                                                                        .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                ["videos"][
                                                            subsectionIndex]["dataset"]
                                                        : [];
                                                  });
                                                  print("Eagle");
                                                }
                                              },
                                              child: Container(
                                                  color: currentPlayingVideoName ==
                                                          listOfSectionData[widget.courseName]
                                                                              [sectionIndex]
                                                                          ["videos"]
                                                                      [subsectionIndex]
                                                                  ["name"]
                                                              .toString()
                                                      ? HexColor("#fbedfc")
                                                      : Colors.white,
                                                  //     Colors.red,

                                                  padding: EdgeInsets.only(
                                                      left: listOfSectionData[widget.courseName]
                                                                          [sectionIndex]
                                                                      ["videos"]
                                                                  [subsectionIndex]["type"] ==
                                                              "video"
                                                          ? 60
                                                          : 60,
                                                      top: 15,
                                                      bottom: 15),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        listOfSectionData[widget.courseName][sectionIndex]
                                                                            [
                                                                            "videos"]
                                                                        [
                                                                        subsectionIndex]
                                                                    ["type"] ==
                                                                "video"
                                                            ? Icon(
                                                                Icons
                                                                    .play_circle,
                                                                color:
                                                                    Colors.black
                                                                // :null,
                                                                )
                                                            :listOfSectionData[widget.courseName]
                                                                            [sectionIndex]["videos"][subsectionIndex][
                                                                        "type"] ==
                                                                    "resume"
                                                                ? Icon(Icons
                                                                    .reviews)
                                                                : Icon(
                                                                Icons
                                                                    .assessment,
                                                                color: Colors
                                                                    .purple
                                                                // :null,
                                                                ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        _getVideoPercentageList !=
                                                                    null &&
                                                                CourseID != null
                                                            ? listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                            [
                                                                            subsectionIndex]
                                                                        [
                                                                        "type"] ==
                                                                    "video"
                                                                ? Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: List.generate(
                                                                          _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()]
                                                                              .length,
                                                                          (index) {
                                                                        if (_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()][index][listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"].toString()] !=
                                                                            null) {
                                                                          return updateVideoName && updateVideoIndex == subsectionIndex
                                                                              ? TextField(
                                                                                  controller: updateVideoNameController,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: '${listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"]}',
                                                                                      suffix: IconButton(
                                                                                        onPressed: () {
                                                                                          listOfSectionData[widget.courseName][editIndex]['videos'][updateVideoIndex]['name'] = updateVideoNameController.text;
                                                                                          try {
                                                                                            FirebaseFirestore.instance.collection('courses').doc(widget.cID).update({
                                                                                              'curriculum1': {
                                                                                                widget.courseName: listOfSectionData[widget.courseName],
                                                                                              }
                                                                                            });
                                                                                          } catch (e) {
                                                                                            print(e.toString());
                                                                                          }

                                                                                          setState(() {
                                                                                            streamVideoData();
                                                                                            updateVideoNameController.clear();
                                                                                            updateVideoName = false;
                                                                                          });
                                                                                        },
                                                                                        icon: Icon(Icons.update_outlined),
                                                                                      )),
                                                                                )
                                                                              : Text(
                                                                                  listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] == "video"
                                                                                      ? listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString()
                                                                                      : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] == "quiz"
                                                                                          ? "Quiz : " + listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString()
                                                                                          :listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] == "resume"
                                                                                              ? '': "Assignment : " + listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString(),
                                                                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()][index][listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"].toString()] == 100 ? Colors.green : Colors.black),
                                                                                );
                                                                        } else {
                                                                          return SizedBox();
                                                                        }
                                                                      }),
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),
                                                        listOfSectionData[widget.courseName]
                                                                            [
                                                                            sectionIndex]
                                                                        [
                                                                        "videos"]
                                                                    [
                                                                    subsectionIndex]["type"] !=
                                                                "video"
                                                            ? Expanded(
                                                                child: Text(
                                                                  listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]
                                                                              [
                                                                              "type"] ==
                                                                          "video"
                                                                      ? ''
                                                                      : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] ==
                                                                              "quiz"
                                                                          ? "Quiz : " +
                                                                              listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"]
                                                                                  .toString()
                                                                          : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] == "resume"
                                                                                              ? listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString():
                                                                  "Assignment : " +
                                                                              listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString(),
                                                                            
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: Colors
                                                                          .purple
                                                                      // :null
                                                                      ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        _getVideoPercentageList !=
                                                                null
                                                            ? listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                            [
                                                                            subsectionIndex]
                                                                        [
                                                                        "type"] ==
                                                                    "video"
                                                                ? Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: List.generate(
                                                                        _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()]
                                                                            .length,
                                                                        (index) {
                                                                      if (_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()][index]
                                                                              [
                                                                              listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"].toString()] !=
                                                                          null) {
                                                                        return Text(
                                                                          _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()][index][listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"].toString()].toString() +
                                                                              "%",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                              color: _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["id"].toString()][index][listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"].toString()] == 100 ? Colors.green : Colors.black),
                                                                        );
                                                                        // ,
                                                                        // );
                                                                      } else {
                                                                        return SizedBox();
                                                                      }
                                                                    }),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        role == 'mentor' &&
                                                                listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                            [
                                                                            subsectionIndex]
                                                                        [
                                                                        "type"] ==
                                                                    "video"
                                                            ? PopupMenuButton<int>(
                                                                onSelected:
                                                                    (item) {
                                                                  if (item ==
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      updateVideoNameController
                                                                          .text = listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                                              [
                                                                              subsectionIndex]
                                                                          [
                                                                          "name"];
                                                                      updateVideoName =
                                                                          true;
                                                                      editIndex =
                                                                          sectionIndex;
                                                                      updateVideoIndex =
                                                                          subsectionIndex;
                                                                    });
                                                                  }
                                                                  if (item ==
                                                                      2) {
                                                                    setState(
                                                                        () {
                                                                      updateVideoName =
                                                                          false;
                                                                      editIndex = sectionIndex;
                                                                      deleteVideoIndex = subsectionIndex;
                                                                    });
                                                                    listOfSectionData[widget.courseName][editIndex]
                                                                            [
                                                                            'videos']
                                                                        .removeAt(
                                                                            deleteVideoIndex);

                                                                    try {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'courses')
                                                                          .doc(widget
                                                                              .cID)
                                                                          .update({
                                                                        'curriculum1':
                                                                            {
                                                                          widget.courseName:
                                                                              listOfSectionData[widget.courseName],
                                                                        }
                                                                      }).whenComplete(() =>
                                                                              Fluttertoast.showToast(msg: 'Video deleted'));

                                                                      streamVideoData();
                                                                    } catch (e) {
                                                                      print(e
                                                                          .toString());
                                                                    }
                                                                  }
                                                                  if (item ==
                                                                      3) {
                                                                    setState(
                                                                        () {
                                                                      updateVideoIndex =
                                                                          subsectionIndex;
                                                                      editIndex =
                                                                          sectionIndex;
                                                                      updateVideoName =
                                                                          false;
                                                                    });
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            content:
                                                                                Container(
                                                                              height: 250,
                                                                              width: 350,
                                                                              child: Column(
                                                                                children: [
                                                                                  TextField(
                                                                                    controller: updateVideoUrl,
                                                                                    decoration: InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      hintText: 'Enter updated video URL',
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 20,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      ElevatedButton(
                                                                                          onPressed: () {
                                                                                            if (updateVideoUrl.text.isNotEmpty) {
                                                                                              listOfSectionData[widget.courseName][editIndex]['videos'][updateVideoIndex]['url'] = updateVideoUrl.text;
                                                                                              try {
                                                                                                FirebaseFirestore.instance.collection('courses').doc(widget.cID).update({
                                                                                                  'curriculum1': {
                                                                                                    widget.courseName: listOfSectionData[widget.courseName],
                                                                                                  }
                                                                                                }).whenComplete(() => Fluttertoast.showToast(msg: 'Video URL updated.'));
                                                                                              } catch (e) {
                                                                                                print(e.toString());
                                                                                              }
                                                                                              setState(() {
                                                                                                updateVideoUrl.clear();
                                                                                                Navigator.of(context).pop();
                                                                                                streamVideoData();
                                                                                              });
                                                                                            } else {
                                                                                              Fluttertoast.showToast(msg: 'Please enter URL');
                                                                                            }
                                                                                          },
                                                                                          child: Text('Submit')),
                                                                                      SizedBox(width: 20),
                                                                                      ElevatedButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: Text('Close'),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                                  }
                                                                },
                                                                itemBuilder:
                                                                    (context) =>
                                                                        [
                                                                          PopupMenuItem<int>(
                                                                              value: 1,
                                                                              child: Text('Edit video name')),
                                                                          PopupMenuItem<int>(
                                                                              value: 2,
                                                                              child: Text('Delete video')),
                                                                          PopupMenuItem<int>(
                                                                              value: 3,
                                                                              child: Text('Update video URL')),
                                                                        ])
                                                            : SizedBox(),
                                                        role == 'mentor' &&
                                                            listOfSectionData[widget.courseName][sectionIndex]["videos"]
                                                            [
                                                            subsectionIndex]
                                                            [
                                                            "type"] ==
                                                                "assignment" ? PopupMenuButton<
                                                            int>(
                                                          onSelected: (item) {
                                                            if (item == 1) {
                                                              setState(
                                                                      () {
                                                                    updateVideoName = false;
                                                                    editIndex = sectionIndex;
                                                                    deleteVideoIndex = subsectionIndex;
                                                                  });
                                                              listOfSectionData[widget.courseName][editIndex]
                                                              ['videos'].removeAt(deleteVideoIndex);

                                                              try {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    'courses')
                                                                    .doc(widget
                                                                    .cID)
                                                                    .update({
                                                                  'curriculum1':
                                                                  {
                                                                    widget.courseName:
                                                                    listOfSectionData[widget.courseName],
                                                                  }
                                                                }).whenComplete(() =>
                                                                    Fluttertoast.showToast(msg: 'Assignment deleted'));

                                                                streamVideoData();
                                                              } catch (e) {
                                                                print(e
                                                                    .toString());
                                                              }
                                                            }
                                                          },
                                                          itemBuilder: (context) =>
                                                          [
                                                            PopupMenuItem<int>(
                                                                value: 1,
                                                                child: Text('Delete assignment')),
                                                          ],
                                                        ): SizedBox(),
                                                      ],
                                                    ),
                                                  ))),
                                      onAccept: (data) async {
                                        print("data---------");
                                        // print(data);
                                        print("selected sectionIndex=${index}");
                                        print(
                                            "selected subsectionIndex = ${subIndex}");
                                        print(
                                            "subsectionIndex = ${subsectionIndex}");
                                        print("section index= ${sectionIndex}");
                                        print(subsectionIndex);
                                        int count = 0;
                                        if (subIndex != null &&
                                            index != null &&
                                            index == sectionIndex) {
                                          if (subIndex! < subsectionIndex) {
                                            print(true);
                                            for (int i = 0;
                                                i <= subsectionIndex;
                                                i++) {
                                              print("count===");
                                              if (i == subIndex) {
                                                listOfSectionData[widget
                                                                .courseName]
                                                            [sectionIndex]
                                                        ["videos"][i]
                                                    ["sr"] = listOfSectionData[
                                                            widget.courseName]
                                                        [sectionIndex]["videos"]
                                                    [subsectionIndex]["sr"];
                                                continue;
                                              }
                                              print("count===${count}");
                                              listOfSectionData[widget
                                                      .courseName][sectionIndex]
                                                  ["videos"][i]["sr"] = count;
                                              count++;
                                            }
                                          } else {
                                            print(false);
                                            count = 0;

                                            ///
                                            for (int j = subsectionIndex;
                                                j <= subIndex!;
                                                j++) {
                                              // print("count===${count}");
                                              print("j======${j}");
                                              if (j == subIndex) {
                                                listOfSectionData[
                                                            widget.courseName]
                                                        [sectionIndex]["videos"]
                                                    [j]["sr"] = subsectionIndex;
                                                print(
                                                    "a = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                                              } else {
                                                listOfSectionData[
                                                            widget.courseName]
                                                        [sectionIndex]["videos"]
                                                    [j]["sr"] = j + 1;
                                                print(
                                                    "b = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                                              }
                                            }
                                          }
                                          await FirebaseFirestore.instance
                                              .collection("courses")
                                              .doc(widget.cID)
                                              .update({
                                            "curriculum1": listOfSectionData
                                          });
                                          setState(() {
                                            listOfSectionData;
                                            subIndex = null;
                                            index = null;
                                          });
                                        }
                                      },
                                    ),
                                ],
                              );
                            })),
                      ),

                      _switchValue?sectionIndex ==
                              listOfSectionData[widget.courseName].length - 1
                          ? coursequiz.runtimeType != Null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        child: ExpansionTile(
                                          title: Text(
                                            'Quizes',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          children: List.generate(
                                            coursequiz.length,
                                            (index1) {
                                              // print("ppppp ${valueMap}");
                                              return Column(
                                                children: [
                                                  // videoPercentageList.length != 0 ?
                                                  // Text(videoPercentageList[index][courseData.entries.elementAt(index).key][courseData.entries.elementAt(index).value[index1].videoTitle].toString()) : SizedBox(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        quizdata = coursequiz[index1];
                                                        quizbool = true;
                                                        htmlbool = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 60,
                                                          top: 15,
                                                          bottom: 15),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          coursequiz[index1]
                                                              ['name'],
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                          : Container():Container()
                    ],
                  );
                }),
              ),
            );
          } else {
            return Text("Loading...");
          }
        });
  }

  TextEditingController addVideoName = TextEditingController();
  TextEditingController addVideoId = TextEditingController();
  TextEditingController addVideoUrl = TextEditingController();
  TextEditingController updateVideoUrl = TextEditingController();
  bool updateVideoName = false;
  int? updateVideoIndex;
  int? deleteVideoIndex;
  String? initialVideoName;
  TextEditingController updateVideoNameController = TextEditingController();
}

class Counter {
  static final _stateStreamControllerVideos =
      StreamController<Map<String, dynamic>?>.broadcast();
  static StreamSink<Map<String, dynamic>?> get counterSinkVideos =>
      _stateStreamControllerVideos.sink;
  static Stream<Map<String, dynamic>?> get counterStreamVideos =>
      _stateStreamControllerVideos.stream;
}

class replay10 extends StatelessWidget {
  const replay10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! - Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.replay_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fastForward10 extends StatelessWidget {
  const fastForward10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! + Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.forward_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
