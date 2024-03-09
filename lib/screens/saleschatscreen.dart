import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:clipboard/clipboard.dart';
import 'package:cloudyml_app2/screens/chatpage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../global_variable.dart';
//import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:microphone/microphone.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'getunread.dart';
import 'utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class SalesChatScreen extends StatefulWidget {
  const SalesChatScreen({Key? key}) : super(key: key);

  @override
  State<SalesChatScreen> createState() => _SalesChatScreenState();
}

late RawKeyboard _keyboard;
final GetUnread unread = GetUnread();
final _textController = TextEditingController();
bool _isRecording = false;
final FocusNode _focusNode = FocusNode();
String id = FirebaseAuth.instance.currentUser!.uid;
String idcurr = FirebaseAuth.instance.currentUser!.uid;
MicrophoneRecorder? _recorder;
String namecurrent =
    FirebaseAuth.instance.currentUser!.displayName.toString().split(" ")[0];
String selectedTileIndex = "";
String name = "";
String time = "";
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
FirebaseFirestore _firestore = FirebaseFirestore.instance;
//FirebaseFirestore _firestore = FirebaseFirestore.instance;
//final _textController = TextEditingController();
//late IO.Socket _socket;
Record record = Record();
// bool _isRecording = false;
//FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

File? pickedFile;

String? pickedFileName;
bool isLoading = false;
//TextEditingController _searchController = TextEditingController();
String role = "";
List<dynamic> coursecode = [];
List<String> coursename = [];
List<String> cname = [];
//List<DateTime> time = [];
Set<String> _updatedDocuments = {};
Set<String> newdocuments = {};
bool played = false;
bool isURL(String string) {
  // Regular expression pattern to match a URL
  // Regular expression pattern to match a URL
  return (string.contains('http', 0) ||
      string.contains('www') ||
      string.contains('https', 0) ||
      string.contains('.com'));
}

class _SalesChatScreenState extends State<SalesChatScreen> {
  Stream<QuerySnapshot>? _messageStream;
  void _initRecorder() {
    played == true ? _recorder?.dispose() : null;

    _recorder = MicrophoneRecorder()
      ..init()
      ..addListener(() {
        setState(() {
          played = true;
        });
      });
  }

  void _cancelRecording() async {
    if (_isRecording) {
      setState(_initRecorder);
      // await _soundRecorder.stopRecorder();
      // await _soundRecorder.closeAudioSession();

      setState(() {
        _isRecording = false;
      });
    }
  }

  bool isURL(String string) {
    // Regular expression pattern to match a URL
    // Regular expression pattern to match a URL
    return (string.contains('http', 0) ||
        string.contains('www') ||
        string.contains('https', 0) ||
        string.contains('.com'));
  }

  //FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      _focusNode.unfocus();
      String data = await _textController.text.toString();
      _textController.clear();
      final time = DateTime.now();
      // DateTime time1 = await fetchTimeInIndia();

