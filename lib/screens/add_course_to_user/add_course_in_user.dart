import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloudyml_app2/screens/add_course_to_user/add_course_in_user_controller.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddCourseInUser extends StatelessWidget {
   AddCourseInUser({Key? key}) : super(key: key);


    final decoratedField = InputDecoration(
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: MyColors.primaryColor)),
      labelStyle: TextStyle(color: Colors.purple),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Text('Add/Remove Course In User Account'),
          centerTitle: true,
          elevation: 2,
          backgroundColor: MyColors.primaryColor,
        ),
      body: GetBuilder<AddCourseInUserController>(
        id: 'main',
        init: AddCourseInUserController(),
        builder: (controller) {
          return 
          controller.isLoading ?
          Center(child: CircularProgressIndicator(color: MyColors.primaryColor,),) :
          
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
            'Add Course In User Using :',
            style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8,),
          
                      Container(
                    width: Adaptive.w(40),
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.primaryColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: GetBuilder<AddCourseInUserController>(
                          id: 'updateItem',
                          builder: (ctr) {
                            return DropdownButton<String>(
                                        value: controller.selectedItem,
                                        onChanged: (String? newValue) {
                                          ctr.updateItem(newValue!);
                                         
                                        },
                                        underline: SizedBox(),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        borderRadius: BorderRadius.circular(10),
                                        isExpanded: true,
                                        items: <String>['Email', 'Mobile']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                          }
                        ),
                      ),
          
                        SizedBox(height: 10,),
          
                        
                       GetBuilder<AddCourseInUserController>(
                         id: 'updateItem',
                        builder: (ctr) {
                          return
                          ctr.selectedItem == 'Email' ?
                          
                           SizedBox(
                                      width: Adaptive.w(40),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: ctr.emailController,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter email';
                                                }
                                              },
                                          
                                              onEditingComplete: () {
                                                if(ctr.emailController.text.isEmpty){
                                                  BotToast.showText(text: 'Pleease enter email');
                                                }else{
                                                ctr.getStudentDataByEmail(email: ctr.emailController.text.trim());
          
                                                }
                                              },
                                              decoration: decoratedField.copyWith(
                                                  labelText: 'Enter User Email'),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                            SizedBox(
                                              width: Adaptive.w(8),
                                            
                                              child: ElevatedButton(onPressed: ()async{
          
                                                  if(ctr.emailController.text.isEmpty){
                                                  BotToast.showText(text: 'Pleease enter email');
                                                }else{
                                               await ctr.getStudentDataByEmail(email: ctr.emailController.text.trim());
          
                                                }
                                              }, child: Text('Fetch User', style: TextStyle(fontSize: 10),),style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),))
                                        ],
                                      )) : SizedBox(
                                      width: Adaptive.w(40),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: ctr.mobileController,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter mobile';
                                                }else if(!value.startsWith('+')){
                                                   return 'Please enter mobile starting with + sign';
                                                }else if(value.trim().length <= 11 ){
                                          return 'Please enter mobile with country code';
                                                }
                                              },
                                              onEditingComplete: () async{
                                                if(ctr.mobileController.text.isEmpty){
                                                  BotToast.showText(text: 'Pleease enter mobile');
                                                }else{
                                                 await ctr.getStudentDataByMobile(mobile: ctr.mobileController.text.trim());
          
          
                                                }
                                              
                                                
                                              },
                                              decoration: decoratedField.copyWith(
                                                  labelText: 'Enter User Mobile'),
                                            ),
                                          ),
                                           SizedBox(width: 20,),
                                            SizedBox(
                                              width: Adaptive.w(8),
                                            
                                              child: ElevatedButton(onPressed: ()async{
                                                            if(ctr.mobileController.text.isEmpty){
                                                  BotToast.showText(text: 'Pleease enter mobile');
                                                }else{
                                                 await ctr.getStudentDataByMobile(mobile: ctr.mobileController.text.trim());
          
          
                                                }
                                              }, child: Text('Fetch User', style: TextStyle(fontSize: 10),),style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),))
                                        ],
                                      )); 
                        }
                      ),
                       SizedBox(height: 15,),
                  
                           SizedBox(
                             width: Adaptive.w(40),
                             child: CustomDropdown<TempCourseModel>.search(
                                 hintText: 'Select Course',
                                 items: controller.courses,
                                 
                                 decoration: CustomDropdownDecoration(
                                  closedBorder: Border.all(color: MyColors.primaryColor),
                                  closedBorderRadius: BorderRadius.circular(10)
                                 ),
                                 excludeSelected: false,
                                 onChanged: (value) {
                                  controller.selectedCourseName = value.courseName;
                                  controller.selectedCourseImage = value.courseImage;
                                  controller.selectedCourseId = value.courseId;
                                 },
                               ),
                           ),
          
           SizedBox(height: 15,),
           SizedBox(
            height: 30,
             width: Adaptive.w(40),
             child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(MyColors.primaryColor)
              ),
              onPressed: (){
                if(controller.studentName.isEmpty || controller.studentId.isEmpty){
                  BotToast.showText(text: 'Please Fill All Data');
                }else{
                  controller.addCourse();
                }
           
             }, child: Text('Add Course')),
           ),
           SizedBox(height: 20,),
          
           controller.studentCoursesById.isEmpty ?
           SizedBox() :
           Container(
             width: Adaptive.w(40),
             decoration: BoxDecoration(
              border: Border.all(color: MyColors.primaryColor),
              borderRadius: BorderRadius.circular(10)
             ),
             padding: EdgeInsets.all(10),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
             Text(
            'Delete Course In User Account',
            style: TextStyle(fontSize: 14),
                  ),
                 SizedBox(height: 15,),
                 GetBuilder<AddCourseInUserController>(
                  id: 'updateCourseRemove',
                   builder: (ctr) {
             return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
              controller.studentCoursesByName.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chip(
                  label: Text(controller.studentCoursesByName[index].courseName),
                  onDeleted: () => ctr.updateCourseRemove(index),
                  avatar: 
                  controller.studentCoursesByName[index].isTrial ?
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text('Trial', style: TextStyle(color: Colors.white, fontSize: 6),),
                    ),

                  ) : SizedBox()
                ),
              ),
                ),
              );
                   }
                 ),
            SizedBox(height: 15,),
             SizedBox(
             width: Adaptive.w(40),
             child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(MyColors.primaryColor)
              ),
              onPressed: ()=> controller.removeCourseFromUserAcc(), child: Text('Update Course In User Account')),
              ),
               ],
             ),
           )
                      
                      
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}