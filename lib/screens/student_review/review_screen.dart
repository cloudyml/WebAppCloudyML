import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:cloudyml_app2/screens/student_review/ReviewApi.dart';
import 'package:cloudyml_app2/screens/student_review/postReviewScreen.dart';
import 'package:cloudyml_app2/screens/student_review/reviewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:star_rating/star_rating.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toast/toast.dart';

class StudentReviewScreen extends StatefulWidget {
  const StudentReviewScreen({Key? key}) : super(key: key);

  @override
  State<StudentReviewScreen> createState() => _StudentReviewScreenState();
}

class _StudentReviewScreenState extends State<StudentReviewScreen> {
  bool isLoading = true;
  Avgrating? avgrating;
  List<Review> reviews = [];
  bool isMentor = false;
  var selected_review = null;
  TextEditingController reviewdescription = TextEditingController();
  TextEditingController reviewrating = TextEditingController();

  @override
  void initState() {
    getRole();
    getreviewdata();
    super.initState();
  }

  bool error = false;

  getreviewdata() async {
    setState(() {
      isLoading = true;
    });
    dynamic data = await getReviewsApi();
    print('iwefoijwo${data.runtimeType}');
    if (data == 'error') {
      setState(() {
        isLoading = false;
      });
      error = true;
    } else {
      setState(() {
        isLoading = false;
        print('weoifjwoejfo $data');
        StudentReviewsModel studentReviewsModel =
            StudentReviewsModel.fromJson(jsonDecode(data));
        avgrating = studentReviewsModel.result!.avgrating;
        reviews = studentReviewsModel.result!.reviews!;
      });
    }
  }

  String formatTimeAgo(String timestamp) {
    final DateTime parsedTime = DateTime.parse(timestamp);
    final now = DateTime.now();

    return timeago.format(now.subtract(now.difference(parsedTime)));
  }

  var email;

