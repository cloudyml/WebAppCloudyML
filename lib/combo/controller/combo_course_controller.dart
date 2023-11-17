import 'dart:developer';
import 'dart:html';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../global_variable.dart';
import '../../widgets/review_dialog/take_review.dart';
import '../new_combo_course.dart';

class ComboCourseController extends GetxController {
  final String? courseId;
  ComboCourseController({required this.courseId});


  reviewAlert() {
    // showDialog(
    //     context: context,
    //     builder: (context){
    //       double screenWidth = MediaQuery.of(context).size.width;
    //       double screenHeight = MediaQuery.of(context).size.height;
    //
    //       // Define breakpoints for different screen sizes
    //       final isPhone =
    //           screenWidth < 600;
    //       return Padding(
    //         padding: EdgeInsets.only(
    //             left: isPhone ? 20.sp : 50.sp,
    //             right: isPhone ? 20.sp : 50.sp,
    //             top: isPhone ? 50.sp : 20.sp,
    //             bottom: isPhone ? 50.sp : 20.sp),
    //         child: Material(
    //             child: Center(
    //               child: isPhone ? Container(
    //                 child: MobileReviewDialog(),
    //               ) : ShowReviewDialog(),
    //             )),
    //       );
    //     });


    BotToast.showWidget(toastBuilder: (value){
      double screenWidth = WidgetsBinding.instance.window.physicalSize.width;
      final isPhone = screenWidth < 600;
      return Center(
        child: Container(
          height: isPhone ? 0.75.sh : 600,
          width: isPhone ? 0.7.sw : 500,
          child: Center(
            child: Material(
                child: Center(
                  child: isPhone ? MobileReviewDialog() : ShowReviewDialog(),
                )),
          ),
        ),
      );
    });
  }


  RxInt coursePerc = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // reviewAlert();
    getCourseIds().whenComplete(() {
      print('CCCC: : ${courses}');
      checkCourseExist();
      getCourses();
      getPercentageOfCourse();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }


  var courseList = [].obs;
  var courseData = {}.obs;
  var tmp = [].obs;
  var oldModuleProgress = false.obs;

  var courses = [].obs;

  var paidCourse = [].obs;

//var isLoading = true.obs;

  Future getCourseIds() async {
    await FirebaseFirestore.instance
        .collection("courses")
        .where('id', isEqualTo: courseId)
        .get()
        .then((value) {
      courses.value = value.docs.first.get('courses');
    });
  }

  getCourses() async {
    await {
      courses.forEach((element) {
        Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
            .instance
            .collection("courses")
            .where('id', isEqualTo: element)
            .get();
        data.then((value) async {
          courseList.add(value.docs.first.data());
          courseList.sort((a, b) =>
              courses.indexOf(a["id"]).compareTo(courses.indexOf(b["id"])));
        });
      })
    };
    // isLoading.value = false;
  }




 checkCourseExist() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      List temPaid = value.get('paidCourseNames');
      print(' MULTII :: $mainCourseId');
      await FirebaseFirestore.instance
          .collection("courses")
          .where('id', isEqualTo: mainCourseId)
          .get()
          .then((value) {
        if (value.docs[0].data()['multiCombo'] != null) {
          if (value.docs[0].data()['multiCombo']) {
            paidCourse.value = value.docs[0].data()['courses'];

            print(' Paid  :: ${value.docs[0].data()['courses']}');
          }
         
        } else {
          paidCourse.value = temPaid;
          print(' Paid :: ${courseId}');
        }
      });
    });
  }

  Future getPercentageOfCourse() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("courseprogress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      courseData.value = data.data() as Map;
      for(var j in courseData.keys) {
        for(var i in courseList){
          if(j == i["id"]){
            if(courseData[i["id"] + "percentage"] != null && courseData[i["id"] + "percentage"] > 10){
              print("coursewise = ${courseData[i["id"] + "percentage"]}");
              if(coursePerc.value < courseData[i["id"] + "percentage"]){
                coursePerc.value = courseData[i["id"] + "percentage"];
                print("object ${coursePerc.value}");
              }
            }
          }

        }
      }
// isLoading.value = false;
    } catch (e) {
      // isLoading.value = false;
      print('the progress exception is$e');
    }
  }
}

class ComboModuleController extends GetxController {
  var courseId;
  ComboModuleController({required this.courseId});

  @override
  void onInit() {
    getCourseIds().whenComplete(() {
      print('CCCC: : ${courses}');
      getCourses();
      getPercentageOfCourse();
    });

    super.onInit();
  }

  var courseList = [].obs;
  var courseData = {}.obs;
  var tmp = [].obs;
  var oldModuleProgress = false.obs;

  var courses = [].obs;
  var collect = [];

  List<dynamic> removeDuplicates(List<dynamic> inputList) {
    List<dynamic> uniqueList = [];

    for (dynamic number in inputList) {
      if (!uniqueList.contains(number)) {
        uniqueList.add(number);
      }
    }

    return uniqueList;
  }

  Future getCourseIds() async {
    for (var i in courseId) {
      await FirebaseFirestore.instance
          .collection("courses")
          .where('id', isEqualTo: i['id'])
          .get()
          .then((value) {
        collect.add(value.docs.first.get('courses'));
        print("fwoeifo :${collect}");
      });
    }
    // courses.value = collect[0];
    for (var k in collect) {
      courses.value = courses.value + k;
    }
    print("iwoej ${courses}");
    courses.value = removeDuplicates(courses.value);
  }

  getCourses() async {
    await {
      courses.forEach((element) {
        try {
          print("start wewe --");
          Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
              .instance
              .collection("courses")
              .where('id', isEqualTo: element)
              .get();
          data.then((value) {
            try {
              print('vewewe $element');
              courseList.add(value.docs.first.data());
              print("`1 ${courseList.length}");
              courseList.sort((a, b) =>
                  courses.indexOf(a["id"]).compareTo(courses.indexOf(b["id"])));
            } catch (e) {
              print("error wewe2: ${e}");
            }
          });
          print("end wewe --");
          for (var j in courseList) {
            print("wewe--");
            print(j['name']);
          }
        } catch (e) {
          print("pppppp: ${e}");
        }
      })
    };
  }

 Future getPercentageOfCourse() async {
    print('getPercentageOfCourse');
    try {
      var data = await FirebaseFirestore.instance
          .collection("courseprogress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      courseData.value = data.data() as Map;
      print("courseData Value = ${courseData}");
    } catch (e) {
      print('the progress exception is$e');
    }
  }
}
