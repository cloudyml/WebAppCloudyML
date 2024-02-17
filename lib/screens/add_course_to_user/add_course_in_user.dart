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
    double height  = MediaQuery.of(context).size.height;
    double width  = MediaQuery.of(context).size.width;
    return Scaffold(
       appBar: AppBar(
          title: Text('Add/Remove Course In User Account',style: TextStyle(fontSize: 14),),
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
              padding:  EdgeInsets.symmetric(vertical: 20, horizontal:  width > 750 ? 0 : 20),
              child: Center(
                child: SizedBox(
                  width:
                  width > 750 ?
                 MediaQuery.of(context).size.width/2 :
                   MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
            'Add Course In User Using :',
            style: TextStyle(fontSize: 
            14),
                  ),
                  SizedBox(height: 8,),
          
                      Container(
                    width: 
                    width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
                                      width: width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
                                              width:  width > 750 ?
                    Adaptive.w(8) : 100,
                                            
                                              child: ElevatedButton(onPressed: ()async{
          
                                                  if(ctr.emailController.text.isEmpty){
                                                  BotToast.showText(text: 'Pleease enter email');
                                                }else{
                                               await ctr.getStudentDataByEmail(email: ctr.emailController.text.trim());
          
                                                }
                                              }, child: Text('Fetch User', style: TextStyle(fontSize: 10),),style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),))
                                        ],
                                      )) : SizedBox(
                                      width:  width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
                                              width: width > 750 ?
                    Adaptive.w(8) : 100,
                                            
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
                             width:  width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
             width:  width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
             width: width > 750 ?
                    Adaptive.w(40) : double.infinity,
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
                  label: Text(controller.studentCoursesByName[index].courseName, style: TextStyle(fontSize: width > 750 ?  14 : 8,color: Colors.black),overflow: TextOverflow.ellipsis,),
                  onDeleted: () => ctr.updateCourseRemove(index),
                 // deleteIcon: Icon(Icons.delete, size: width > 750 ? 20 : 5),
                  avatar: 
                  controller.studentCoursesByName[index].isTrial ?
                  Container(
                    height: width > 750 ? null : 15,
                    width: width > 750 ? null : 15,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text('Trial', style: TextStyle(color: Colors.white, fontSize: width > 750 ?  6 : 3),),
                    ),

                  ) : SizedBox(
                    height: width > 750 ? null : 1,
                    width: width > 750 ? null : 1,
                  )
                ),
              ),
                ),
              );
                   }
                 ),
            SizedBox(height: 15,),
             SizedBox(
             width: 
             width > 750 ?
             Adaptive.w(40) : double.infinity,
             child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(MyColors.primaryColor)
              ),
              onPressed: ()=> controller.removeCourseFromUserAcc(), child: Text('Update Course In User Account', style: TextStyle(
                fontSize: 14
              ),)),
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