import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';

class Assignments extends StatefulWidget {
  const Assignments({Key? key, this.groupData}) : super(key: key);

  final groupData;

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  var headerTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  var textStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey);

  final emailSearchController = TextEditingController().obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    final searchResults = [].obs;
    final isLoading = false.obs;
    final isError = false.obs;

    Future<RxList> searchEmailInFirestore(String email) async {
      final results = [].obs;

      try {
        isLoading.value = true;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Query the collection for documents with the matching email
        QuerySnapshot querySnapshot = await firestore
            .collection('assignment')
            .where('email',
                isEqualTo: email)
            .get();
        querySnapshot.docs.forEach((doc) {
          results.add(doc.data() as Map<String, dynamic>);
        });

        return results;
      } catch (e) {
        print('Error searching email: $e');
        return results; // Return an empty list in case of an error
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Assignments'),
        actions: [
          Row(
            children: [
              Container(
                height: 40.sp,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                width: Adaptive.w(40),
                child: TextField(
                  controller: emailSearchController.value,
                  cursorColor: MyColors.primaryColor,
                  style: TextStyle(fontSize: 12.sp),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      hintText: 'Search using email',
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (emailSearchController.value.text.isNotEmpty) {
                              searchEmailInFirestore(
                                      emailSearchController.value.text)
                                  .then((results) {
                                searchResults.value = results;
                                isLoading.value = false;
                                isError.value = results.isEmpty;
                              });
                            } else {
                              showSnackbar(context, 'Please enter an email.');
                            }
                          },
                          icon: Icon(
                            Icons.search,
                            color: MyColors.primaryColor,
                          ))),
                ),
              ),
            ],
          )
        ],
      ),

      body: Obx(() {
        return isLoading.isTrue ?
            Center(child: CircularProgressIndicator(color: MyColors.primaryColor,),)
            : isError.isTrue ?
        Center(
            child: Text('No results found for ${emailSearchController.value.text}'))
            : ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final result = searchResults.value[index];
            Timestamp t = result["date of submission"] != null ? result["date of submission"] : '';
            DateTime date = t.toDate();
            return Padding(
              padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp)),
                tileColor: Colors.grey.withOpacity(0.5),
                hoverColor: Colors.green,
                onTap: () {
                  launch(result['link']);
                },
                enableFeedback: true,
                leading: Icon(Icons.download_for_offline_outlined),
                trailing: result["date of submission"] != null ? Text(DateFormat('yyyy-MM-dd').format(date)) : Text('No date'),
                title: Text(result['name'] != null ? result['name'] : 'unknown'),
                subtitle: Text(result['assignmentName'] != null ?result['assignmentName'] : 'Assignment name'),
                // Add more ListTile fields as needed
              ),
            );
          },
        );
      }),

      // body: SingleChildScrollView(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: Container(
      //             child: Center(
      //               child: Row(
      //                 children: [
      //                   Expanded(
      //                       flex: 1,
      //                       child: Text(
      //                         "Sr. No",
      //                         style: headerTextStyle,
      //                       )),
      //                   Expanded(
      //                       flex: 1,
      //                       child:
      //                           Text("Student Name", style: headerTextStyle)),
      //                   Expanded(
      //                       flex: 1,
      //                       child:
      //                           Text("Submitted file", style: headerTextStyle)),
      //                   Expanded(
      //                       flex: 1,
      //                       child: Text("Date of submission",
      //                           style: headerTextStyle)),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //         Padding(
      //           padding: EdgeInsets.only(top: 8.0 * verticalScale),
      //           child: SingleChildScrollView(
      //             child: Container(
      //                 width: screenWidth,
      //                 height: screenHeight,
      //                 child: StreamBuilder(
      //                   stream: FirebaseFirestore.instance
      //                       .collection("assignment")
      //                       .snapshots(),
      //                   builder: (BuildContext context,
      //                       AsyncSnapshot<QuerySnapshot> snapshot) {
      //                     if (snapshot.hasData) {
      //                       return ListView.builder(
      //                         itemCount: snapshot.data!.docs.length,
      //                         itemBuilder: (context, index) {
      //                           //timestamp conversion to date
      //                           Timestamp t = snapshot.data!.docs[index]
      //                               ["date of submission"];
      //                           DateTime date = t.toDate();
      //                           return Padding(
      //                             padding: const EdgeInsets.all(5.0),
      //                             child: Container(
      //                               child: Row(
      //                                 children: [
      //                                   Expanded(
      //                                       flex: 1,
      //                                       child: Text("${index}.",
      //                                           style: textStyle)),
      //                                   Expanded(
      //                                     flex: 1,
      //                                     child: Text(
      //                                         snapshot.data!.docs[index]
      //                                         ["name"] != null || snapshot.data!.docs[index]
      //                                         ["name"] != '' ? snapshot.data!.docs[index]
      //                                             ["name"] : 'No name',
      //                                         style: textStyle),
      //                                   ),
      //                                   Expanded(
      //                                     flex: 1,
      //                                     child: InkWell(
      //                                       hoverColor: Colors.blueAccent,
      //                                       onTap: () {
      //                                         launch(snapshot.data!.docs[index]
      //                                             ["link"]);
      //                                       },
      //                                       child: Text(
      //                                           snapshot.data!.docs[index]
      //                                               ["filename"],
      //                                           style: textStyle),
      //                                     ),
      //                                   ),
      //                                   Expanded(
      //                                       flex: 1,
      //                                       child: Text(
      //                                           DateFormat('yyyy-MM-dd')
      //                                               .format(date),
      //                                           style: textStyle)),
      //                                 ],
      //                               ),
      //                             ),
      //                           );
      //                         },
      //                       );
      //                     } else if(snapshot.hasError) {
      //                       return Container(child: Text('There is an error.'),);
      //                     } else if(!snapshot.hasData) {
      //                       return Center(child: CircularProgressIndicator());
      //                     }
      //                     return Container();
      //                   },
      //                 )),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
