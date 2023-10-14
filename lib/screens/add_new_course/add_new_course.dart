import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'addnewcourse_controller.dart';

class AddNewCourseScreen extends StatefulWidget {
  const AddNewCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCourseScreen> createState() => _AddNewCourseScreenState();
}

class _AddNewCourseScreenState extends State<AddNewCourseScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final horizontalBox = SizedBox(
    width: 10.sp,
  );
  final verticalBox = SizedBox(
    height: 15.sp,
  );
  final decoratedField = InputDecoration(
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.purpleAccent, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.purpleAccent)),
      labelStyle: TextStyle(color: Colors.purple),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2)));

  final courseName = TextEditingController();
  final amountPayable = TextEditingController();
  final coursePrice = TextEditingController();
  final discountPrice = TextEditingController();
  final courseIDE = TextEditingController();
  // final firstModuleId = TextEditingController();
  final firstModuleName = TextEditingController();
  final descriptionOfCourse = TextEditingController();
  final duration = TextEditingController();
  final videosCount = TextEditingController();
  List<String> listOfCourse = [];
  bool autoValidate = true;
  bool isItCombo = false;
  bool isItDemo = false;
  bool isItPaid = false;
  bool show = false;
  bool isItTrialCourse = false;

  String? fileName;
  Uint8List? uploadedFile;
  String? titleMessage;

  String? filePath;
  String comments = '';
  bool isSubmitted = false;

  Future getFile() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any
      );
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedFile = uploadFile;
          fileName = pickedFileName;
        });

        if (uploadedFile != null) {
          Fluttertoast.showToast(msg: 'Your file is attached');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  List<String> courseNames = [];
  List<String> courseIds = [];

  final addController = Get.put(AddController());




final selectedIndex = 0.obs;
  Set<int> selectedIndices = Set<int>().obs;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> _selected = List.generate(courseNames.length, (i) => false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add new course'),
          centerTitle: true,
          elevation: 2,
          backgroundColor: MyColors.primaryColor,
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: Adaptive.w(100),
          margin: EdgeInsets.only(left: 50.sp, right: 50.sp),
          child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: courseName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name of course';
                            }
                          },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter Course Name'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: amountPayable,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter amount';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter Amount Payable'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: coursePrice,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter course price';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter Course Price'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: discountPrice,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter discount price';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter Discount Price'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: courseIDE,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Course ID';
                            }
                          },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter Course ID'),
                        )),
                    // verticalBox,
                    // SizedBox(
                    //     width: Adaptive.w(40),
                    //     child: TextFormField(
                    //       controller: firstModuleId,
                    //       autovalidateMode: AutovalidateMode.onUserInteraction,
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'Please enter First Module ID';
                    //         }
                    //       },
                    //       decoration: decoratedField.copyWith(
                    //           labelText: 'Enter First Module ID of Course'),
                    //     )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: firstModuleName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter First Module Name';
                            }
                          },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter First Module Name'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: descriptionOfCourse,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter description of Course';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter description of Course'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: duration,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter duration of Course';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText: 'Enter duration of Course'),
                        )),
                    verticalBox,
                    SizedBox(
                        width: Adaptive.w(40),
                        child: TextFormField(
                          controller: videosCount,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            IntegerInputFormatter()
                          ],
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter video count of Course (Only Number)';
                          //   }
                          // },
                          decoration: decoratedField.copyWith(
                              labelText:
                                  'Enter videos count of Course (Only Number)'),
                        )),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                getFile();
                          }, child: Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primaryColor
                          )),
                          Text(uploadedFile != null ? 'Updated' : '', style: TextStyle(color: MyColors.primaryColor),)
                        ],
                      ),
                    ),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Is it combo course?',
                            style: textStyle,
                          ),
                          Spacer(),
                          Obx(
                                  () {
                              return Switch(
                                  value: addController.isItCombo.value,
                                  onChanged: (value) {
                                    addController.getCoursesIds();
                                    addController.getBools(courseNames);
                                    addController.checkIfCombo(!addController.isItCombo.value);
                                    setState(() {

                                    });
                                  });
                            }
                          ),
                        ],
                      ),
                    ),
                    addController.isItCombo.isTrue ?  SizedBox(
                      width: Adaptive.w(40),
                      child: GetBuilder<AddController>(
                        builder: (controller) {

                          return Column(
                            children: List.generate(controller.courseNames.length, (index) {
                              final isSelected = selectedIndices.contains(index);
                              return ListTile(
                                tileColor: isSelected ? Colors.blue : Colors.white,
                                title: Text(controller.courseNames[index]),
                                subtitle: Text(controller.courseIds[index]),
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedIndices.remove(index);
                                    } else {
                                      selectedIndices.add(index);
                                    }
                                  });


                                  List<int> newList = selectedIndices.toList();
                                   newList.forEach((element) {listOfCourse.add(controller.courseIds[element]);});
                                  Set<String> mySetWithoutDuplicates = Set.from(listOfCourse);
                                  List<String> myListWithoutDuplicates = mySetWithoutDuplicates.toList();
                                  listOfCourse = myListWithoutDuplicates;

                                },
                              );
                            }),
                          );
                        }
                      ),
                    ) : Container(),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Is it demo course?',
                            style: textStyle,
                          ),
                          Spacer(),
                          Switch(
                              value: isItDemo,
                              onChanged: (value) {
                                isItDemo = value;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Is it paid course?',
                            style: textStyle,
                          ),
                          Spacer(),
                          Switch(
                              value: isItPaid,
                              onChanged: (value) {
                                isItPaid = value;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Show course?',
                            style: textStyle,
                          ),
                          Spacer(),
                          Switch(
                              value: show,
                              onChanged: (value) {
                                show = value;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                    verticalBox,
                    SizedBox(
                      width: Adaptive.w(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Is it trial course?',
                            style: textStyle,
                          ),
                          Spacer(),
                          Switch(
                              value: isItTrialCourse,
                              onChanged: (value) {
                                isItTrialCourse = value;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                    verticalBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: 45.sp,
                          onPressed: () async {

                            if(uploadedFile == null || uploadedFile!.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please upload an image.');
                            }

                            if (formKey.currentState!.validate() && uploadedFile != null) {
                              print('Working on validation ${formKey.currentState!.validate()}');
                              await addCourse();
                              clearFields();
                              Fluttertoast.showToast(msg: 'Course updated');
                            } else {
                              print('Validation failed ${formKey.currentState!.validate()}');
                            }
                          },
                          height: 22.sp,
                          color: Colors.purpleAccent,
                          child: Text('Submit'),
                        ),
                        horizontalBox,
                        MaterialButton(
                          minWidth: 45.sp,
                          onPressed: () {
                            clearFields();
                          },
                          height: 22.sp,
                          color: Colors.grey,
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                    verticalBox
                  ],
                ),
              )),
        ));
  }

  final textStyle = TextStyle(color: Colors.purpleAccent, fontSize: 14.sp);

  addCourse() async {
      try {
        if (uploadedFile == null) {
          Fluttertoast.showToast(msg: 'Please Select File');
        } else {
          var storageRef = FirebaseStorage.instance
              .ref()
              .child('Course Images')
              .child(fileName!);

          final UploadTask uploadTask = storageRef.putData(uploadedFile!);

          final TaskSnapshot downloadUrl = await uploadTask;
          final String fileURL = (await downloadUrl.ref.getDownloadURL());
          print('Resume Download link :  $fileURL');
          DocumentReference docRef =
          await FirebaseFirestore.instance.collection('courses').add({
            'name': courseName.text,
            'Amount Payable': amountPayable.text,
            'Amount_Payablepay': amountPayable.text,
            'Course Price': coursePrice.text,
            'Discount': discountPrice.text,
            'combo': addController.isItCombo.value,
            'courseContent': 'video',
            'created by': 'Akash Raj',
            'curriculum': {},
            'courses': listOfCourse,

            'curriculum1': {
              courseName.text: [
                {
                  'id': courseIDE.text + 'M1',
                  'modulename': firstModuleName.text,
                  'sr': 0,
                  'videos': [],
                },
              ],
            },
            'mentors': [
              'jbG4j36JiihVuZmpoLov2lhrWF02',
              'QVtxxzHyc6az2LPpvH210lUOeXl1',
              '2AS3AK7WVQaAMY999D3xf5ycG3h1',
              'a2WWgtY2ikS8xjCxra0GEfRft5N2',
              'BX9662ZGi4MfO4C9CvJm4u2JFo63',
              '6RsvdRETWmXf1pyVGqCUl0qEDmF2',
              'jeYDhaZCRWW4EC9qZ0YTHKz4PH63',
              'I6uXWtzpimTYxtGqEXcM9AXcoAi2',
              'Kr4pX5EZ6CfigOd5C1xjdIYzMml2',
              'XhcpQzd6cjXF43gCmna1agAfS2A2',
              'fKHHbDBbbySVJZu2NMAVVIYZZpu2',
              'oQQ9CrJ8FkP06OoGdrtcwSwY89q1',
              'rR0oKFMCaOYIlblKzrjYoYMW3Vl1',
              'v66PnlwqWERgcCDA6ZZLbI0mHPF2',
              'TOV5h3ezQhWGTb5cCVvBPca1Iqh1',
              '6RsvdRETWmXf1pyVGqCUl0qEDmF2'
            ],
            'demo': isItDemo,
            'description': descriptionOfCourse.text,
            'duration': duration.text,
            'gst': '18',
            'id': courseIDE.text,
            'paid': isItPaid,
            'image_url': fileURL,
            'language': 'English',
            'reviews': '4.95',
            'show': show,
            'trialCourse': isItTrialCourse,
            'trialDays': '3',
            'videosCount': int.parse(videosCount.text),
          });
          await docRef.update({'docid': docRef.id});
          addController.courseNames.value  = [];
          addController.courseIds.value  = [];
        }
      } catch (e) {
        print('addCourse $e');
        Fluttertoast.showToast(msg: 'Error adding course.');
      }
  }

  clearFields() {
    courseName.clear();
    amountPayable.clear();
    coursePrice.clear();
    discountPrice.clear();
    courseIDE.clear();
    // firstModuleId.clear();
    firstModuleName.clear();
    descriptionOfCourse.clear();
    duration.clear();
    videosCount.clear();
    isItCombo = false;
    isItDemo = false;
    isItPaid = false;
    show = false;
    isItTrialCourse = false;
    autoValidate = false;
    setState(() {});
  }
}

class IntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? parsedValue = int.tryParse(newValue.text);
    if (parsedValue == null) {
      // Return the old value if the entered text is not a valid integer
      return oldValue;
    } else {
      // Allow the change if the entered text can be parsed as an integer
      return newValue;
    }
  }
}
