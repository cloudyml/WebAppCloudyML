import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';

class AddDailyQuizQuestionScreen extends StatelessWidget {
   AddDailyQuizQuestionScreen();

  final controllers = List.generate(4, (index) => TextEditingController().obs);
  final questionController = TextEditingController().obs;
   final answerController = TextEditingController().obs;
   var listOfAllQuestions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily quiz question"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: Colors.purple,
              controller: questionController.value,
              decoration: InputDecoration(
                  labelText: "Question",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Colors.purple)
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 40.w,
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: TextField(
                      cursorColor: Colors.purple,
                      controller: controllers[index].value,
                      decoration: InputDecoration(
                        labelText: hintText[index],
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(color: Colors.purple)
                        )
                      ),
                    ),
                  ),
                );
              }),
            ),
            TextField(
              cursorColor: Colors.purple,
              controller: answerController.value,
              decoration: InputDecoration(
                  labelText: "Answer",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Colors.purple)
                  )
              ),
            ),
            SizedBox(height: 15.sp,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: (){
                      clearAllFields();
                }, child: Text("Clear all")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    onPressed: () async {
                      final isOptionsFilled = false.obs;
                      for(var value in controllers) {
                        isOptionsFilled.value = value.value.text.isNotEmpty;
                      }
                      if(isOptionsFilled.isTrue) {

                        if(questionController.value.text.isNotEmpty && answerController.value.text.isNotEmpty) {
                          await getListOfQuestions();
                          String questionID = UniqueKey().toString();
                          List options = controllers.map((e) => e.value.text).toList();
                          updateQuestion(
                              question: questionController.value.text,
                              answer: answerController.value.text,
                              options: options,
                              listOfAllQuestions: listOfAllQuestions,
                              questionID: questionID
                          );
                          clearAllFields();
                        } else {
                          Toast.show("Please fill all the given fields.");
                        }
                      } else {
                        Toast.show("Please fill all the options.");
                      }
                }, child: Text("Submit"))
              ],
            )
          ],
        ),
      ),
    );
  }

  clearAllFields(){
    questionController.value.clear();
    answerController.value.clear();
    for(var value in controllers) {
      value.value.clear();
    }
  }

  List hintText = [
    "Option A",
    "Option B",
    "Option C",
    "Option D"
  ];

  getListOfQuestions() async {
    try{
      await FirebaseFirestore.instance.collection("daily_quiz_question")
          .doc("question")
          .get().then((value) {
            if(value.data()!["listOfAllQuestions"] != null) {
              listOfAllQuestions = value.data()!["listOfAllQuestions"];
            }
      });
    }catch(e){
      print("getListOfQuestions $e");
    }
  }

  updateQuestion({
    required String question,
    required String answer,
    required List options,
    required List listOfAllQuestions,
    required String questionID
}) async {
    try{

      listOfAllQuestions.add({
        "question": question,
        "answers": options,
        "answer": answer,
        "questionID": questionID,
      });

      await FirebaseFirestore.instance.collection("daily_quiz_question")
          .doc("question").update({
        "question": question,
        "answers": options,
        "answer": answer,
        "questionID": questionID,
        "listOfAllQuestions": listOfAllQuestions,     
        "notificationTime": DateTime.now().add(Duration(seconds: 15))

      }).whenComplete(() {
        Toast.show("Question updated.");
      });
    }catch(e){
      print("updateQuestion - $e");
    }
  }

}
