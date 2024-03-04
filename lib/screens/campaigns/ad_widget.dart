import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShowCampaign{

  showCampaignDialog(
    {
      required String title,
      required String webImg,
      required String phoneImg,
      required String ctaText,
      required String ctaLink

    }
  ){

  return BotToast.showWidget(
    
    toastBuilder: (cancelFunc) {
    return Center(
      child: Container(
        height:MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height / 1.3 ,
       width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width / 2,
      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(15.sp),
          color: Colors.deepPurple
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
               
                Material(
                  color: Colors.transparent,
                  child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TyperAnimatedText(title,
                                        speed: Duration(microseconds: 10000),
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                ),
                    GestureDetector(
                      
                      onTap: cancelFunc,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white)
                        ),
                        child: Center(
                          child: Icon(Icons.close, color: Colors.white,size: 15,),
                        ),
                      ),
                    )         
              ],
            )
          ,SizedBox(
                                height: 15.sp,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.sp),
                                child: Image.network(
                                  webImg,
                                  fit: BoxFit.fill,
                                  height: Adaptive.h(50),
                                  width: Adaptive.w(50),
                                ),
                              ),
                              SizedBox(
                                height: 15.sp,
                              ),
                              SizedBox(
              width: 60.sp,
              height: 20.sp,
              child: ElevatedButton(
                  onPressed: ()async {
                    await launchURL(ctaLink);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  child: Text(
                    ctaText,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  )),
            ),
         
          ],
        ),
      ),
    );
  },);
}



showCampaignByCondition()async{
  try {
    String userType = '';
    var ref = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();


          if(ref.get('paid') == 'false' && ref.get('trialCourseList').isNotEmpty){
                userType = 'Trial';
          }else if(ref.get('paid') == 'true' && ref.get('paidCourseNames').isNotEmpty){
            userType = 'Enrolled';
          }else{
            userType = 'Not Enrolled';
          }

    if(userType.isNotEmpty){
      print('Campaign Target User Type : $userType');
        if(userType == 'Trial'){
          await FirebaseFirestore.instance.collection('Campaigns').where('audienceType', isEqualTo: 'Trial').where('isActive', isEqualTo: true).get().then((value) {

            value.docs.forEach((element) {
             
              var startDate = element.get('targetAudience')['startDate'].toDate();
              var endDate = element.get('targetAudience')['endDate'].toDate();
              var courseId = element.get('targetAudience')['targetCourseId'];
              if(isDateInRange(startDate, endDate, ref.get('tdate').toDate())  && ref.get('trialCourseList').contains(courseId)){

                showCampaignDialog(
                  title: element.get('campaignDetails')['header'],
                  webImg: element.get('campaignDetails')['images']['webImg'],
                  phoneImg: element.get('campaignDetails')['images']['phoneImg'],
                  ctaText: element.get('campaignDetails')['ctaText'],
                  ctaLink: element.get('campaignDetails')['ctaLink']
                );

              }
              
            });
           

          });

        }else if(userType == 'Enrolled'){
             
           await FirebaseFirestore.instance.collection('Campaigns').where('audienceType', isEqualTo: 'Enrolled').where('isActive', isEqualTo: true).get().then((value) {
              value.docs.forEach((element) {
                 var startDate = element.get('targetAudience')['startDate'].toDate();
              var endDate = element.get('targetAudience')['endDate'].toDate();
              var courseId = element.get('targetAudience')['targetCourseId'];


               if(isDateInRange(startDate, endDate,  ref.data()!.containsKey('purchaseDate') ? ref.get('purchaseDate').toDate()  : DateTime.parse(ref.get('date')))  && ref.get('paidCourseNames').contains(courseId)){
   showCampaignDialog(
                  title: element.get('campaignDetails')['header'],
                  webImg: element.get('campaignDetails')['images']['webImg'],
                  phoneImg: element.get('campaignDetails')['images']['phoneImg'],
                  ctaText: element.get('campaignDetails')['ctaText'],
                  ctaLink: element.get('campaignDetails')['ctaLink']
                );
               }
                
              });
           });

        }else if(userType == 'Not Enrolled'){

           await FirebaseFirestore.instance.collection('Campaigns').where('audienceType', isEqualTo: 'Not Enrolled').where('isActive', isEqualTo: true).get().then((value) {
               value.docs.forEach((element) {
              var startDate = element.get('targetAudience')['startDate'].toDate();
              var endDate = element.get('targetAudience')['endDate'].toDate();
              var courseId = element.get('targetAudience')['targetCourseId'];


              if(ref.get('paidCourseNames').isEmpty){
                   showCampaignDialog(
                  title: element.get('campaignDetails')['header'],
                  webImg: element.get('campaignDetails')['images']['webImg'],
                  phoneImg: element.get('campaignDetails')['images']['phoneImg'],
                  ctaText: element.get('campaignDetails')['ctaText'],
                  ctaLink: element.get('campaignDetails')['ctaLink']
                );
             }

              
               });
           });

        }


    }

  } catch (e) {
    print('Error in campaign show $e');
  }

}

bool isDateInRange(DateTime startDate, DateTime endDate, DateTime dateToCheck) {
  return dateToCheck.isAfter(startDate) && dateToCheck.isBefore(endDate);
}

}
