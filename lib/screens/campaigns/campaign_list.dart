import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloudyml_app2/screens/add_course_to_user/add_course_in_user_controller.dart';
import 'package:cloudyml_app2/screens/campaigns/campaign_list_controller.dart';
// import 'package:cloudyml_app2/screens/create_campaign/campaign_list_controller.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignList extends StatelessWidget {
   CampaignList({Key? key}) : super(key: key);

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
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Campaign List',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: MyColors.primaryColor,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: 
        
        GetBuilder<CampaignListController>(
           id: 'main',
      init: CampaignListController(),
          builder: (ctr) =>   
          
           ctr.isLoading ?
        Center(
          child: CircularProgressIndicator(color: MyColors.primaryColor,),
        ) :
        
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, 
            crossAxisSpacing: 10, 
            mainAxisSpacing: 10, 
            childAspectRatio: 0.75, 
          ),
          itemCount: ctr.campaignData.length, // Number of items in the grid
          itemBuilder: (context, index) {
            
            return Container(
             padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(15),
         border: Border.all(color: MyColors.primaryColor)
              ),
              child: Column(
                children: [
                  Center(
                    child:  Text(ctr.campaignData[index]['campaignName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10,),
                  Image.network(ctr.campaignData[index]['campaignDetails']['images']['webImg'], height: 250, width: 250, ),
                   SizedBox(height: 20,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("CTA Text", style: TextStyle(fontSize: 14, color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8,),
                           Text(ctr.campaignData[index]['campaignDetails']['ctaText'], style: TextStyle(fontSize: 12)),
                         ],
                       ),
                         Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("CTA Link", style: TextStyle(fontSize: 14,color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8,),
                           InkWell(
                            onTap: ()async{
                              await launchUrl(Uri.parse(ctr.campaignData[index]['campaignDetails']['ctaLink']));
                            },
                            child: Text("launch", style: TextStyle(fontSize: 12))),
                         ],
                       ),
                     ],
                   ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text('Display', style: TextStyle(fontSize: 14,color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
                       GetBuilder<CampaignListController>(
                         builder: (ctr) {
                           return Switch(value: ctr.campaignData[index]['isActive'], onChanged: (val){ctr.changeStatusOfCampaign(docId: ctr.campaignData[index]['docId'], value: val);}, activeColor: MyColors.primaryColor,);
                         }
                       )
        
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                   
                      children: [
                        Expanded(child: TextButton(onPressed:(){
                         showUpdateSheet(context,
                         docId: ctr.campaignData[index]['docId'].toString(),
                         campaignName:  ctr.campaignData[index]['campaignName'].toString(),
                         selectedAudiencType: ctr.campaignData[index]['audienceType'].toString(),
                         selectedCourseId: ctr.campaignData[index]['targetAudience']['targetCourseId'].toString(),
                         selectedCourse: ctr.campaignData[index]['targetAudience']['targetCourseName'].toString(),
                         startDate: ctr.campaignData[index]['targetAudience']['startDate'].toDate(),
                         endDate: ctr.campaignData[index]['targetAudience']['endDate'].toDate(),
                         campaignHeader: ctr.campaignData[index]['campaignDetails']['header'].toString(),
                         ctaLink: ctr.campaignData[index]['campaignDetails']['ctaLink'].toString(),
                         ctaText: ctr.campaignData[index]['campaignDetails']['ctaText'].toString(),
                         webImg: ctr.campaignData[index]['campaignDetails']['images']['webImg'].toString(),
                         phoneImg: ctr.campaignData[index]['campaignDetails']['images']['phoneImg'].toString(),
                         
                         
                         
                         );
                        }, child: Text('Edit', style: TextStyle(color: Colors.black),),style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.green.shade400),
                          side: MaterialStatePropertyAll(BorderSide(color: Colors.green,width: 3))
                        ),)),
                         SizedBox(width: 10,),
                        Expanded(child: ElevatedButton(onPressed: ()=> ctr.deleteCampaign(docId: ctr.campaignData[index]['docId']), child: Text('Delete', style: TextStyle(color: Colors.black)), style: ButtonStyle(
                             backgroundColor: MaterialStatePropertyAll(Colors.red.shade400),
                          side: MaterialStatePropertyAll(BorderSide(color: Colors.red,width: 3))
                        ),)),

                      ],
                    )
                ],
              ),
            );
          },
        )
      ,)
        
       
      ),
    );
    
  }
    showUpdateSheet(BuildContext context,
    {
      required String campaignName,
      required String selectedAudiencType,
      required String selectedCourseId,
       required String selectedCourse,
      required DateTime startDate,
      required DateTime endDate,
      required String campaignHeader,
      required String ctaLink,
      required String ctaText,
      required String webImg,
      required String phoneImg,
        required String docId,
      

    }
    
    
    ){

      

      showDialog(context: context,
      
       builder: (context) {
        return GetBuilder<CampaignListController>(
          builder: (controller) {

            controller.campaignNameController.text = campaignName;
            controller.selectedUserType = selectedAudiencType;
            controller.selectedCourseId = selectedCourseId;
            controller.selectedCourse = selectedCourse;
            controller.startDate = startDate;
            controller.endDate = endDate;
             controller.headerController.text = campaignHeader;
             controller.callToActionLinkController.text = ctaLink;
             controller.selectedCtaText = ctaText;
             controller.webImg = webImg;
             controller.phoneImg = phoneImg;


            return SimpleDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              title: Text("Update Campaign", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            
              children: [
                
                        Text("Campaign name", style: TextStyle(fontSize: 14)),
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
                 SizedBox(height: 15,),
                   Text("Selected Audience Type", style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10,),
            SizedBox(
              width:MediaQuery.of(context).size.width /5,
              child: GetBuilder<CampaignListController>(
                id: 'updateUserType',
                builder: (ctr) {
                  return Row(
                    
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
                      SizedBox(width: 15,),
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
                        SizedBox(width: 15,),
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
                  );
                }
              ),
            )
                  ,
            SizedBox(height: 15,),
                   Text("Selected Course", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10,),
                        SizedBox(
                               width: MediaQuery.of(context).size.width / 2.5,
                                 child: CustomDropdown<TempCourseModel>.search(
                                     hintText: 'Select Course',
                                     items: controller.courses,
                                     
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
            SizedBox(height: 15,),
                   Row(
            children: [
                   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
             Text("Choose Date", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10,),
            dateBtn(onTap: ()=> controller.showDateDialog(context), lable: 'Choose Date')
                   
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
             Text("Start Date", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10,),
            GetBuilder<CampaignListController>(
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
           
            GetBuilder<CampaignListController>(
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
                   )
            ,       SizedBox(height: 15,),
            
                    Text("Campaign header", style: TextStyle(fontSize: 14)),
                SizedBox(height: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                   child: TextFormField(
                                                        controller: controller.headerController,
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter campaign name';
                                                          }
                                                        },
                                                    
                                                        
                                                        decoration: decoratedField.copyWith(),
                                                      ),
                 ),
                
                   SizedBox(height: 15,),
                   Text("CTA Link", style: TextStyle(fontSize: 14)),
                SizedBox(height: 10,),
             
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                   child: TextFormField(
                                                        controller: controller.callToActionLinkController,
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter campaign name';
                                                          }
                                                        },
                                                    
                                                        
                                                        decoration: decoratedField.copyWith(),
                                                      ),
                 ),
                
            
                   SizedBox(height: 15,),
                Text("CTA Text", style: TextStyle(fontSize: 14)),
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
                                     controller.selectedCtaText = value;
                                       },
                                     ),
                       ),
             
            SizedBox(height: 15,),
            
            Row(
              children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            
                  children: [
                   Text("Web Image", style: TextStyle(fontSize: 14)),
                   SizedBox(height: 10,),
                   Image.network(controller.webImg, height: 150,width: 150,)
            
                  ],
                ),
            SizedBox(width: 20,),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text("Phone Image", style: TextStyle(fontSize: 14)),
                   SizedBox(height: 10,),
                   Image.network(controller.phoneImg, height: 150,width: 150,)
            
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: ()=> controller.updateCampaign(context, docId: docId),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: MyColors.primaryColor)
                ,
                child: Center(
                  child: Text("Update Campaign", style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            )
              ],
            );
          }
        );
        
         },);
  
  
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




}

