import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class AddController extends GetxController{
  final selectedStates = [].obs;
  final courseNames = [].obs;
  final courseIds = [].obs;
  final isItCombo = false.obs;
  final chooseCourses = false.obs;

  checkIfCombo(bool combo) {
    isItCombo(combo);
  }

  getCoursesIds() async {
    print('getCoursesIds');
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('courses').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Check if the document contains the 'name' field
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('name')) {
          String courseName = documentSnapshot['name'];
          courseNames.value.add(courseName);
        }

        if (data != null && data.containsKey('id')) {
          String courseId = documentSnapshot['id'];
          courseIds.value.add(courseId);
        }

      }
      print('courseNames.value ${courseNames.value}');
      print('courseIds.value ${courseIds.value}');
    }catch(e){
      print('Error getting courses getCourses(): $e');
    }
  }


getBools(courseNames) {
  selectedStates.assignAll(List.generate(courseNames.length, (index) => false));
}

  toggleCheckbox(int index) {
    selectedStates[index] = !selectedStates[index];
    update();
  }


  coursesListForComboCourse(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context){
      return AlertDialog(
        content: SingleChildScrollView(child: Column(
          children: [Text("Select Courses"),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("courses").snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                return Column(
                  children: List.generate(10, (index) {
                return Text("Course ${snapshot.data!["id"]}");
          }),);
              }
            )],
        )),
      );
    });
  }

}