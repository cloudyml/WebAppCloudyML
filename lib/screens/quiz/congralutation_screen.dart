import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/quiz/quizsolution.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../../global_variable.dart' as globals;
// import 'certificate.dart';

class CongratulationsWidget extends StatefulWidget {
  var quizdata;
  var total;
  var time;
  bool? scholarshipQuiz;
  var unanswered;
  var correctanswered;
  var completedata;
  var resultString;
  var wronganswered;
  var totalQuestion;
  CongratulationsWidget(
      this.quizdata,
      this.total,
      this.unanswered,
      this.wronganswered,
      this.correctanswered,
      this.completedata,
      this.resultString,
      this.time,
      this.totalQuestion,
      this.scholarshipQuiz,
      {Key? key})
      : super(key: key);

  @override
  _CongratulationsWidgetState createState() => _CongratulationsWidgetState();
}

class _CongratulationsWidgetState extends State<CongratulationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("wiefjw ${widget.resultString}");
    print('iofwjoe ${widget.scholarshipQuiz}');
    print(widget.scholarshipQuiz == true &&
        widget.resultString == "Congratulations!");
    getqualifiedscore();
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> _downloadImage() async {
    // print("aaaaaaaaaaaaaaaaaaaaaa");
    // printWrapped(Uri.parse(globals.downloadCertificateLink).toString().replaceAll('"', ''));
    // print('kkkkkkkkkkkkkkkkkkkkkkk');

    try {
      await WebImageDownloader.downloadImageFromWeb(
          globals.downloadCertificateLink.replaceAll('"', ""));
      // url.replaceAll('"', '');
    } catch (e) {
      print("the cer error is$e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int coursequizwindowindays = 0;
  int modulerquizwindowinhours = 0;
  int coursequizpassingpercentage = 70;
  int modulequizpassingpercentage = 0;
  String returningString = "";
  int coursequizwindowindaysmorethan50percent = 0;

  getqualifiedscore() async {
    try {
      await FirebaseFirestore.instance
          .collection("Controllers")
          .doc("variables")
          .get()
          .then((value) {
        coursequizwindowindays = value.data()!['coursequizwindowindays'];
        print("coursequizwindowindays: $coursequizwindowindays");
        modulerquizwindowinhours = value.data()!['modulerquizwindowinhours'];
        coursequizwindowindaysmorethan50percent =
            value.data()!['coursequizwindowindaysmorethan50percent'];
        coursequizpassingpercentage =
            value.data()!['coursequizpassingpercentage'];

        modulequizpassingpercentage =
            value.data()!['modulequizpassingpercentage'];
      });
    } catch (e) {
      print("errorid: ff93u98e9w: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final hight = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      child: Container(
                        width: 1119.5,
                        height: MediaQuery.of(context).size.height * 0.85,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Image.asset(
                                    'assets/cloud.jpeg',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 20, 0, 0),
                                    child: widget.resultString.length > 20
                                        ? Center(
                                            child: widget.scholarshipQuiz ==
                                                        true &&
                                                    widget.resultString ==
                                                        "Congratulations!"
                                                ? Text(
                                                    'Congratulations, Checkout your email for Coupon Code of ${(widget.total * 20).toStringAsFixed(0)} Discount!',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  )
                                                : Text(
                                                    '${widget.resultString}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                          )
                                        : Center(
                                            child: widget.scholarshipQuiz ==
                                                        true &&
                                                    widget.resultString ==
                                                        "Congratulations!"
                                                ? Text(
                                                    'Congratulations, Checkout your email for Coupon Code of ${(widget.total * 20).toStringAsFixed(0)} Discount!',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  )
                                                : Text(
                                                    '${widget.resultString}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                width <= 700
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          dataBox(
                                              color: Colors.green,
                                              title: 'Total Marks',
                                              data:
                                                  "${widget.correctanswered.toString()}/${widget.totalQuestion.toString()}",
                                              width: width),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dataBox(
                                              color: Colors.blueGrey,
                                              title: 'Time Taken',
                                              data: widget.time.toString(),
                                              width: width),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          dataBox(
                                              color: Colors.blueAccent,
                                              title: 'Percentage',
                                              data:
                                                  "${double.parse(widget.total.toString()).toStringAsFixed(2)}%",
                                              width: width),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          dataBox(
                                              color: Colors.green,
                                              title: 'Total Marks',
                                              data:
                                                  "${widget.correctanswered.toString()}/${widget.totalQuestion.toString()}",
                                              width: width),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          dataBox(
                                              color: Colors.blueGrey,
                                              title: 'Time Taken',
                                              data: widget.time.toString(),
                                              width: width),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          dataBox(
                                              color: Colors.blueAccent,
                                              title: 'Percentage',
                                              data:
                                                  "${double.parse(widget.total.toString()).toStringAsFixed(2)}%",
                                              width: width),
                                        ],
                                      ),

                                // Container(
                                //   height: 130,
                                //   width: 130,
                                //   margin: EdgeInsets.all(0.0),
                                //   decoration: BoxDecoration(
                                //       color: Colors.green,
                                //       shape: BoxShape.circle),
                                //   child: Center(
                                //     child: Text(
                                //       "${double.parse(widget.total.toString()).toStringAsFixed(2)}%",
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 27),
                                //     ),
                                //   ),
                                // ),

                                SizedBox(
                                  height: 10,
                                ),
                                // Text(
                                //   'You won our certificate of data scientist',
                                //   style: FlutterFlowTheme.of(context)
                                //       .bodyText1
                                //       .override(
                                //         fontFamily: 'Poppins',
                                //         fontWeight: FontWeight.normal,
                                //       ),
                                // ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 30, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.completedata['quizlevel'] !=
                                              'modulelevel'
                                          ? widget.total >
                                                  coursequizpassingpercentage
                                              ? widget.scholarshipQuiz == true
                                                  ? Container()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        _downloadImage();
                                                        // Navigator.pushReplacement(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             Certificate()));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 0,
                                                                    10, 0),
                                                        child: Container(
                                                          width: 260,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.05, 0),
                                                            child: Text(
                                                              'Download Certificate',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBtnText,
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                              : Container()
                                          : Container(),
                                      InkWell(
                                        onTap: () {
                                          print(
                                              "ppppkkklklll ${widget.quizdata}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QuizSolutionCopyWidget(
                                                      widget.quizdata,
                                                      widget.total,
                                                      widget.unanswered,
                                                      widget.wronganswered,
                                                      widget.correctanswered),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 0, 0),
                                          child: Container(
                                            width: 160,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.05, 0),
                                              child: Text(
                                                'View Solutions',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                          fontSize: 17,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: AlignmentDirectional(0, 0.4),
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //     child: Lottie.asset(
                //       'assets/cong.json',
                //       width: MediaQuery.of(context).size.width * 0.7,
                //       height: MediaQuery.of(context).size.height * 0.7,
                //       fit: BoxFit.cover,
                //       frameRate: FrameRate(18260),
                //       repeat: false,
                //       animate: true,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dataBox(
      {required Color color,
      required String title,
      required String data,
      required double width}) {
    return Container(
      width: width <= 700 ? 150 : 200,
      padding: EdgeInsets.all(20),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data,
            style: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
