import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/global_variable.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:cloudyml_app2/screens/quiz/state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../../global_variable.dart' as globals;
import '../flutter_flow/flutter_flow_theme.dart';

class AdminQuizPanel extends StatefulWidget {
  const AdminQuizPanel({Key? key}) : super(key: key);

  @override
  _AdminQuizPanelState createState() => _AdminQuizPanelState();
}

class _AdminQuizPanelState extends State<AdminQuizPanel> {
  TextEditingController? quizrankcontroller;
  TextEditingController? numberofattempt;
  TextEditingController? coursenamecontroller;
  TextEditingController? timecontroller;
  TextEditingController? quizIdController;
  TextEditingController? moduleNameController;
  TextEditingController? NegativeMarkingController;
  TextEditingController? typeController;
  TextEditingController? questionNumber;
  TextEditingController? questioncontroller;
  TextEditingController? Option1;
  TextEditingController? Option2;
  TextEditingController? Option3;
  TextEditingController? Option4;
  TextEditingController? AnswerController;
  TextEditingController? SolutionController;
  TextEditingController? AnswerIndexController;
  TextEditingController? quiznameController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List enabledList = [];
  var tempquiz;
  bool showupdatebutton = false;
  var courselist;
  var modulelist;
  var courseMap;
  List tempmodulelist = ["Module Name"];
  var tempmodulename = "Module Name";
  var tempcoursename = "Course Name";
  bool isSwitched = false;

