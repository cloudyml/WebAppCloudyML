import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/quiz/admin_quiz.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';


class QuizPanel extends StatefulWidget {
  QuizPanel({Key? key}) : super(key: key);

  @override
  State<QuizPanel> createState() => _QuizPanelState();
}

class _QuizPanelState extends State<QuizPanel> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    globalquizstatus();
  }

  globalquizstatus() async {
    await FirebaseFirestore.instance
        .collection("Controllers")
        .doc('variables')
        .get()
        .then((value) {
      setState(() {
        _switchValue = value.data()!['globalquiz'];
      });
    });
  }

  updatequizstatus() async {
    await FirebaseFirestore.instance
        .collection("Controllers")
        .doc('variables')
        .update({"globalquiz": _switchValue});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Container(
            child: Row(children: [
              // TextButton(
              //   onPressed: () {},
              //   child: Container(
              //     color: Color.fromARGB(255, 58, 255, 160),
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Text(
              //           'Global Quiz: ',
              //           style: TextStyle(color: Colors.white, fontSize: 13.0),
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         CupertinoSwitch(
              //           value: _switchValue,
              //           onChanged: (value) {
              //             setState(() {
              //               _switchValue = value;
              //             });
              //             updatequizstatus();
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  GoRouter.of(context).go('/adminquizpanel');
                  //   // Navigator.pushReplacement(
                  //   //     context,
                  //   //     MaterialPageRoute(
                  //   //         builder: (BuildContext context) => super.widget));
                  //   // ignore: invalid_use_of_protected_member
                  //   (context as Element).reassemble();

                  //   Navigator.of(context)
                  //       .push(MaterialPageRoute(builder: (_) => AdminQuizPanel()));
                  //   GoRouter.of(context).push('/adminquizpanel');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => AdminQuizPanel()));
                },
                child: Container(
                  height: 50,
                  color: Color.fromARGB(255, 58, 255, 160),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Center(
                    child: const Text(
                      'Add Quiz',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     GoRouter.of(context).go('/createcoupon');
              //   },
              //   child: Container(
              //     height: 50,
              //     color: Color.fromARGB(255, 58, 255, 160),
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //     child: Center(
              //       child: const Text(
              //         'Create Coupon',
              //         style: TextStyle(color: Colors.white, fontSize: 13.0),
              //       ),
              //     ),
              //   ),
              // ),
              
            ]),
          )),
        ),
      ),
    );
  }
}