      print(time);
      // print(time1.toString());
      updatelast();
      updatetime(time, data);
      final post = await _firestore
          .collection("sales_chat")
          .doc(idcurr)
          .collection("chats")
          .add({
        'message': data,
        'role': role,
        'sendBy': namecurrent,
        'time': time,
        'studentid': id,
        'type': 'text'
      });
    }
  }

  Future<void> _pickFilePhoto() async {
    print("good1");
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept =
        'image/*'; // Specify the accepted file types (e.g., images)
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File> files = uploadInput.files!;
      if (files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          final String? fileDataUrl = reader.result as String?;
          if (fileDataUrl != null) {
            // Convert the data URL to bytes
            final commaIndex = fileDataUrl.indexOf(',');
            if (commaIndex != -1) {
              final String base64Data = fileDataUrl.substring(commaIndex + 1);
              final Uint8List fileBytes = base64Decode(base64Data);

              final fileName = file.name;
              // Upload the file to Firebase Storage
              final storageRef =
                  FirebaseStorage.instance.ref().child('files/$fileName');
              final UploadTask uploadTask = storageRef.putData(
                  fileBytes, SettableMetadata(contentType: file.type));
              final TaskSnapshot snapshot = await uploadTask;
              final downloadUrl = await snapshot.ref.getDownloadURL();
              final time = DateTime.now();

              updatelast();
              print(time);
              // print(time.toString());
              updatelast();
              updatetime(time, "image");
              _firestore
                  .collection("sales_chat")
                  .doc(idcurr)
                  .collection("chats")
                  .add({
                'message': fileName,
                'role': role,
                'sendBy': namecurrent,
                'link': downloadUrl,
                'time': time,
                'studentid': id,
                'type': 'image'
              });
            }
          }
        });
      }
    });
  }

  Future<void> _pickFilevideo() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept =
        'video/*'; // Specify the accepted file types (e.g., videos)
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File> files = uploadInput.files!;
      if (files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          final String? fileDataUrl = reader.result as String?;
          if (fileDataUrl != null) {
            // Convert the data URL to bytes
            final commaIndex = fileDataUrl.indexOf(',');
            if (commaIndex != -1) {
              final String base64Data = fileDataUrl.substring(commaIndex + 1);
              final Uint8List fileBytes = base64Decode(base64Data);

              final fileName = file.name;
              // Upload the file to Firebase Storage
              final storageRef =
                  FirebaseStorage.instance.ref().child('files/$fileName');
              final UploadTask uploadTask = storageRef.putData(
                  fileBytes, SettableMetadata(contentType: file.type));
              final TaskSnapshot snapshot = await uploadTask;
              final downloadUrl = await snapshot.ref.getDownloadURL();
              final time = DateTime.now();
              // Add message to Firestore
              //  final time = DateTime.now();
              // DateTime time1 = await fetchTimeInIndia();

              print(time);
              //   print(time1.toString());
              updatelast();
              updatetime(time, "video");

              _firestore
                  .collection("sales_chat")
                  .doc(idcurr)
                  .collection("chats")
                  .add({
                'message': fileName,
                'role': role,
                'sendBy': namecurrent,
                'link': downloadUrl,
                'time': time,
                'studentid': id,
                'type': 'video'
              });
            }
          }
        });
      }
    });
  }

  Future<void> _pickFileany() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.accept = ''; // Modify the accepted file types as needed
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File>? files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) async {
          final Uint8List? fileBytes = reader.result as Uint8List?;
          if (fileBytes != null) {
            final fileName = file.name;
            // Upload the file to Firebase Storage
            final storageRef =
                FirebaseStorage.instance.ref().child('files/$fileName');
            final UploadTask uploadTask = storageRef.putData(
                fileBytes,
                SettableMetadata(
                    contentType:
                        'application/pdf')); // Modify the content type as needed
            final TaskSnapshot snapshot = await uploadTask;
            final downloadUrl = await snapshot.ref.getDownloadURL();
            final time = DateTime.now();
            //  DateTime time1 = await fetchTimeInIndia();

            print(time);
            print(time.toString());
            updatelast();
            updatetime(time, "file");
            _firestore
                .collection("sales_chat")
                .doc(idcurr)
                .collection("chats")
                .add({
              'message': fileName,
              'role': role,
              'sendBy': namecurrent,
              'link': downloadUrl,
              'time': time,
              'studentid': id,
              'type': 'file'
            });
          }
        });
      }
    });
  }

  bool notificationShown = false;

  void displayWebNotification(String title, String body, String icon) {
    if (!notificationShown && html.Notification.supported) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(title, body: body, icon: icon);
          notificationShown = true;
        }
      });
    }
  }

//  void updatetime(DateTime time, String message) {
//     _firestore.collection("sales_chats").doc(widget.groupId).update({'time': time});
//     _firestore
//         .collection("sales_chats")
//         .doc(widget.groupId)
//         .update({'lastmessage': message});
//   }
  void updatetime(DateTime time, String message) {
    _firestore.collection("sales_chat").doc(idcurr).update({'time': time});
    _firestore
        .collection("sales_chat")
        .doc(idcurr)
        .update({'lastmessage': message});
  }

  Future<DateTime> fetchTimeInIndia() async {
    final response = await http
        .get(Uri.parse('https://worldtimeapi.org/api/timezone/Asia/Kolkata'));
    final jsonData = json.decode(response.body);
    final datetime = jsonData['datetime'];
    final offset = jsonData['utc_offset'];
    final parsedDateTime = DateTime.parse(datetime).toUtc();
    return parsedDateTime;
  }

  void updatelast() {
    _firestore
        .collection("sales_chat")
        .doc(idcurr)
        .update({'last': FirebaseAuth.instance.currentUser!.uid.toString()});
  }

  void _stopRecording() async {
    if (_isRecording) {
      await _recorder!.stop();
      endtime = DateTime.now();

      setState(() {
        _isRecording = false;
      });
      _uploadRecording();
    }
  }

  Duration _calculateDuration() {
    final duration = endtime!.difference(starttime!);
    return duration;
  }