  var textValue = 'Scholarship Quiz    ';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Scholarship Quiz    ';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Scholarship Quiz    ';
      });
      print('Scholarship Quiz');
    }
  }

  bool loading = false;

  @override
  void initState() {
    super.initState();
    globals.courseList = ["Course Name"];
    getallcoursename();
    questionNumber = TextEditingController();
    questioncontroller = TextEditingController();
    Option1 = TextEditingController();
    Option2 = TextEditingController();
    numberofattempt = TextEditingController();
    Option3 = TextEditingController();
    Option4 = TextEditingController();
    coursenamecontroller = TextEditingController();
    AnswerController = TextEditingController();
    SolutionController = TextEditingController();
    AnswerIndexController = TextEditingController();
    quiznameController = TextEditingController();
    quizrankcontroller = TextEditingController();
    timecontroller = TextEditingController();
    quizIdController = TextEditingController();
    moduleNameController = TextEditingController();
    NegativeMarkingController = TextEditingController();
    typeController = TextEditingController();

    modulelist = globals.moduleList;
  }

  getallcoursename() async {
    setState(() {
      loading = true;
    });
    try {
      courseMap = {};
      await FirebaseFirestore.instance
          .collection('courses')
          .get()
          .then((value) {
        try {
          List tepcourse = [];
          value.docs.forEach((element) {
            try {
              for (var k in element['curriculum1']['${element['name']}']) {
                print('start3');
                try {
                  print('start4');
                  tepcourse.add(k['modulename']);
                  print('start5');
                } catch (e) {
                  print('start6');
                  print("error lll $e");
                }
              }
            } catch (e) {
              print("start error ${e}");
            }

            try {
              print('start7');
              globals.coursemoduelmap["${element['name']}"] = tepcourse;
              print('start8');
              globals.courseList.add(element['name']);
              print('start9');
              tepcourse = [];
            } catch (e) {
              print("error hhh $e");
            }
          });
        } catch (e) {
          print("error kkkl $e");
        }
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      globals.courseList;
    });
    }

  @override
  void dispose() {
    _unfocusNode.dispose();
    quizrankcontroller?.dispose();
    timecontroller?.dispose();
    quizIdController?.dispose();
    moduleNameController?.dispose();
    NegativeMarkingController?.dispose();
    typeController?.dispose();
    numberofattempt?.dispose();
    questionNumber?.dispose();
    questioncontroller?.dispose();
    Option1?.dispose();
    coursenamecontroller?.dispose();
    Option2?.dispose();
    Option3?.dispose();
    Option4?.dispose();
    AnswerController?.dispose();
    SolutionController?.dispose();
    AnswerIndexController?.dispose();
    quiznameController?.dispose();
    super.dispose();
  }

  String generateId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  List questionslist = [];
  var items = ['Global quiz', 'Modular quiz'];
  var tempitemsvalue = 'Global quiz';
  var itemsquiztype = [
    'One correct option',
    'Two correct option',
    'Multiple correct option'
  ];
  var tempitemsquiz = 'One correct option';

  navigatefun(BuildContext context) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Home()));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatefun(
          context,
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: loading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Align(
                    alignment: AlignmentDirectional(-0.05, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 205,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 30, 10, 10),
                                      child: TextFormField(
                                        controller: quiznameController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          hintText: 'Quiz Name',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDBE2E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDBE2E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 24, 20, 24),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF1D2429),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                        maxLines: null,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 20),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(5, 5, 5, 5),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.88,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  15, 5, 5, 5),
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              questionslist
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            // return Container();
                                                            return GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "hhhhhhhhh:index $index.. ${questionslist}");
                                                                try {
                                                                  tempquiz =
                                                                      index;
                                                                  print(
                                                                      "hhhhhhhhh:1");
                                                                  questioncontroller
                                                                      ?.text = questionslist[
                                                                          index]
                                                                      [
                                                                      'question'];
                                                                  print('1..');
                                                                  try {
                                                                    if (questionslist[index]
                                                                            [
                                                                            'questionImage'] !=
                                                                        '') {
                                                                      print(
                                                                          '2..');
                                                                      FFAppState()
                                                                          .editImage = questionslist[
                                                                              index]
                                                                          [
                                                                          'questionImage'];
                                                                      print(
                                                                          '3..');
                                                                    } else {
                                                                      FFAppState()
                                                                          .editImage = '';
                                                                      print(
                                                                          '4..');
                                                                    }
                                                                  } catch (e) {
                                                                    print(e);
                                                                    FFAppState()
                                                                        .editImage = '';
                                                                  }
                                                                  try {
                                                                    print(
                                                                        "iwjoiwjoeij/");
                                                                    print(FFAppState()
                                                                        .optionaimage);
                                                                    print(
                                                                        '4..');
                                                                    print(questionslist[
                                                                            index]
                                                                        [
                                                                        'OptionsImage']['A']);
                                                                    print(
                                                                        '5..');
                                                                    if (questionslist[index]['OptionsImage']
                                                                            [
                                                                            'A'] !=
                                                                        '') {
                                                                      print(
                                                                          '6..');
                                                                      FFAppState()
                                                                          .optionaimage = questionslist[index]
                                                                              [
                                                                              'OptionsImage']
                                                                          ['A'];
                                                                      print(
                                                                          '7..');
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        FFAppState().optionaimage =
                                                                            '';
                                                                        print(
                                                                            '8..');
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      FFAppState()
                                                                          .optionaimage = '';
                                                                      print(
                                                                          '9..');
                                                                    });
                                                                    print(
                                                                        "oiejfow id iojow $e");
                                                                  }

                                                                  try {
                                                                    print(
                                                                        "iwjoiwjoeij/");
                                                                    print(FFAppState()
                                                                        .optionbimage);
                                                                    print(
                                                                        '11..');
                                                                    print(questionslist[
                                                                            index]
                                                                        [
                                                                        'OptionsImage']['B']);
                                                                    print(
                                                                        '12..');
                                                                    if (questionslist[index]['OptionsImage']
                                                                            [
                                                                            'B'] !=
                                                                        '') {
                                                                      FFAppState()
                                                                          .optionbimage = questionslist[index]
                                                                              [
                                                                              'OptionsImage']
                                                                          ['B'];
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        FFAppState().optionbimage =
                                                                            '';
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      FFAppState()
                                                                          .optionbimage = '';
                                                                    });
                                                                    print(
                                                                        "oiejfow id iojow $e");
                                                                  }

                                                                  try {
                                                                    print(
                                                                        "iwjoiwjoeij/");
                                                                    print(FFAppState()
                                                                        .optioncimage);
                                                                    print(questionslist[
                                                                            index]
                                                                        [
                                                                        'OptionsImage']['C']);
                                                                    if (questionslist[index]['OptionsImage']
                                                                            [
                                                                            'C'] !=
                                                                        '') {
                                                                      FFAppState()
                                                                          .optioncimage = questionslist[index]
                                                                              [
                                                                              'OptionsImage']
                                                                          ['C'];
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        FFAppState().optioncimage =
                                                                            '';
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      FFAppState()
                                                                          .optioncimage = '';
                                                                    });
                                                                    print(
                                                                        "oiejfow id iojow $e");
                                                                  }

                                                                  try {
                                                                    print(
                                                                        "iwjoiwjoeij/");
                                                                    print(FFAppState()
                                                                        .optiondimage);
                                                                    print(questionslist[
                                                                            index]
                                                                        [
                                                                        'OptionsImage']['D']);
                                                                    if (questionslist[index]['OptionsImage']
                                                                            [
                                                                            'D'] !=
                                                                        '') {
                                                                      FFAppState()
                                                                          .optiondimage = questionslist[index]
                                                                              [
                                                                              'OptionsImage']
                                                                          ['D'];
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        FFAppState().optiondimage =
                                                                            '';
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      FFAppState()
                                                                          .optiondimage = '';
                                                                    });
                                                                    print(
                                                                        "oiejfow id iojow $e");
                                                                  }

                                                                  Option1?.text =
                                                                      questionslist[index]
                                                                              [
                                                                              'options']
                                                                          ['A'];
                                                                  Option2?.text =
                                                                      questionslist[index]
                                                                              [
                                                                              'options']
                                                                          ['B'];
                                                                  Option3?.text =
                                                                      questionslist[index]
                                                                              [
                                                                              'options']
                                                                          ['C'];
                                                                  Option4?.text =
                                                                      questionslist[index]
                                                                              [
                                                                              'options']
                                                                          ['D'];
                                                                  SolutionController
                                                                      ?.text = questionslist[
                                                                          index]
                                                                      [
                                                                      'solution'];

                                                                  print(questionslist[
                                                                      index]);
                                                                  print(questionslist[
                                                                          index]
                                                                      [
                                                                      'solution']);
                                                                  print(
                                                                      "hhhhhhhhh:2");
                                                                  print(
                                                                      "hhhhhhhhh:3");
                                                                  setState(() {
                                                                    showupdatebutton =
                                                                        true;
                                                                  });
                                                                  setState(() {
                                                                    enabledList =
                                                                        questionslist[index]
                                                                            [
                                                                            'answerIndex'];
                                                                    print(questionslist[
                                                                            index]
                                                                        [
                                                                        'answerIndex']);
                                                                  });
                                                                } catch (e) {
                                                                  print(e
                                                                      .toString());
                                                                  setState(() {
                                                                    showupdatebutton =
                                                                        true;
                                                                  });
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20,
                                                                        0,
                                                                        20,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  height: 180,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: tempquiz ==
                                                                            index
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            109,
                                                                            189,
                                                                            235)
                                                                        : Color.fromARGB(
                                                                            255,
                                                                            238,
                                                                            232,
                                                                            232),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -0.5,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'Question ${index + 1}',
                                                                            style:
                                                                                FlutterFlowTheme.of(context).bodyText1,
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            questionslist.removeAt(index);
                                                                            setState(() {
                                                                              questionslist;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.close_rounded,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FFAppState().editImage == ''
                                      ? Container()
                                      : SizedBox(
                                          height: 400,
                                          width: 600,
                                          child: Image.network(
                                              FFAppState().editImage),
                                        ),
                                  Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ElevatedButton(
                                          child: Text('UPLOAD FILE'),
                                          onPressed: () async {
                                            var picked = await FilePicker
                                                .platform
                                                .pickFiles();
                                            // upload picked image to firebase storage
                                            FirebaseStorage storage =
                                                FirebaseStorage.instance;
                                            Reference ref = storage.ref().child(
                                                'questionimage/${DateTime.now().microsecond}${picked!.files.first.name}.jpg');
                                            UploadTask uploadTask = ref.putData(
                                                picked.files.first.bytes!);
                                            uploadTask.then((res) {
                                              res.ref
                                                  .getDownloadURL()
                                                  .then((value) {
                                                print("Done: $value");
                                                setState(() {
                                                  FFAppState().editImage =
                                                      value;
                                                });
                                              });
                                            });

                                            if (picked != null) {
                                              print(picked.files.first.name);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          child: Text('Delete Image'),
                                          onPressed: () async {
                                            setState(() {
                                              FFAppState().editImage = '';
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  //
                                  // QuillHtmlEditor(
                                  //     height: 300,
                                  //     isEnabled: false,
                                  //     editorKey: keyEditor),
                                  // GestureDetector(
                                  //     onTap: () async{
                                  //       print(await keyEditor.currentState!.isEnabled);
                                  //     },
                                  //     child:
                                  // //         Text('Answer ${keyEditor.currentState}')),
                                  // Container(
                                  //   height: 500,
                                  //   child: HtmlEditor(
                                  //     controller: htmlcontroller, //required
                                  //     htmlEditorOptions: HtmlEditorOptions(
                                  //       autoAdjustHeight: false,
                                  //       hint: "Your text here...",
                                  //       //initalText: "text content initial, if any",
                                  //     ),
                                  //     otherOptions: OtherOptions(
                                  //       height: 800,
                                  //       decoration: BoxDecoration(
                                  //         color: FlutterFlowTheme.of(context)
                                  //             .secondaryBackground,
                                  //         borderRadius: BorderRadius.circular(8),

                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 300,
                                          height: 355,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 40, 35, 0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: 355,
                                              child: TextFormField(
                                                controller: questioncontroller,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText: 'Question...',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyText2,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          0, 0, 0, 0),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                                textAlign: TextAlign.start,
                                                maxLines: 30,
                                                minLines: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 20, 0, 0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (enabledList
                                                                    .contains(
                                                                        "A")) {
                                                                  enabledList
                                                                      .remove(
                                                                          "A");
                                                                } else {
                                                                  enabledList
                                                                      .add("A");
                                                                }
                                                              });
                                                            },
                                                            child: Align(
                                                                child: enabledList
                                                                        .contains(
                                                                            "A")
                                                                    ? Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            212,
                                                                            114),
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .circle_outlined,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            128,
                                                                            125),
                                                                      )),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                height: 162.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          10,
                                                                          35,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          Option1,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'A',
                                                                        hintStyle:
                                                                            FlutterFlowTheme.of(context).bodyText2,
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: enabledList.contains("A")
                                                                                ? Color.fromARGB(255, 45, 212, 114)
                                                                                : Color(0xFFDBE2E7),
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          30,
                                                                      minLines:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              FFAppState().optionaimage ==
                                                                      ''
                                                                  ? Container()
                                                                  : SizedBox(
                                                                      height:
                                                                          400,
                                                                      width:
                                                                          600,
                                                                      child: Image.network(
                                                                          FFAppState()
                                                                              .optionaimage),
                                                                    ),
                                                              Center(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'UPLOAD FILE'),
                                                                      onPressed:
                                                                          () async {
                                                                        var picked = await FilePicker
                                                                            .platform
                                                                            .pickFiles();
                                                                        // upload picked image to firebase storage
                                                                        FirebaseStorage
                                                                            storage =
                                                                            FirebaseStorage.instance;
                                                                        Reference
                                                                            ref =
                                                                            storage.ref().child('optionSimage/${DateTime.now().microsecond}${picked!.files.first.name}.jpg');
                                                                        UploadTask uploadTask = ref.putData(picked
                                                                            .files
                                                                            .first
                                                                            .bytes!);
                                                                        uploadTask
                                                                            .then((res) {
                                                                          res.ref
                                                                              .getDownloadURL()
                                                                              .then((value) {
                                                                            print("Done: $value");
                                                                            setState(() {
                                                                              FFAppState().optionaimage = value;
                                                                            });
                                                                          });
                                                                        });

                                                                        if (picked !=
                                                                            null) {
                                                                          print(picked
                                                                              .files
                                                                              .first
                                                                              .name);
                                                                        }
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'Delete Image'),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          FFAppState().optionaimage =
                                                                              '';
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (enabledList
                                                                    .contains(
                                                                        "B")) {
                                                                  enabledList
                                                                      .remove(
                                                                          "B");
                                                                } else {
                                                                  enabledList
                                                                      .add("B");
                                                                }
                                                              });
                                                            },
                                                            child: Align(
                                                                child: enabledList
                                                                        .contains(
                                                                            "B")
                                                                    ? Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            212,
                                                                            114),
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .circle_outlined,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            128,
                                                                            125),
                                                                      )),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                height: 162.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          35,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          Option2,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'B',
                                                                        hintStyle:
                                                                            FlutterFlowTheme.of(context).bodyText2,
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: enabledList.contains("B")
                                                                                ? Color.fromARGB(255, 45, 212, 114)
                                                                                : Color(0xFFDBE2E7),
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          30,
                                                                      minLines:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //
                                                              FFAppState().optionbimage ==
                                                                      ''
                                                                  ? Container()
                                                                  : SizedBox(
                                                                      height:
                                                                          400,
                                                                      width:
                                                                          600,
                                                                      child: Image.network(
                                                                          FFAppState()
                                                                              .optionbimage),
                                                                    ),
                                                              Center(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'UPLOAD FILE'),
                                                                      onPressed:
                                                                          () async {
                                                                        var picked = await FilePicker
                                                                            .platform
                                                                            .pickFiles();
                                                                        // upload picked image to firebase storage
                                                                        FirebaseStorage
                                                                            storage =
                                                                            FirebaseStorage.instance;
                                                                        Reference
                                                                            ref =
                                                                            storage.ref().child('optionSimage/${DateTime.now().microsecond}${picked!.files.first.name}.jpg');
                                                                        UploadTask uploadTask = ref.putData(picked
                                                                            .files
                                                                            .first
                                                                            .bytes!);
                                                                        uploadTask
                                                                            .then((res) {
                                                                          res.ref
                                                                              .getDownloadURL()
                                                                              .then((value) {
                                                                            print("Done: $value");
                                                                            setState(() {
                                                                              FFAppState().optionbimage = value;
                                                                            });
                                                                          });
                                                                        });

                                                                        if (picked !=
                                                                            null) {
                                                                          print(picked
                                                                              .files
                                                                              .first
                                                                              .name);
                                                                        }
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'Delete Image'),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          FFAppState().optionbimage =
                                                                              '';
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ], //
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (enabledList
                                                                    .contains(
                                                                        "C")) {
                                                                  enabledList
                                                                      .remove(
                                                                          "C");
                                                                } else {
                                                                  enabledList
                                                                      .add("C");
                                                                }
                                                              });
                                                            },
                                                            child: Align(
                                                                child: enabledList
                                                                        .contains(
                                                                            "C")
                                                                    ? Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            212,
                                                                            114),
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .circle_outlined,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            128,
                                                                            125),
                                                                      )),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                height: 162.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          10,
                                                                          35,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          Option3,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'C',
                                                                        hintStyle:
                                                                            FlutterFlowTheme.of(context).bodyText2,
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: enabledList.contains("C")
                                                                                ? Color.fromARGB(255, 45, 212, 114)
                                                                                : Color(0xFFDBE2E7),
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          30,
                                                                      minLines:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              FFAppState().optioncimage ==
                                                                      ''
                                                                  ? Container()
                                                                  : SizedBox(
                                                                      height:
                                                                          400,
                                                                      width:
                                                                          600,
                                                                      child: Image.network(
                                                                          FFAppState()
                                                                              .optioncimage),
                                                                    ),
                                                              Center(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'UPLOAD FILE'),
                                                                      onPressed:
                                                                          () async {
                                                                        var picked = await FilePicker
                                                                            .platform
                                                                            .pickFiles();
                                                                        // upload picked image to firebase storage
                                                                        FirebaseStorage
                                                                            storage =
                                                                            FirebaseStorage.instance;
                                                                        Reference
                                                                            ref =
                                                                            storage.ref().child('optionSimage/${DateTime.now().microsecond}${picked!.files.first.name}.jpg');
                                                                        UploadTask uploadTask = ref.putData(picked
                                                                            .files
                                                                            .first
                                                                            .bytes!);
                                                                        uploadTask
                                                                            .then((res) {
                                                                          res.ref
                                                                              .getDownloadURL()
                                                                              .then((value) {
                                                                            print("Done: $value");
                                                                            setState(() {
                                                                              FFAppState().optioncimage = value;
                                                                            });
                                                                          });
                                                                        });

                                                                        if (picked !=
                                                                            null) {
                                                                          print(picked
                                                                              .files
                                                                              .first
                                                                              .name);
                                                                        }
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'Delete Image'),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          FFAppState().optioncimage =
                                                                              '';
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (enabledList
                                                                    .contains(
                                                                        "D")) {
                                                                  enabledList
                                                                      .remove(
                                                                          "D");
                                                                } else {
                                                                  enabledList
                                                                      .add("D");
                                                                }
                                                              });
                                                            },
                                                            child: Align(
                                                                child: enabledList
                                                                        .contains(
                                                                            "D")
                                                                    ? Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            212,
                                                                            114),
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .circle_outlined,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            128,
                                                                            125),
                                                                      )),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                height: 162.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          35,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          Option4,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'D',
                                                                        hintStyle:
                                                                            FlutterFlowTheme.of(context).bodyText2,
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: enabledList.contains("D")
                                                                                ? Color.fromARGB(255, 45, 212, 114)
                                                                                : Color(0xFFDBE2E7),
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          30,
                                                                      minLines:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              FFAppState().optiondimage ==
                                                                      ''
                                                                  ? Container()
                                                                  : SizedBox(
                                                                      height:
                                                                          400,
                                                                      width:
                                                                          600,
                                                                      child: Image.network(
                                                                          FFAppState()
                                                                              .optiondimage),
                                                                    ),
                                                              Center(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'UPLOAD FILE'),
                                                                      onPressed:
                                                                          () async {
                                                                        var picked = await FilePicker
                                                                            .platform
                                                                            .pickFiles();
                                                                        // upload picked image to firebase storage
                                                                        FirebaseStorage
                                                                            storage =
                                                                            FirebaseStorage.instance;
                                                                        Reference
                                                                            ref =
                                                                            storage.ref().child('optionSimage/${DateTime.now().microsecond}${picked!.files.first.name}.jpg');
                                                                        UploadTask uploadTask = ref.putData(picked
                                                                            .files
                                                                            .first
                                                                            .bytes!);
                                                                        uploadTask
                                                                            .then((res) {
                                                                          res.ref
                                                                              .getDownloadURL()
                                                                              .then((value) {
                                                                            print("Done: $value");
                                                                            setState(() {
                                                                              FFAppState().optiondimage = value;
                                                                            });
                                                                          });
                                                                        });

                                                                        if (picked !=
                                                                            null) {
                                                                          print(picked
                                                                              .files
                                                                              .first
                                                                              .name);
                                                                        }
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          'Delete Image'),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          FFAppState().optiondimage =
                                                                              '';
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 0, 0),
                                            child: Container(
                                              width: 300,
                                              height: 370,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 20, 20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      height: 325,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 20,
                                                                    0, 0),
                                                        child: Container(
                                                          width: 600,
                                                          height: 325,
                                                          child: TextFormField(
                                                            controller:
                                                                SolutionController,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Solution',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText2,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xFFDBE2E7),
                                                                  width: 2,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4.0),
                                                                ),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00000000),
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4.0),
                                                                ),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00000000),
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4.0),
                                                                ),
                                                              ),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 30,
                                                            minLines: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        showupdatebutton
                                            ? Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                90, 0, 0, 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        List answersList = [];
                                                        for (var i
                                                            in enabledList) {
                                                          if (i == 'A') {
                                                            answersList.add(
                                                                Option1!.text);
                                                          }
                                                          if (i == 'B') {
                                                            answersList.add(
                                                                Option2!.text);
                                                          }
                                                          if (i == 'C') {
                                                            answersList.add(
                                                                Option3!.text);
                                                          }
                                                          if (i == 'D') {
                                                            answersList.add(
                                                                Option4!.text);
                                                          }
                                                        }

                                                        questionslist[
                                                            tempquiz] = {
                                                          'questionImage':
                                                              FFAppState()
                                                                  .editImage,
                                                          'question':
                                                              questioncontroller
                                                                  ?.text,
                                                          'OptionsImage': {
                                                            'A': FFAppState()
                                                                .optionaimage,
                                                            'B': FFAppState()
                                                                .optionbimage,
                                                            'C': FFAppState()
                                                                .optioncimage,
                                                            'D': FFAppState()
                                                                .optiondimage,
                                                          },
                                                          'options': {
                                                            'A': Option1?.text,
                                                            'B': Option2?.text,
                                                            'C': Option3?.text,
                                                            'D': Option4?.text,
                                                          },
                                                          'solution':
                                                              SolutionController
                                                                  ?.text,
                                                          'answer': answersList,
                                                          'answerIndex':
                                                              enabledList,
                                                        };
                                                      },
                                                      child: Container(
                                                        width: 170,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            'Update Question',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: showupdatebutton
                                                  ? EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0)
                                                  : EdgeInsetsDirectional
                                                      .fromSTEB(90, 0, 0, 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(enabledList);
                                                  var answerindexlist =
                                                      enabledList;
                                                  print(
                                                      "yhbuyjbyhbjhb$questionslist $enabledList");
                                                  List answersList = [];
                                                  for (var i in enabledList) {
                                                    if (i == 'A') {
                                                      answersList
                                                          .add(Option1!.text);
                                                    }
                                                    if (i == 'B') {
                                                      answersList
                                                          .add(Option2!.text);
                                                    }
                                                    if (i == 'C') {
                                                      answersList
                                                          .add(Option3!.text);
                                                    }
                                                    if (i == 'D') {
                                                      answersList
                                                          .add(Option4!.text);
                                                    }
                                                  }
                                                  print("jjj${enabledList}");
                                                  questionslist.add({
                                                    'questionImage':
                                                        FFAppState().editImage,
                                                    'question':
                                                        questioncontroller
                                                            ?.text,
                                                    'OptionsImage': {
                                                      'A': FFAppState()
                                                          .optionaimage,
                                                      'B': FFAppState()
                                                          .optionbimage,
                                                      'C': FFAppState()
                                                          .optioncimage,
                                                      'D': FFAppState()
                                                          .optiondimage,
                                                    },
                                                    'options': {
                                                      'A': Option1?.text,
                                                      'B': Option2?.text,
                                                      'C': Option3?.text,
                                                      'D': Option4?.text,
                                                    },
                                                    'solution':
                                                        SolutionController
                                                            ?.text,
                                                    'answer': answersList,
                                                    'answerIndex':
                                                        answerindexlist,
                                                  });
                                                  print("iii${enabledList}");

                                                  setState(() {
                                                    // questionslist;
                                                    questionNumber?.text = '';
                                                    questioncontroller?.text =
                                                        '';
                                                    Option1?.text = '';
                                                    Option2?.text = '';
                                                    Option3?.text = '';
                                                    Option4?.text = '';
                                                    SolutionController?.text =
                                                        '';
                                                    AnswerController?.text = '';
                                                    AnswerIndexController
                                                        ?.text = '';
                                                    showupdatebutton = false;
                                                    FFAppState().editImage = '';
                                                    FFAppState().optionaimage =
                                                        '';
                                                    FFAppState().optionbimage =
                                                        '';
                                                    FFAppState().optioncimage =
                                                        '';
                                                    FFAppState().optiondimage =
                                                        '';
                                                  });
                                                  print("kk${questionslist}");

                                                  enabledList = [];
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: Text(
                                                      'Add Question',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyText1
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(15, 0, 0, 0),
                                              child: Container(
                                                child: DropdownButton<String>(
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  // // Step 3.
                                                  value: tempcoursename,
                                                  // Step 4.

                                                  items: globals.courseList.map<
                                                      DropdownMenuItem<
                                                          String>>((value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Lexend Deca',
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  // Step 5.
                                                  onChanged:
                                                      (String? newValue) {
                                                    try {
                                                      setState(() {
                                                        tempmodulelist = [
                                                          'Module Name'
                                                        ];
                                                        print('ft1');
                                                        print(newValue);
                                                        tempmodulename =
                                                            'Module Name';
                                                        print(
                                                            '${globals.coursemoduelmap[newValue].runtimeType}');
                                                        try {
                                                          for (var i in globals
                                                                  .coursemoduelmap[
                                                              newValue]) {
                                                            tempmodulelist
                                                                .add(i);
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }

                                                        print('ft3');
                                                        tempcoursename =
                                                            newValue!;
                                                        print('ft4');
                                                      });
                                                    } catch (e) {
                                                      print("rrrrrrr: ${e}");
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          isSwitched
                                              ? Container()
                                              : tempmodulelist.length != 1
                                                  ? Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10, 0,
                                                                    0, 0),
                                                        child: DropdownButton<
                                                            String>(
                                                          underline:
                                                              Container(),
                                                          isExpanded: true,
                                                          // Step 3.
                                                          value: tempmodulename,
                                                          // Step 4.

                                                          items: tempmodulelist.map<
                                                                  DropdownMenuItem<
                                                                      String>>(
                                                              (value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          'Lexend Deca',
                                                                      color: Color(
                                                                          0xFF57636C),
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          // Step 5.
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              tempmodulename =
                                                                  newValue!;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(15, 0, 0, 0),
                                              child: TextFormField(
                                                controller: timecontroller,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Lexend Deca',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                  hintText: 'Time',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Lexend Deca',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              24, 24, 20, 24),
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyText1
                                                    .override(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF1D2429),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                maxLines: null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 30, 10, 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  var coursedata;
                                                  var leng;
                                                  var id;
                                                  try {
                                                    print(
                                                        "sdfoisjiofjisojdfoisjoidfjsiojfdiosjiodfjsoijdfosjd${tempcoursename} ${tempmodulename}");
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection("courses")
                                                          .where("name",
                                                              isEqualTo:
                                                                  tempcoursename
                                                                      .toString())
                                                          .get()
                                                          .then((value) {
                                                        coursedata = value
                                                                    .docs.first
                                                                    .data()[
                                                                'curriculum1'][
                                                            tempcoursename
                                                                .toString()];

                                                        var curriculum1 = value
                                                                .docs.first
                                                                .data()[
                                                            'curriculum1'];

                                                        id = value.docs.first
                                                            .data()['docid'];
                                                        if (tempcoursename ==
                                                            'Course Name') {
                                                          Toast.show(
                                                              "Select Course Name!");
                                                        } else {
                                                          // to insert quiz in course
                                                          if (tempmodulename ==
                                                              'Module Name') {
                                                            var quizdata = {
                                                              "numberofattempt":
                                                                  numberofattempt
                                                                      ?.text,
                                                              "quizlevel":
                                                                  "courselevel",
                                                              "module":
                                                                  tempmodulename,
                                                              "negativemarking":
                                                                  NegativeMarkingController
                                                                      ?.text,
                                                              "questionbucket":
                                                                  questionslist,
                                                              "quiztiming":
                                                                  timecontroller
                                                                      ?.text,
                                                              "type": enabledList
                                                                          .length ==
                                                                      1
                                                                  ? "One Correct Option"
                                                                  : "Multiple Correct Options",
                                                              "name":
                                                                  quiznameController
                                                                      ?.text,
                                                              "courseName":
                                                                  tempcoursename,
                                                              "type": "quiz"
                                                            };
                                                            print(
                                                                "quizdata: ${quizdata}");
                                                            print("id: ${id}");
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "courses")
                                                                .doc(id)
                                                                .update({
                                                              "coursequiz":
                                                                  FieldValue
                                                                      .arrayUnion([
                                                                quizdata
                                                              ])
                                                            }).whenComplete(() {
                                                              Toast.show(
                                                                  "successfully uploaded");
                                                              print(
                                                                  "iiioopp ${curriculum1}");
                                                            });
                                                          } else {
                                                            // to insert quiz in module
                                                            for (var i
                                                                in coursedata) {
                                                              var quizdata;

                                                              if (i['modulename'] ==
                                                                  tempmodulename
                                                                      .toString()) {
                                                                print("1");
                                                                leng =
                                                                    i['videos']
                                                                        .length;
                                                                print("2");
                                                                quizdata = {
                                                                  "quizlevel":
                                                                      "modulelevel",
                                                                  "module":
                                                                      tempmodulename,
                                                                  "negativemarking":
                                                                      NegativeMarkingController
                                                                          ?.text,
                                                                  "questionbucket":
                                                                      questionslist,
                                                                  "quiztiming":
                                                                      timecontroller
                                                                          ?.text,
                                                                  "type": enabledList
                                                                              .length ==
                                                                          1
                                                                      ? "One Correct Option"
                                                                      : "Multiple Correct Options",
                                                                  "name":
                                                                      quiznameController
                                                                          ?.text,
                                                                  "courseName":
                                                                      tempcoursename,
                                                                  "sr": leng,
                                                                  "quizid":
                                                                      generateId(),
                                                                  "type": "quiz"
                                                                };
                                                                print("3");

                                                                i['videos'].add(
                                                                    quizdata);
                                                                print("4");
                                                                curriculum1[
                                                                        '${tempcoursename}'] =
                                                                    coursedata;
                                                                try {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "courses")
                                                                      .doc(id)
                                                                      .update({
                                                                    "curriculum1":
                                                                        curriculum1
                                                                  }).whenComplete(
                                                                          () {
                                                                    Toast.show(
                                                                        "successfully uploaded!");
                                                                    print(
                                                                        "iiioopp ${curriculum1}");
                                                                  });
                                                                } catch (e) {
                                                                  print(
                                                                      "shubham tiwari : ${e.toString()}");
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      }).catchError((err) {
                                                        Toast.show(
                                                            "select the course name! ($err)");
                                                      });
                                                    } catch (e) {
                                                      Toast.show(
                                                          "select the course name!");
                                                      print(
                                                          "yyyyyyyyy: ${e.toString()}");
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        "pppppppppp: ${e.toString()}");
                                                    Toast.show(e.toString());
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor,
                                                    border: Border.all(
                                                      color: Color(0xFFE6E5E5),
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: Text(
                                                      'Upload Quiz',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyText1
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
