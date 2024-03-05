import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/add_course_to_user/add_course_in_user_controller.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CampaignController extends GetxController{
    bool isLoading = true;
   int currentStep = 0;
   TextEditingController campaignNameController = TextEditingController();
   TextEditingController headerController = TextEditingController();
  TextEditingController callToActionLinkController = TextEditingController();
   Uint8List? imageBytesForPhone;
   Uint8List? imageBytesForWeb;
   String? pickedFileNamePhone;
   String? pickedFileNameWeb;
   String imageLinkForPhone = '';
   String imageLinkForWeb = '';
 String selectedCourse = '';
 String selectedCourseId = '';
 String selectedCtaText = '';
   String selectedUserType = 'Trial';
    List<TempCourseModel> courses = [];
    List<DateTime?> dateRangeVal = const [];
    DateTime? startDate;
    DateTime? endDate;
    bool isActive = false;

changeLoading(bool value) {
    isLoading = value;
    update(['main']);
  }


  updateStep(){
    currentStep = currentStep;
    update(['updateStep']);
  }

updateUserType(){
    selectedUserType = selectedUserType;
    update(['updateUserType']);
  }

  updateDate(){
    startDate = startDate;
    endDate = endDate;
     update(['updateDate']);
  }

  updateActive(){
    isActive = isActive;
 update(['isActive']);
  }
 
 void selectDateRange(int days) {
  
      endDate = DateTime.now();
      startDate = endDate!.subtract(Duration(days: days - 1));
       update(['updateDate']);
  
  }

  void pickImageForPhone() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      imageBytesForPhone = result.files.single.bytes;
      pickedFileNamePhone = result.files.first.name;
    }

    update(['setImgForPhone']);
  }

  void pickImageForWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      imageBytesForWeb = result.files.single.bytes;
      pickedFileNameWeb = result.files.first.name;
    }

    update(['setImgForWeb']);
  }


clearPicInPhone(){
  imageBytesForPhone= null;
  update(['setImgForPhone']);

}

clearPicInWeb(){
  
  imageBytesForWeb = null;
  update(['setImgForWeb']);

}

  getAllCourse() async {
    try {
      changeLoading(true);
      await FirebaseFirestore.instance
          .collection('courses')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          courses.add(TempCourseModel(
            courseId: element.get('id'),
            courseImage: element.get('image_url'),
            courseName: element.get('name'),
          ));
        });
     
      });
      changeLoading(false);
    } catch (e) {
      changeLoading(false);
      print('Error : $e');
    }
  }

  Future<String> uploadCampaignPic(Uint8List? bytesPic, String fileName)async{
    try {
      if (bytesPic == null) {
        Fluttertoast.showToast(msg: 'Mobile/Web Image Empty');
        return '';
      }else{
         var storageRef = FirebaseStorage.instance
            .ref()
            .child('Campaigns')
            .child(fileName);

            final UploadTask uploadTask = storageRef.putData(bytesPic);

        final TaskSnapshot downloadUrl = await uploadTask;
        final String fileURL = (await downloadUrl.ref.getDownloadURL());

        return fileURL;
        
      }
    } catch (e) {
      print('Error in upload campaign pic $e');
       return '';
    }
  }


  uploadCampaignData()async{
try {
 if(campaignNameController.value.text.isEmpty){
 toast('Please enter campaign name');
 }else if(selectedCourse.isEmpty){
  toast('Please select course');
 

 }else if(startDate == null || endDate == null){
  toast('Please select start and end date of the campaign');

 }else if(headerController.value.text.isEmpty){
  toast('Please enter campaign header');

 }else if(callToActionLinkController.value.text.isEmpty){
  toast('Please enter call to action link');

 }else if(selectedCtaText.isEmpty){
  toast('Please select call to action text');

 }else if(imageBytesForPhone== null || imageBytesForWeb == null){
  toast('Please select both image');
 
}
 
 
 
 
 
 else{
   changeLoading(true);
  imageLinkForPhone = await uploadCampaignPic(imageBytesForPhone, pickedFileNamePhone!);
  imageLinkForWeb = await uploadCampaignPic(imageBytesForWeb,pickedFileNameWeb!);
  await FirebaseFirestore.instance.collection('Campaigns').add({
    'campaignName' : campaignNameController.value.text.trim(),
    'createdAt' : DateTime.now(),
    'isActive' : isActive,
     'audienceType' : selectedUserType.trim(),
    'targetAudience' : {
     
      'targetCourseName' : selectedCourse.trim(),
      'targetCourseId' : selectedCourseId.trim(),
      'startDate' : startDate,
      'endDate' : endDate
 },
      'campaignDetails' : {
        'header' : headerController.value.text.trim(),
        'ctaLink' : callToActionLinkController.value.text.trim(),
        'ctaText' : selectedCtaText,
        'images' : {
          'phoneImg' : imageLinkForPhone,
          'webImg' : imageLinkForWeb
        }
      }

  }).whenComplete(() {
    toast('Campaign Succesfully Added');
    campaignNameController.clear();
    selectedUserType = 'Trial';
    selectedCourse = '';
    selectedCourseId = '';
    startDate = null;
    endDate = null;
    headerController.clear();
    callToActionLinkController.clear();
    selectedCtaText = '';
    imageBytesForPhone = null;
    imageBytesForWeb = null;

currentStep = 0;


   
  });
  changeLoading(false);
  
 }
} catch (e) {
  changeLoading(false);
  print('Error in upload campaign data $e');
}
  }


toast(String msg){
  Fluttertoast.showToast(msg: msg,gravity: ToastGravity.CENTER,webPosition: "center",textColor: Colors.black,fontSize: 14,webShowClose: true,webBgColor: '#C7BCFC', backgroundColor: MyColors.primaryColor);

}
@override
  void onInit() {
   getAllCourse();
    super.onInit();
  }




}