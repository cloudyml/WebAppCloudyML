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
final height  = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
final width = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  return BotToast.showWidget(

    
    
    toastBuilder: (cancelFunc) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:    
        width < 600 ?
        20 :0
        
         ),
        child: Container(
         
         width: 
         width < 600 ?
        
          width :
        width / 2,
        padding: EdgeInsets.symmetric(horizontal: 
        width < 600 ?
        10 :
        40,vertical:
        width < 600 ?
        10 :
         20),
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(15.sp),
            color: Colors.deepPurple
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                 
                  Center(
                   
                    child: Material(
                      color: Colors.transparent,
                      
                      child: DefaultTextStyle(
                        
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        child: AnimatedTextKit(
                                        isRepeatingAnimation: false,
                        
                                        animatedTexts: [
                                          TyperAnimatedText(addNewlinesAfter4Words(title),
                                          textAlign: TextAlign.center,
                                              speed: Duration(microseconds: 10000),
                        
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                        
                                                  fontSize:
                                                  
                                                   16.sp,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                      ),
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
                                     width < 600 ? 
                                     phoneImg :
                                    webImg,
                                    fit: BoxFit.fill,
                                    height: 
                                    
                                    Adaptive.h(50),
                                    width:
                                    width < 600?
                                    Adaptive.w(80) :
                                    
                                     Adaptive.w(50),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.sp,
                                ),
                                SizedBox(
                width: 
                width < 600 ?
                double.infinity :
                60.sp,
                height:
                width < 600 ?
                25.sp :
                 20.sp,
                child: ElevatedButton(
                    onPressed: ()async {
                      await launchURL(ctaLink);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    child: Text(
                      ctaText,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 
                          width < 600 ? 
                          16.sp :
                          14.sp),
                    )),
              ),
           
            ],
          ),
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
              // var startDate = element.get('targetAudience')['startDate'].toDate();
              // var endDate = element.get('targetAudience')['endDate'].toDate();
              // var courseId = element.get('targetAudience')['targetCourseId'];


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


String addNewlinesAfter4Words(String inputText) {
  List<String> words = inputText.split(' ');
  List<String> result = [];

  for (int i = 0; i < words.length; i++) {
    result.add(words[i]);
    if ((i + 1) % 4 == 0) {
      result.add('\n');
    }
  }

  return result.join(' ');
}
}
