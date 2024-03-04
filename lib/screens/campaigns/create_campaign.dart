import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloudyml_app2/screens/add_course_to_user/add_course_in_user_controller.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import 'campaign_controller.dart';

class CreateCampaign extends StatelessWidget {
   CreateCampaign({Key? key}) : super(key: key);

 
    final decoratedField = InputDecoration(
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.primaryColor)),
      labelStyle: TextStyle(color: MyColors.primaryColor),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2)));

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Campaign',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: MyColors.primaryColor,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
      ),
      body: 
      width < 750 ?
      Center(
        child: Text('Please use on web'),
      ) :
      
      GetBuilder<CampaignController>(
          id: 'main',
          init: CampaignController(),
          builder: (controller) {
            return 
            
             controller.isLoading ?
          Center(child: CircularProgressIndicator(color: MyColors.primaryColor,),) :
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GetBuilder<CampaignController>(
                    id: 'updateStep',
                    builder: (ctr) {
                      return Expanded(
                        child: Stepper(
                          steps: [
                            Step(
                            title: Text('Set Campaign Name', overflow: TextOverflow.ellipsis,),
                            content: step1Content(context, controller: controller),
                            isActive: true,
                          ),
                          Step(
                            title: Text('Set Audience',overflow: TextOverflow.ellipsis,),
                            content: step2Content(context, controller: controller),
                            isActive: true,
                          ),
                          Step(
                            title: Text('Set Template',overflow: TextOverflow.ellipsis,),
                            content: step3Content(context, controller: controller),
                            isActive: true,
                            
                          )
                          ],
                          type: width > 750  ? StepperType.vertical : StepperType.horizontal,
                          connectorColor: MaterialStatePropertyAll(MyColors.primaryColor),
                          connectorThickness: 2,
                          currentStep: ctr.currentStep,
                          controlsBuilder: (context, details) {
                           return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: Text('Back', style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey.shade300),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                          elevation: MaterialStateProperty.all<double>(0),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade400), // Color when pressed
                        ),
                      ),
                      SizedBox(width: 7.5.sp,),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(
                          details.currentStep == 2 ?
                          'Finish':
                          
                          'Next'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(MyColors.primaryColor),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                          elevation: MaterialStateProperty.all<double>(0),
                          overlayColor: MaterialStateProperty.all<Color>(
                              MyColors.primaryColorLight), // Color when pressed
                        ),
                      ),
                                          ],
                                        );
                          },
                          onStepContinue: () {
                            if (ctr.currentStep <
                                3 - 1) {
                              ctr.currentStep += 1;
                              ctr.updateStep();
                            }
                          },
                          onStepCancel: () {
                            if (ctr.currentStep > 0) {
                              ctr.currentStep -= 1;
                              ctr.updateStep();
                            }
                          },
                          onStepTapped: (step) {
                            ctr.currentStep = step;
                            ctr.updateStep();
                          },
                          
                        ),
                      );
                    }
                  ),
                   GetBuilder<CampaignController>(
                     builder: (ctr) {
                       return InkWell(
                           onTap: ()=> ctr.uploadCampaignData(),
                           child: Container(
                             height: 40,
                            width:50,
                             decoration: BoxDecoration(
                               color: MyColors.primaryColorLight,
                             
                               borderRadius: BorderRadius.circular(10)
                             ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                             child: Center(
                               child: Text('Create Campaign', style: TextStyle(
                                 fontSize: 15, 
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold
                               ),),
                             ),
                           ),
                         );
                     }
                   )
                       
                ],
              ),
            );
          }),
    );
  }


  Widget step1Content(BuildContext context, {required CampaignController controller}){
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Enter campaign name", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10,),
             SizedBox(
            
              width: MediaQuery.of(context).size.width / 2.5,
               child: TextFormField(
                                                    controller: controller.campaignNameController,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter campaign name';
                                                      }
                                                    },
                                                
                                                    
                                                    decoration: decoratedField.copyWith(),
                                                  ),
             ),
          ],
        ),
      ),
    );
  }




