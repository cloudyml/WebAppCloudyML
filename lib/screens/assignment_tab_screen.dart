import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:data_table_2/data_table_2.dart';
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
  final searchResults = [].obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final initialData = true.obs;

  Future<RxList> searchEmailInFirestore(String email) async {
    final results = [].obs;

    try {
      isLoading.value = true;
      initialData.value = false;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Query the collection for documents with the matching email
      QuerySnapshot querySnapshot = await firestore
          .collection('assignment')
          .where('email', isEqualTo: email)
          // .orderBy('date of submission', descending: true)
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


  final assignmentController = Get.put(AssignmentController());

  final finalListOfAllData = [].obs;

  @override
  void initState() {
    assignmentController.fetchAllDocuments().then((value) {
      finalListOfAllData.value = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
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
                      suffixIcon: IconButton(onPressed: () {
                        if (emailSearchController.value.text.isNotEmpty) {
                          searchEmailInFirestore(
                                  emailSearchController.value.text)
                              .then((results) {
                            searchResults.value = results;
                            isLoading.value = false;
                            isError.value = results.isEmpty;
                            emailSearchController.value.clear();
                          });
                        } else if (initialData.isFalse) {
                          initialData.value = true;
                        } else {
                          showSnackbar(context, 'Please enter an email.');
                        }
                      }, icon: Obx(() {
                        return Icon(
                          initialData.isTrue ? Icons.search : Icons.close,
                          color: MyColors.primaryColor,
                        );
                      }))),
                  onSubmitted: (text){
                    if (emailSearchController.value.text.isNotEmpty) {
                      searchEmailInFirestore(
                          emailSearchController.value.text)
                          .then((results) {
                        searchResults.value = results;
                        isLoading.value = false;
                        isError.value = results.isEmpty;
                        emailSearchController.value.clear();
                      });
                    } else if (initialData.isFalse) {
                      initialData.value = true;
                    } else {
                      showSnackbar(context, 'Please enter an email.');
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: Obx(() {
        return initialData.isTrue
            ? SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      finalListOfAllData.isEmpty ? Container(
                        height: Adaptive.h(50),
                        width: Adaptive.w(100),
                        child: Center(child: CircularProgressIndicator()),
                      ) : Container(
                        width: Adaptive.w(100),
                        child: DataTable(
                            columnSpacing: 6,
                            horizontalMargin: 6,
                            showCheckboxColumn: true,
                            dataTextStyle: TextStyle(fontSize: 11.sp),
                            border: TableBorder(
                                horizontalInside:
                                BorderSide(color: Colors.black),
                                verticalInside:
                                BorderSide(color: Colors.black)),
                            columns: [
                              DataColumn(
                                label: Text('Sr. No'),
                              ),
                              DataColumn(
                                label: Text('Mark as reviewed'),
                              ),
                              DataColumn(
                                label: Text('Student Email'),
                              ),
                              DataColumn(
                                label: Text('Student Name'),
                              ),
                              DataColumn(
                                label: Text('Submitted file'),
                              ),
                              DataColumn(
                                label: Text('Date of submission'),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                                finalListOfAllData.length, (index) {
                              // timestamp conversion to date

                              Timestamp t = finalListOfAllData[index]
                              ["date of submission"];
                              DateTime date = t.toDate();
                              return DataRow(cells: [
                                DataCell(
                                    Text('${index+1}', style: textStyle)),
                                DataCell(Checkbox(
                                  onChanged: (value) {

                                    if(finalListOfAllData[index]['reviewed'] != null) {
                                      finalListOfAllData[index]['reviewed'] = !finalListOfAllData[index]['reviewed'];
                                    } else {
                                      finalListOfAllData[index]['reviewed'] = true;
                                    }

                                    assignmentController.toggleReview(
                                        finalListOfAllData[index]['documentId'],
                                        finalListOfAllData[index]['reviewed']
                                    );
                                    setState(() {

                                    });
                                  },
                                  value: finalListOfAllData[index]['reviewed'] != null ? finalListOfAllData[index]['reviewed'] : false,
                                )),
                                DataCell(SelectableText(
                                    finalListOfAllData[index]['email'] != null ? '${finalListOfAllData[index]['email']}' : 'null')),
                                DataCell(Text(
                                    finalListOfAllData[index]['name'] != null? '${finalListOfAllData[index]['name']}' : 'null')),
                                DataCell(InkWell(
                                    onTap: () {
                                      launch(finalListOfAllData[index]["link"]);
                                    },
                                    child: Text(
                                        finalListOfAllData[index]['filename'] != null ? '${finalListOfAllData[index]['filename']}' : 'null'))),
                                DataCell(Text('$date')),
                              ]);
                            })),
                      )
                    ],
                  ),
                ),
              )
            : isLoading.isTrue
                ? Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  )
                : isError.isTrue
                    ? Center(
                        child: Text(
                            'No results found for ${emailSearchController.value.text}'))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (BuildContext context, int index) {
                          final result = searchResults.value[index];
                          Timestamp t = result["date of submission"] != null
                              ? result["date of submission"]
                              : '';
                          DateTime date = t.toDate();
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 20.sp, right: 20.sp, top: 10.sp),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp)),
                              tileColor: Colors.grey.withOpacity(0.5),
                              hoverColor: Colors.green,
                              onTap: () {
                                launch(result['link']);
                              },
                              enableFeedback: true,
                              leading:
                                  Icon(Icons.download_for_offline_outlined),
                              trailing: result["date of submission"] != null
                                  ? Text(DateFormat('yyyy-MM-dd').format(date))
                                  : Text('No date'),
                              title: Text(result['name'] != null
                                  ? result['name']
                                  : 'unknown'),
                              subtitle: Text(result['assignmentName'] != null
                                  ? result['assignmentName']
                                  : 'Assignment name'),
                              // Add more ListTile fields as needed
                            ),
                          );
                        },
                      );
      }),
    );
  }
}


class AssignmentController extends GetxController {



  Future<RxList> fetchAllDocuments() async {
    final assignmentDataList = [].obs;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Query the collection for documents with the matching email
      QuerySnapshot querySnapshot = await firestore
          .collection('assignment')
          .orderBy('date of submission', descending: true)
          .limit(500)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 2. Update each document with its own ID
        await firestore.collection('assignment').doc(doc.id).update({'documentId': doc.id});
      }

      querySnapshot.docs.forEach((doc) {
        assignmentDataList.add(doc.data() as Map<String, dynamic>);
      });
      return assignmentDataList;
    } catch (e) {
      print('Error fetchAllDocuments: $e');
      return assignmentDataList; // Return an empty list in case of an error
    }
  }


  toggleReview(String? id, reviewed) async {

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Query the collection for documents with the matching email
      QuerySnapshot querySnapshot = await firestore
          .collection('assignment')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if(doc.id == id) {
          await firestore.collection('assignment')
              .doc(doc.id)
              .update({'reviewed': reviewed});
        }
      }
    } catch (e) {
      print('Error toggleReviewtoggleReview: $e');
    }
  }


}