//  void _getAppStorageDir() {
//   final appStorage = html.window.localStorage;
//   // Use appStorage as needed
// }
  Future<String> _uploadRecording() async {
    if (namecurrent != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('audio/${DateTime.now()}.mp3');
//  final fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(filePath).future;
      try {
        await storageRef.putData(await _recorder!.toBytes());
        final downloadUrl = await storageRef.getDownloadURL();
        print('File uploaded: $downloadUrl');
        // final time = DateTime.now();
        // Add message to Firestore
        final time = DateTime.now();
        //  DateTime time1 = await fetchTimeInIndia();
        Duration tt = await _calculateDuration();
        //  print(time);
        //   print(time1.toString());
        updatelast();
        updatetime(time, "audio note");
        _firestore
            .collection("sales_chat")
            .doc(idcurr)
            .collection("chats")
            .add({
          'message': '${DateTime.now()}.mp3',
          'role': role,
          'sendBy': namecurrent,
          'link': downloadUrl,
          'time': time,
          'studentid': id,
          'duration':
              '${tt.inHours}:${tt.inMinutes.remainder(60)}:${tt.inSeconds.remainder(60)}',
          'type': 'audio'
        });

        return downloadUrl;
      } catch (e) {
        print('Error uploading file: $e');
        throw 'Failed to upload recording';
      }
    } else {
      return "not valid";
    }
  }

  DateTime? starttime;
  DateTime? endtime;
  // FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  void _startRecording() async {
    _initRecorder();
    // starttime=DateTime.
    print("Recording....");
    if (await Record().hasPermission()) {
      setState(() {
        _isRecording = true;
      });

      // await _initRecorder();

      _recorder!.start();
      starttime = DateTime.now();
      //   await _soundRecorder.openAudioSession();
      //   await _soundRecorder.startRecorder(
      //     // toFile: '${appStorage!.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
      //  //   codec: opusWebM,
      //     sampleRate: 44100,
      //     bitRate: 128000,
      //   );
    }
  }

  Widget _buildMicButton() {
    return IconButton(
      icon: Icon(Icons.mic_none_rounded, color: Colors.purple),
      onPressed: _startRecording,
    );
  }

  Widget _buildStopRecordingButton() {
    return IconButton(
      icon: Icon(Icons.stop_rounded, color: Colors.red),
      onPressed: _stopRecording,
    );
  }

  Widget _buildCancelButton() {
    return IconButton(
      icon: Icon(Icons.cancel_rounded, color: Colors.grey),
      onPressed: _cancelRecording,
    );
  }

  StreamController<Stream<QuerySnapshot>> _streamController =
      StreamController<Stream<QuerySnapshot>>();

  Stream<QuerySnapshot> _collectionStream = FirebaseFirestore.instance
      .collection('sales_chat')
      .orderBy('time', descending: true)
      .limit(500)
      .snapshots();

  void updateStream(String? selectedCourse) {
    if (selectedCourse != null) {
      Stream<QuerySnapshot> filteredStream = FirebaseFirestore.instance
          .collection('sales_chat')
          .where('name', isEqualTo: selectedCourse)
          .orderBy('time', descending: true)
          .limit(500)
          .snapshots();
      _streamController.add(filteredStream);
    } else {
      _streamController.add(_collectionStream);
    }
  }

  Stream<QuerySnapshot> _collectionStream1 = FirebaseFirestore.instance
      .collection('sales_chat')
      .where('student_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('time', descending: true)
      .limit(500)
      .snapshots();
//  Stream<QuerySnapshot>? _messageStream;
  void listenToFirestoreChanges() async {
    final snapshot = await _firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = snapshot.data();
    role = data!["role"];
    namecurrent = data["name"].split(" ")[0];
    ;
    _updatedDocuments = Set<String>();
    role == "student"
        ? _collectionStream1.listen((snapshot) async {
            snapshot.docChanges.forEach((change) {
              if (change.type == DocumentChangeType.modified) {
                DocumentSnapshot changedDoc = change.doc;
                Map<String, dynamic> changedData =
                    changedDoc.data() as Map<String, dynamic>;
                if (changedData.containsKey("last")) {
                  if (change.doc["last"].toString() ==
                      FirebaseAuth.instance.currentUser!.uid.toString()) {
                  } else {
                    _updatedDocuments.add(change.doc.id);
                    print(_updatedDocuments);
                    displayWebNotification(
                        "${change.doc["student_name"]} has a new message",
                        changedData.containsKey('lastmessage')
                            ? "message: ${change.doc["lastmessage"]}"
                            : "message: new feature is working",
                        "assets/icon.jpeg");
                  }
                  notificationShown = true;
                } else {
                  _updatedDocuments.add(change.doc.id);
                  print(_updatedDocuments);
                }
              } else if (change.type == DocumentChangeType.added) {
                newdocuments.add(change.doc.id);
              }
            });
            if (_updatedDocuments.isNotEmpty) {
              await unread.saveunread(_updatedDocuments);
            }
          })
        : _collectionStream.listen((snapshot) async {
            snapshot.docChanges.forEach((change) {
              if (change.type == DocumentChangeType.modified) {
                DocumentSnapshot changedDoc = change.doc;
                Map<String, dynamic> changedData =
                    changedDoc.data() as Map<String, dynamic>;
                if (changedData.containsKey("last")) {
                  if (change.doc["last"].toString() ==
                      FirebaseAuth.instance.currentUser!.uid.toString()) {
                  } else {
                    _updatedDocuments.add(change.doc.id);
                    print(_updatedDocuments);
                    displayWebNotification(
                        "New Message",
                        "${change.doc["student_name"]} has a new message",
                        "assets/icon.jpeg");
                  }
                  notificationShown = true;
                } else {
                  _updatedDocuments.add(change.doc.id);
                  print(_updatedDocuments);
                }
              } else if (change.type == DocumentChangeType.added) {
                newdocuments.add(change.doc.id);
              }
            });
            if (_updatedDocuments.isNotEmpty) {
              await unread.saveunread(_updatedDocuments);
            }
          });

    setState(() {
      isLoading = false;
    });
  }

  void _selectimage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Select Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFilePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Select Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFilevideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future readunread() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey("myList")) {
    } else {}
  }

  Future<String> loadrole() async {
    final snapshot = await _firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = snapshot.data();
    role = data!["role"];
    // name = data["name"].toString().split(" ")[0];
    print(FirebaseAuth.instance.currentUser!.uid);
    print(role);
    // print(name);
    return role;
  }

  Future<void> checkDeviceTime() async {
    try {
      final now = DateTime.now();
      final ntpTime = await NTP.now();
      final timeDifference = ntpTime.difference(now).inSeconds.abs();

      // Define a threshold for time difference (e.g., 30 seconds) to consider as incorrect.
      final timeThreshold = 30;

      if (timeDifference > timeThreshold) {
        // Device time is incorrect, show a popup to correct it.
        showTimeCorrectionPopup();
      }
    } catch (e) {
      print('Error checking device time: $e');
    }
  }

  void showTimeCorrectionPopup() {
    Fluttertoast.showToast(
      msg: 'Your device time is incorrect. Please correct it.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Set<String> selectedCourses = Set<String>();

  void updateCollectionStream() {
    if (selectedCourses.isEmpty) {
      _collectionStream = FirebaseFirestore.instance
          .collection('sales_chat')
          .orderBy('time', descending: true)
          .limit(500)
          .snapshots();
    } else {
      _collectionStream = FirebaseFirestore.instance
          .collection('sales_chat')
          .where('name', whereIn: selectedCourses.toList())
          .orderBy('time', descending: true)
          .limit(500)
          .snapshots();
    }
  }

  Set<String> coursesList = Set<String>();
  Future<Set<String>> getcourses() async {
    if (coursesgroups.length == 0) {
      await FirebaseFirestore.instance
          .collection("courses")
          .get()
          .then((value) async {
        Set<String> normalcourse = Set<String>();
        for (var i in value.docs) {
          CollectionReference groupsCollection =
              FirebaseFirestore.instance.collection('sales_chat');
          QuerySnapshot querySnapshot =
              await groupsCollection.where('name', isEqualTo: i['name']).get();
          if (querySnapshot.size != 0) {
            if (i['combo'] != true) {
              normalcourse.add(i['name']);
            } else {
              coursesList.add(i['name']);
            }
          }
        }
        coursesList.addAll(normalcourse);
        coursesgroups.addAll(coursesList);
        print("coursenamelist: ${coursesList}");
      });
    }
    return coursesgroups;
  }

  String selectedCourse = "";


  List<String>? myList;
  @override
  void initState() {
    super.initState();
    checkDeviceTime();
    _keyboard = RawKeyboard.instance;
    _keyboard.addListener(_handleKeyPress);
    loadrole();

    // _initRecorder();
    //Configuration.docid = "";
    print("iwejoiweofwoiefwf");
    readunread();
    if (myList != null) {
      _updatedDocuments = myList!.toSet();
    } else {
      _updatedDocuments = Set<String>();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenToFirestoreChanges();
    });
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      // Trigger your function here
      _sendMessage();
    }
  }

  @override
  void dispose() {
    _keyboard.removeListener(_handleKeyPress);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _messageStream = FirebaseFirestore.instance
        .collection("sales_chat")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();

    double baseWidth =400 ;
    double fem = 100.w / baseWidth;
    double ffem = fem * 0.97;
    DateTime now = DateTime.now();
    return Row(
      children: [
      //  Container(width: 30.w, height: .h),
        Container(
           decoration: BoxDecoration(
           // borderRadius: BorderRadius.circular(20),
            color: Colors.white,
    border: Border.all(
      color: Colors.purple,
      width: 2.0, // Adjust the width as needed
    ),
  ),
          width: 35.w,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 6.h,
                child: Container(
                  // topbartFx (1:345)
                  padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffd9dce0)),
                    color: Color(0xffffffff),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // otherusera8n (1:346)
                        padding: EdgeInsets.fromLTRB(0, 0, 2.h, 0),
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Container(
                                // avatarJ4n (1:347)
                                margin: EdgeInsets.fromLTRB(0, 0, 1.w, 0),
                                width: 3.w,
                                height: 3.w,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(100 * fem),
                                  child: Image.asset(
                                    'assets/icon.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // textszCW (1:348)
                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // datascienceanalyticswdY (1:350)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 0 * fem, 1 * fem),
                                    child: Text(
                                      'Sales Team',
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                       // height: 1.25 * ffem / fem,
                                        color: Color(0xff011627),
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   // lastmessage5minsagoeXx (1:352)
                                  //   '$time',
                                  //   style: SafeGoogleFont(
                                  //     'Inter',
                                  //     fontSize: 14 * ffem,
                                  //     fontWeight: FontWeight.w400,
                                  //     height: 1.2857142857 *
                                  //         ffem /
                                  //         fem,
                                  //     color: Color(0xff707991),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      SizedBox(
                        width: 8 * fem,
                      ),
                      Container(
                        // callicon5NN (1:356)
                        width: 40 * fem,
                        height: 40 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100 * fem),
                        ),
                      ),
                      SizedBox(
                        width: 8 * fem,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 40.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: Color(0xFFB27ECA),
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/page-1/images/bg-1.png"), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 75.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _messageStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print("snapshot.error");
                            return CircularProgressIndicator(
                              color: Colors.yellow,
                            );
                          }

                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final messages = snapshot.data!.docs;
                          print('Number of documents: ${messages.length}');
                          List<MessageBubble> messageBubbles = [];
                          for (var message in messages) {
                            final data = message.data() as Map<String, dynamic>;
                            final messageText = message['message'];
                            final messageSender = message['sendBy'];
                            final messageType = message['type'];
                            final messagetime = message['time'];
                            final mid = message.id;
                            final gid = FirebaseAuth.instance.currentUser!.uid;
                            final messageid = message['studentid'];

                            final link = messageType == "image" ||
                                    messageType == "audio" ||
                                    messageType == "video" ||
                                    messageType == "file"
                                ? message["link"]
                                : "";

                            final messageBubble = MessageBubble(
                              mid: mid,
                              gid: gid!,
                              message: messageText,
                              sender: messageSender,
                              timestamp: messagetime,
                              isMe: messageid ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              link: link,
                              //  recording: recording,
                              type: messageType,
                              isURL: isURL(messageText),
                            );
                            messageBubbles.add(messageBubble);
                          }
                          return Container(
                            height: 80.h,
                            width: 65.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.sp),
                                topRight: Radius.circular(40.sp),
                              ),
                              // color: Colors.white,
                            ),
                            child: ListView(
                              reverse: true,
                              children: messageBubbles,
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Container(
                        height: 8.h,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 1.w,
                            ),
                            _isRecording
                                ? _buildStopRecordingButton()
                                : _buildMicButton(),
                            _isRecording
                                ? _buildCancelButton()
                                : Expanded(
                                    child: TextField(
                                      maxLines: 1,
                                      controller: _textController,
                                      onTap: () {
                                        _focusNode.requestFocus();
                                      },
                                      onTapOutside: (event) {
                                        _focusNode.unfocus();
                                      },
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message...',
                                      ),
                                    ),
                                    // ),
                                  ),
                            _isRecording
                                ? SizedBox()
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.attachment_outlined,
                                            color: Colors.purple),
                                        onPressed: _pickFileany,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.purple),
                                        onPressed: _selectimage,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.send,
                                            color: Colors.purple),
                                        onPressed: _sendMessage,
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
            ],
          ),
        ),
      ],
    );
  }
}