Widget step2Content(BuildContext context, {required CampaignController controller}){
return Align(   alignment: Alignment.centerLeft,child: Padding(padding: 
const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
child: GetBuilder<CampaignController>(
  id: 'updateUserType',
  builder: (ctr) {
    return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Select Audience Type", style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10,),
        SizedBox(
          width:MediaQuery.of(context).size.width /5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'Trial',
                    activeColor: MyColors.primaryColor,
                    splashRadius: 15,
                    groupValue: controller.selectedUserType,
                    onChanged: (String? value) {
                     
                        controller.selectedUserType = value!;
                         controller.updateUserType();
                   
                    },
                  ),
                  Text('Trial'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'Enrolled',
                    splashRadius: 15,
                     activeColor: MyColors.primaryColor,
                    groupValue: controller.selectedUserType,
                    onChanged: (String? value) {
                      
                        controller.selectedUserType = value!;
                    controller.updateUserType();
                    },
                  ),
                  Text('Enrolled'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'Not Enrolled',
                    activeColor: MyColors.primaryColor,
                    splashRadius: 15,
                    groupValue: controller.selectedUserType,
                    onChanged: (String? value) {
                     
                        controller.selectedUserType = value!;
                         controller.updateUserType();
                   
                    },
                  ),
                  Text('Not Enrolled'),
                ],
              ),
            ],
          ),
        )
      ,
      Column(
         crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
        children: [
SizedBox(height: 20,),
           Text("Select Course", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10,),
            SizedBox(
                           width: MediaQuery.of(context).size.width / 2.5,
                             child: CustomDropdown<TempCourseModel>.search(
                                 hintText: 'Select Course',
                                 items: ctr.courses,
                                 
                                 decoration: CustomDropdownDecoration(
                                  
                                  closedBorder: Border.all(color: MyColors.primaryColor),
                                  closedBorderRadius: BorderRadius.circular(10)
                                 ),
                                 excludeSelected: false,
                                 
                                 onChanged: (value) {
                              controller.selectedCourse = value.courseName;
                                  
                                  controller.selectedCourseId = value.courseId;
                                 },
                               ),
                           ),
SizedBox(height: 20,),
Row(
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Date Range", style: TextStyle(fontSize: 14)),
        SizedBox(height: 10,),
    SizedBox(
       width:MediaQuery.of(context).size.width /2,
       child: Row(
        children: [
    dateBtn(lable: 'Last 7 Days', onTap: ()=> ctr.selectDateRange(7)),
    SizedBox(width: 10,),
    dateBtn(lable: 'Last 28 Days', onTap: ()=> ctr.selectDateRange(28)),
    SizedBox(width: 10,),
    
    dateBtn(lable: 'Last 3 Months', onTap: ()=>ctr.selectDateRange(90)),
    SizedBox(width: 10,),
    
    dateBtn(lable: 'Choose Date', onTap: (){showDateDialog(context,value: ctr.dateRangeVal,controller: ctr);}),
    
    
        ],
       ),
    )
    
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text("Start Date", style: TextStyle(fontSize: 14)),
        SizedBox(height: 10,),
        GetBuilder<CampaignController>(
          id: 'updateDate',
          builder: (ctr) {
            return dateBtn(onTap: (){}, lable:  ctr.startDate == null ?
            'Not Selected' :
            DateFormat('dd-MM-yyyy').format(ctr.startDate!));
          }
        )
      ],
    ),
    SizedBox(width: 20,),
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text("End Date", style: TextStyle(fontSize: 14)),
        SizedBox(height: 10,),
        GetBuilder<CampaignController>(
          id: 'updateDate',
          builder: (ctr) {
            return dateBtn(onTap: (){}, lable: 
            ctr.endDate == null ?
            'Not Selected' :
            DateFormat('dd-MM-yyyy').format(ctr.endDate!)
            );
          }
        )
      ],
    )
  
  ],
),


        ],
      ) 
    
      ],
    );
  }
),

),);
}
 Widget step3Content(BuildContext context, {required CampaignController controller}){
return Align(
   alignment: Alignment.centerLeft,
  child: Padding(
     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
    child: Row(
      children: [
        Expanded(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Text("Enter header", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10,),
                   SizedBox(
                  
                    width: MediaQuery.of(context).size.width / 2.5,
                     child: TextFormField(
                                                          controller: controller.headerController,
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter header';
                                                            }
                                                          },
                                                      
                                                          
                                                          decoration: decoratedField.copyWith(),
                                                        ),
                   ),
                     SizedBox(height: 20,),
                      Text("Enter call to action link", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10,),
                   SizedBox(
                  
                    width: MediaQuery.of(context).size.width / 2.5,
                     child: TextFormField(
                                                          controller: controller.callToActionLinkController,
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter call to action link';
                                                            }
                                                          },
                                                      
                                                          
                                                          decoration: decoratedField.copyWith(),
                                                        ),
                   ),
                     SizedBox(height: 20,),
                      Text("Select call to action text", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10,),
                   SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.5,
                     child: CustomDropdown<String>.search(
                                   hintText: 'Select call to action text',
                                   items: [
                                    'Register Now',
                                    'Learn More',
                                    'Visit Here',
                                    'Click Here',
                                    'Join Now',
                                    'Pay Now'
                                   ],
                                   
                                   decoration: CustomDropdownDecoration(
                                    hintStyle: TextStyle(fontSize: 12),
                                    listItemStyle: TextStyle(fontSize: 12),
                                    headerStyle: TextStyle(fontSize: 12),
                                    closedBorder: Border.all(color: MyColors.primaryColor),
                                    closedBorderRadius: BorderRadius.circular(10)
                                   ),
                                   excludeSelected: false,
                                   onChanged: (value) {
                                   controller.selectedCtaText= value;
                                   },
                                 ),
                   ),
          ],
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: GetBuilder<CampaignController>(
            id: 'setImgForPhone',
            builder: (ctr) {
              return Container(
              height: 280,
                decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 0.5),
                borderRadius: BorderRadius.circular(10)
                ),
              child: Center(
                child: 
                
                 ctr.imageBytesForPhone != null
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                        ctr.imageBytesForPhone!,
                        width: 200,
                            height: 200,
                        fit: BoxFit.cover,
                        
                      ),
                      IconButton(
                        splashRadius: 10,
                        onPressed: ()=>ctr.clearPicInPhone(), icon: Icon(Icons.delete, color: Colors.red,))
                  ],
                )
                :
                InkWell(
                  onTap: ()=> ctr.pickImageForPhone(),
                  child:
                  
                
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.black),
                       SizedBox(height: 8,),
                       Text("Choose Image For Phone", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              );
            }
          ),
        )
         ,
          SizedBox(width: 10,),
         Expanded(
          child: GetBuilder<CampaignController>(
            id: 'setImgForWeb',
            builder: (ctr) {
              return Container(
              height: 280,
                decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 0.5),
                borderRadius: BorderRadius.circular(10)
                ),
              child: Center(
                child: 
                
                 ctr.imageBytesForWeb != null
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                        ctr.imageBytesForWeb!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        splashRadius: 10,
                        onPressed: ()=>ctr.clearPicInWeb(), icon: Icon(Icons.delete, color: Colors.red,))
                  ],
                )
                :
                InkWell(
                  onTap: ()=> ctr.pickImageForWeb(),
                  child:
                  
                
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.black),
                       SizedBox(height: 8,),
                       Text("Choose Image For Web", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              );
            }
          ),
        )
     
      
      ],
    ),
  ),
);
 }

Widget dateBtn({required VoidCallback onTap, required String lable}){
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 25,
     
      decoration: BoxDecoration(
        color: MyColors.primaryColorLight.withOpacity(.3),
        border: Border.all(color: MyColors.primaryColor),
        borderRadius: BorderRadius.circular(10)
      ),
     padding: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Text(lable, style: TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold
        ),),
      ),
    ),
  );
}



showDateDialog(BuildContext context,{required List<DateTime?> value, required CampaignController controller})async{
  var result = await showCalendarDatePicker2Dialog(
  context: context,

  config: CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: MyColors.primaryColor,
    
  ),
 
  dialogSize: const Size(325, 400),
  value: value,
  
  borderRadius: BorderRadius.circular(15),
);
controller.dateRangeVal = result!;
controller.startDate = controller.dateRangeVal[0];
controller.endDate =  controller.dateRangeVal[1];
controller.updateDate();


}

}
