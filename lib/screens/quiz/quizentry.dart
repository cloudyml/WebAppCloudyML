import 'package:cloudyml_app2/screens/quiz/quizinstructions.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:go_router/go_router.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:cloudyml_app2/screens/quiz/edit_quiz.dart';

class QuizentrypageWidget extends StatefulWidget {
  var quizdata;
  final quizScore;
  final quizNameExistsInList;
  final ontap;
  QuizentrypageWidget(this.quizdata,
      {Key? key, this.quizScore, this.quizNameExistsInList, this.ontap})
      : super(key: key);

  @override
  _QuizentrypageWidgetState createState() => _QuizentrypageWidgetState();
}

class _QuizentrypageWidgetState extends State<QuizentrypageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  // bool quizNameExistsInList  = false;
  var quizData;

//   checkIfQuizIsAttempted() {
//     try{
//       for (var item in globals.quiztrack) {
//         if (item['quizname'] == widget.quizdata['name']) {
//           quizNameExistsInList = true;
//           break;
//         }
//       }
//     }catch(e){
//       print('quiz taken error $e');
// }
// }
  var score = '0';

  @override
  void initState() {
    super.initState();
    // checkIfQuizIsAttempted();
    print('widget.quizscore ${widget.quizScore}');
    try {
      score = widget.quizScore.toStringAsFixed(2).toString();
    } catch (e) {
      score = '-';
    }
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_unfocusNode);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 6,
            width: MediaQuery.of(context).size.width * 6,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: 800,
                      height: 400,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0, -0.45),
                              child: Text(
                                '${widget.quizdata['name']}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 37,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0.45),
                                  child: Text(
                                    'Test Questions: ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 19,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0.45),
                                  child: Text(
                                    '${widget.quizdata['questionbucket'].length}',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0.05),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      'Total Time: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      ' ${widget.quizdata['quiztiming']} minutes',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0.05),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      'Previous attempt score: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      '${score}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0, 0.35),
                              child: GestureDetector(
                                onTap: widget.ontap,
                                // onTap: () {
                                //   print("dlksl");
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             InstructionspageWidget(
                                //                 widget.quizdata)),
                                //   );
                                //   // GoRouter.of(context).pushNamed('/quizpage', queryParams: "${widget.quizdata}");
                                // },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      widget.quizNameExistsInList
                                          ? 'Re-take Quiz'
                                          : 'Start Quiz',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBtnText,
                                            fontSize: 17,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          globals.role == "mentor"
                              // true
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // GoRouter.of(context).go('/editquiz',  extra: "${widget.quizdata}");
                                      // Navigator.push(context, route)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditQuiz(widget.quizdata)),
                                      );
                                    },
                                    child: Text(
                                      "Edit Quiz",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor,
                                            fontSize: 17,
                                          ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
