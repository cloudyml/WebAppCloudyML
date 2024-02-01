import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddCourseInUserController extends GetxController{

  String selectedItem = 'Email';
  List<TempCourseModel> courses = [];
  bool isLoading = true;
  TextEditingController emailController = TextEditingController();
    TextEditingController mobileController = TextEditingController();

  String selectedCourseName = '';
  String selectedCourseImage = '';
  String selectedCourseId = '';

  String studentName = '';
  String studentId = '';
  var studentData;
  List studentCoursesById = [];



  changeLoading(bool value) {
    isLoading = value;
    update(['main']);
  }


  updateItem(String item){
selectedItem = item;
update(['updateItem']);
  }


  getAllCourse()async{
    try {
     changeLoading(true);
      await FirebaseFirestore.instance.collection('courses').get().then((value){
        value.docs.forEach((element) {
          courses.add(TempCourseModel(courseId: 
          element.get('id'), courseImage: element.get('image_url'), courseName: element.get('name'),));
          
        });
        print('length : ${courses.length}');
      });
      changeLoading(false);
       
    } catch (e) {
      changeLoading(false);
      print('Error : $e');
    }
  }

  getStudentDataByEmail({required String email})async{
    try {
      changeLoading(true);
      await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: email).get().then((value) {
          if(value.docs.isEmpty){
            BotToast.showText(text: 'No Account Found On This Email');
          }else if(value.docs.length > 1){
            BotToast.showText(text: 'More Than One Account Found, Please Try Using Mobile Number');
          }else if(value.docs.length == 1){
            studentData = value.docs[0].data();

            studentName = studentData['name'];
            studentId = studentData['id'];

            studentCoursesById = studentData['paidCourseNames'];

          BotToast.showText(text: 'User Fetched Successfully');

          }
      });
      changeLoading(false);
      
    } catch (e) {
      changeLoading(false);
     print('Error $e');
    }
  }


 Future getStudentDataByMobile({required String mobile})async{
    try {
      changeLoading(true);
      await FirebaseFirestore.instance.collection('Users').where('mobilenumber', isEqualTo: mobile).get().then((value) {
          if(value.docs.isEmpty){
            BotToast.showText(text: 'No Account Found On This Mobile');
          }else if(value.docs.length > 1){
            BotToast.showText(text: 'More Than One Account Found, Please Delete An Account');
          }else if(value.docs.length == 1){
            studentData = value.docs[0].data();

            studentName = studentData['name'];
            studentId = studentData['id'];
            studentCoursesById = studentData['paidCourseNames'];
BotToast.showText(text: 'User Fetched Successfully');
          

          
          }
      });
      changeLoading(false);
      
    } catch (e) {
      changeLoading(false);
     print('Error $e');
    }
  }

  addCourse()async{
    try {
      changeLoading(true);
      var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('POST', Uri.parse('https://us-central1-cloudyml-app.cloudfunctions.net/adduser/addgroup'));
request.body = json.encode({
  "sname": studentName,
  "sid": studentId,
  "cname": selectedCourseName,
  "image": selectedCourseImage,
  "cid": selectedCourseId
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  BotToast.showText(text: 'Course Added Successfully');
}
else {
  BotToast.showText(text: response.reasonPhrase.toString());
}
selectedCourseId = '';
selectedCourseName = '';
selectedCourseImage = '';
studentName = '';
studentId = '';
emailController.clear();
mobileController.clear();
studentCoursesById.clear();
changeLoading(false);
    } catch (e) {
      selectedCourseId = '';
selectedCourseName = '';
selectedCourseImage = '';
studentName = '';
studentId = '';
emailController.clear();
mobileController.clear();
studentCoursesById.clear();

      changeLoading(false);

      print('Error in add course $e');
    }
  }

List removerdCourse = [];
  updateCourseRemove(int index){
   var data = studentCoursesById.removeAt(index);
   removerdCourse.add(data);
    update(['updateCourseRemove']);
  }

removeCourseFromUserAcc()async{
  try{
 changeLoading(true);
    await FirebaseFirestore.instance.collection('Users').doc(studentId).update({
      'paidCourseNames' : studentCoursesById
    }).whenComplete(()  {

      removerdCourse.forEach((element)async {
         await removeChatGroupFromUser(courseId: element);
      });
      
      BotToast.showText(text: 'Course Removed Successfully');
    });
changeLoading(false);


    }catch(e){
      changeLoading(false);

      print('Error in remove course $e');
    }
}


removeChatGroupFromUser({required String courseId})async{

  try {
    String courseName ='';
    await FirebaseFirestore.instance.collection('courses').where('id', isEqualTo: courseId).get().then((value) {
        if(value.docs.isNotEmpty){
          courseName = value.docs[0].get('name');
        }
    });

    if(courseName.isNotEmpty){
      String docId = '';
      await FirebaseFirestore.instance.collection('groups').where('student_id', isEqualTo: studentId).where('name', isEqualTo: courseName).get().then((value) {
if(value.docs.isNotEmpty){
docId = value.docs[0].id;
}
      });
 await FirebaseFirestore.instance.collection('groups').doc(docId).delete();

    }
  } catch (e) {
    print('Error in remove chat $e');
  }

}


  @override
  void onInit() {
    getAllCourse();
    mobileController.text = '+91';
    super.onInit();
  }
}

class TempCourseModel with CustomDropdownListFilter


{
  final String courseName;
  final String courseId;
  final String courseImage;
  TempCourseModel({required this.courseId,required this.courseImage,required this.courseName});
  @override
  String toString() {
    return courseName;
  }

  @override
  bool filter(String query) {
    return courseName.toLowerCase().contains(query.toLowerCase());
  }
}