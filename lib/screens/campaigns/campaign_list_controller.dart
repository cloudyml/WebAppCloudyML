import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/add_course_to_user/add_course_in_user_controller.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignListController extends GetxController{

  List campaignData  = [];
  bool isLoading = true;

 @override
  void onInit() {
    getAllCourse();
    getCampaignData();
    super.onInit();
  }

  deleteCampaign({
  required String docId,
})async{
  changeLoading(true);
   await FirebaseFirestore.instance.collection('Campaigns').doc(docId).delete().whenComplete(() {
 toast('Campaign Deleted Successfully');
   });
    getCampaignData();
   changeLoading(false);

}

changeLoading(bool value) {
    isLoading = value;
    update(['main']);
  }
 void getCampaignData()async{
    try {
      changeLoading(true);
        await FirebaseFirestore.instance.collection('Campaigns').get().then((value) {
            campaignData.clear();
          value.docs.forEach((element) {
            campaignData.add({
              'campaignName'  : element.get('campaignName'),
              'isActive' :element.get('isActive'),
                'audienceType' : element.get('audienceType'),
              'targetAudience' : element.get('targetAudience'),
             'campaignDetails' : element.get('campaignDetails'),
              'docId' : element.id
            });
          });

        });
    changeLoading(false);
    } catch (e) {
      changeLoading(false);
      log('Error in get campaign data $e');
    }
  }


  changeStatusOfCampaign({
    required String docId,
    required bool value
  })async{
    try {
      changeLoading(true);
       await FirebaseFirestore.instance.collection('Campaigns').doc(docId).update({
          'isActive' : value
       }).whenComplete(() async => getCampaignData());
        changeLoading(false);
    } catch (e) {
       changeLoading(false);
      log('Error in change campaign status $e');
    }
  }

 

   TextEditingController campaignNameController = TextEditingController();
   TextEditingController headerController = TextEditingController();
  TextEditingController callToActionLinkController = TextEditingController();
  String selectedCourse = '';
 String selectedCourseId = '';
 String selectedCtaText = '';
   String selectedUserType = '';
    List<TempCourseModel> courses = [];
   List<DateTime?> dateRangeVal = const [];
    DateTime? startDate;
    DateTime? endDate;

    String webImg = '';
    String phoneImg = '';


updateDate(){
    startDate = startDate;
    endDate = endDate;
     update(['updateDate']);
  }

  updateUserType(){
    selectedUserType = selectedUserType;
    update(['updateUserType']);
  }


  showDateDialog(BuildContext context)async{
  var result = await showCalendarDatePicker2Dialog(
  context: context,

  config: CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: MyColors.primaryColor,
    
  ),
 
  dialogSize: const Size(325, 400),
  value: dateRangeVal,
  
  borderRadius: BorderRadius.circular(15),
);
dateRangeVal = result!;
startDate = dateRangeVal[0];
endDate =  dateRangeVal[1];
updateDate();
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





updateCampaign(BuildContext context,{
  required String docId,
})async{
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

 }else{
  changeLoading(true);
   await FirebaseFirestore.instance.collection('Campaigns').doc(docId).update({
 'campaignName' : campaignNameController.value.text.trim(),
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
          'phoneImg' : phoneImg,
          'webImg' : webImg
        }
      }

   }).whenComplete(() {
    Navigator.pop(context);
     toast('Campaign Updated Successfully');
   });
    getCampaignData();
   changeLoading(false);

 }

}





toast(String msg){
  Fluttertoast.showToast(msg: msg,gravity: ToastGravity.CENTER,webPosition: "center",textColor: Colors.black,fontSize: 14,webShowClose: true,webBgColor: '#C7BCFC', backgroundColor: MyColors.primaryColor);

}
}