  getRole() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.get('role') == 'mentor') {
          isMentor = true;
        }
        try {
          email = value.get('email');
        } catch (e) {}
      });
    } catch (e) {
      print('Error in getting role $e');
    }
  }

  updateReview({required String id}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Reviews')
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var documentId = snapshot.docs[0].id;
          FirebaseFirestore.instance
              .collection('Reviews')
              .doc(documentId)
              .update({
            "reviewdescription": "${reviewdescription.text}",
            "rating": reviewrating.text
          }).then((value) {
            Toast.show('Review Updated Successfully');
            getreviewdata();
          }).catchError((error) {
            print('Error updating review: $error');
          });
        }
      });
    } catch (e) {
      print('Error in deleting review $e');
    }
  }

  deleteReview({required String id}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Reviews')
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var documentId = snapshot.docs[0].id;
          FirebaseFirestore.instance
              .collection('Reviews')
              .doc(documentId)
              .delete()
              .then((value) {
            Toast.show('Review Deleted Successfully');
            getreviewdata();
          }).catchError((error) {
            print('Error deleting review: $error');
          });
        }
      });
    } catch (e) {
      print('Error in deleting review $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : error
                  ? Center(
                      child: GestureDetector(
                          onTap: () {
                            var result = Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostReviewScreen())).then((value) {
                              return setState(() {
                                getreviewdata();
                              });
                            });
                            print("uuuuuuuuuuuuuuummm: ${result}");
                            try {
                              setState(() {
                                getreviewdata();
                              });
                            } catch (e) {
                              print("eeeeeee: ${e}");
                            }
                          },
                          child: Text('Error occured while fetching data!')),
                    )
                  : SizedBox(
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraint) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10)),
                              constraints: BoxConstraints(
                                  maxWidth: constraint.maxWidth < 750
                                      ? MediaQuery.of(context).size.width
                                      : MediaQuery.of(context).size.width / 2,
                                  maxHeight:
                                      MediaQuery.of(context).size.height),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: RawScrollbar(
                                    thumbColor: Colors.deepPurpleAccent,
                                    radius: Radius.circular(20),
                                    thickness: 3,
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(scrollbars: false),
                                      child: reviews.isEmpty
                                          ? ifReviewEmpty([])
                                          : ListView.builder(
                                              itemCount: reviews.length,
                                              scrollDirection: Axis.vertical,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                try {
                                                  if (selected_review != null) {
                                                    final filteredReviews =
                                                        reviews
                                                            .where((review) =>
                                                                review.rating ==
                                                                selected_review
                                                                    .toString())
                                                            .toList();

                                                    reviews = filteredReviews;
                                                    print(
                                                        "yguugghj: ${filteredReviews}");
                                                    if (filteredReviews
                                                        .isEmpty) {
                                                      return index == 0
                                                          ? ifReviewEmpty([])
                                                          : Container();
                                                    }
                                                  }
                                                } catch (e) {
                                                  print(e);
                                                }

                                                reviews.sort((a, b) {
                                                  return b.date!
                                                      .compareTo(a.date!);
                                                });
                                                return index == 0
                                                    ? Column(
                                                        children: [
                                                          Center(
                                                              child: Text(
                                                            'Reviews And Rating',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        50),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      avgrating!
                                                                          .total!
                                                                          .toStringAsFixed(
                                                                              1),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            36,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    StarRating(
                                                                      length: 5,
                                                                      rating: double.parse(avgrating!
                                                                          .total
                                                                          .toString()),
                                                                      color: Colors
                                                                          .deepPurpleAccent,
                                                                      starSize:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      '${reviews.length}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    rateBar(
                                                                        rate:
                                                                            '5',
                                                                        value: double.parse(avgrating!
                                                                            .five
                                                                            .toString()),
                                                                        context:
                                                                            context),
                                                                    rateBar(
                                                                        rate:
                                                                            '4',
                                                                        value: double.parse(avgrating!
                                                                            .four
                                                                            .toString()),
                                                                        context:
                                                                            context),
                                                                    rateBar(
                                                                        rate:
                                                                            '3',
                                                                        value: double.parse(avgrating!
                                                                            .three
                                                                            .toString()),
                                                                        context:
                                                                            context),
                                                                    rateBar(
                                                                        rate:
                                                                            '2',
                                                                        value: double.parse(avgrating!
                                                                            .two
                                                                            .toString()),
                                                                        context:
                                                                            context),
                                                                    rateBar(
                                                                        rate:
                                                                            '1',
                                                                        value: double.parse(avgrating!
                                                                            .one
                                                                            .toString()),
                                                                        context:
                                                                            context),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showRatingDialog(
                                                                          context);
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .tune_sharp),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      var result = Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => PostReviewScreen()));

                                                                      print(
                                                                          "uuuuuuuuuuuuuuunnmnmnmns: ${await result}");

                                                                      setState(
                                                                          () {
                                                                        getreviewdata();
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16.0,
                                                                          vertical:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              'Add Your Review',
                                                                              style: TextStyle(fontSize: 13, color: Colors.deepPurpleAccent),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Icon(
                                                                              Icons.add,
                                                                              size: 16,
                                                                              color: Colors.deepPurpleAccent),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 20),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          16.0),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        '${reviews[index].name}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            launchURL(reviews[index].linkdinlink.toString());
                                                                          },
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.linkedin,
                                                                            color:
                                                                                Colors.blue,
                                                                            size:
                                                                                20,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '${reviews[index].email}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      StarRating(
                                                                        rating:
                                                                            double.parse(reviews[index].rating!),
                                                                        starSize:
                                                                            20,
                                                                        color: Colors
                                                                            .deepPurpleAccent,
                                                                        length:
                                                                            5,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        formatTimeAgo(
                                                                          '${reviews[index].date.toString()}',
                                                                        ),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    '${reviews[index].reviewdescription}',
                                                                    maxLines: 5,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  !isMentor
                                                                      ? Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          // mainAxisAlignment:
                                                                          //     MainAxisAlignment.spaceBetween,
                                                                          //efie
                                                                          children: [
                                                                            email == reviews[index].email
                                                                                ? IconButton(
                                                                                    onPressed: () => showEditBoxDialog(context, reviews[index]),
                                                                                    icon: Icon(
                                                                                      Icons.edit,
                                                                                      color: const Color.fromARGB(255, 54, 244, 168),
                                                                                    ))
                                                                                : Container()
                                                                          ],
                                                                        )
                                                                      : Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          // mainAxisAlignment:
                                                                          //     MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(),
                                                                            IconButton(
                                                                                onPressed: () => deleteReview(id: reviews[index].id!),
                                                                                icon: Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.red,
                                                                                )),
                                                                            IconButton(
                                                                                onPressed: () => showEditBoxDialog(context, reviews[index]),
                                                                                icon: Icon(
                                                                                  Icons.edit,
                                                                                  color: const Color.fromARGB(255, 54, 244, 168),
                                                                                ))
                                                                          ],
                                                                        )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 20),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    '${reviews[index].name}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        launchURL(reviews[index]
                                                                            .linkdinlink
                                                                            .toString());
                                                                      },
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .linkedin,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            20,
                                                                      ))
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                '${reviews[index].email}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  StarRating(
                                                                    rating: double.parse(
                                                                        reviews[index]
                                                                            .rating!),
                                                                    starSize:
                                                                        20,
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    length: 5,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    formatTimeAgo(
                                                                      '${reviews[index].date.toString()}',
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                '${reviews[index].reviewdescription}',
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              !isMentor
                                                                  ? Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      // mainAxisAlignment:
                                                                      //     MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        email ==
                                                                                reviews[index].email
                                                                            ? IconButton(
                                                                                onPressed: () => showEditBoxDialog(context, reviews[index]),
                                                                                icon: Icon(
                                                                                  Icons.edit,
                                                                                  color: const Color.fromARGB(255, 54, 244, 168),
                                                                                ))
                                                                            : Container()
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(),
                                                                        IconButton(
                                                                            onPressed: () =>
                                                                                deleteReview(id: reviews[index].id!),
                                                                            icon: Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed: () =>
                                                                                showEditBoxDialog(context, reviews[index]),
                                                                            icon: Icon(
                                                                              Icons.edit,
                                                                              color: const Color.fromARGB(255, 54, 244, 168),
                                                                            ))
                                                                      ],
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                              }),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )),
    );
  }

  Widget ifReviewEmpty(filteredReviews) {
    return Column(
      children: [
        Center(
            child: Text(
          'Reviews And Rating',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    avgrating!.total!.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StarRating(
                    length: 5,
                    rating: double.parse(avgrating!.total.toString()),
                    color: Colors.deepPurpleAccent,
                    starSize: 20,
                  ),
                  Text(
                    '${filteredReviews.length}',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              Column(
                children: [
                  rateBar(
                      rate: '5',
                      value: double.parse(avgrating!.five.toString()),
                      context: context),
                  rateBar(
                      rate: '4',
                      value: double.parse(avgrating!.four.toString()),
                      context: context),
                  rateBar(
                      rate: '3',
                      value: double.parse(avgrating!.three.toString()),
                      context: context),
                  rateBar(
                      rate: '2',
                      value: double.parse(avgrating!.two.toString()),
                      context: context),
                  rateBar(
                      rate: '1',
                      value: double.parse(avgrating!.one.toString()),
                      context: context),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    showRatingDialog(context);
                  },
                  child: Icon(Icons.tune_sharp),
                ),
                InkWell(
                  onTap: () async {
                    var result = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostReviewScreen()));

                    print("uuuuuuuuuuuuuuunnmnmnmns: ${await result}");

                    setState(() {
                      getreviewdata();
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add Your Review',
                            style: TextStyle(
                                fontSize: 13, color: Colors.deepPurpleAccent),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.add,
                            size: 16, color: Colors.deepPurpleAccent),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Center(
            child: Container(
          child: Text("no review available!"),
        )),
      ],
    );
  }

  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0.0; // Initial rating value
        return AlertDialog(
          title: Text('Rate our service'),
          content: RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              rating = newRating;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                getreviewdata();
                // Handle the rating submission logic
                setState(() {
                  selected_review = rating;
                });
                if (rating == 0) {
                  setState(() {
                    selected_review = null;
                  });
                }
                Navigator.of(context).pop(); // Close the dialog
                print('Ratinghhjb: $rating');
              },
            ),
          ],
        );
      },
    );
  }

  void showEditBoxDialog(BuildContext context, Review review) {
    reviewdescription.text = review.reviewdescription!;
    reviewrating.text = review.rating!;
    showDialog(
      context: context,
      builder: (context) {
        double rating = double.parse(reviewrating.text);
        return Padding(
          padding: const EdgeInsets.only(top: 180.0),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  AlertDialog(
                    content: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newRating) {
                              rating = newRating;
                              reviewrating.text = newRating.toString();
                            },
                          ),
                        ),
                        Container(
                          child: TextField(controller: reviewdescription),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Submit'),
                        onPressed: () {
                          updateReview(id: review.id!);
                          getreviewdata();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget rateBar(
      {required String rate,
      required double value,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            rate,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          SizedBox(
            width: 15,
          ),
          SizedBox(
            height: 5,
            width: MediaQuery.of(context).size.width / 4,
            child: LinearProgressIndicator(
              value: value / 100,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.purpleAccent[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
            ),
          ),
        ],
      ),
    );
  }
}
