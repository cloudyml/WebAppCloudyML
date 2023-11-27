// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

QuizTrackModel welcomeFromJson(String str) =>
    QuizTrackModel.fromJson(json.decode(str));

String welcomeToJson(QuizTrackModel data) => json.encode(data.toJson());

class QuizTrackModel {
  QuizTrackModel({
    this.scholarshipQuiz,
    this.quizdata,
    this.date,
    this.quizlevel,
    this.courseName,
    this.courseId,
    this.quizCleared,
    this.quizAttemptGapForModularQuiz,
    this.quizAttemptGapForCourseQuiz,
    this.quizname,
    this.quizScore,
    this.quizMark,
    this.quizTakenTime

  });

  List<dynamic>? quizdata;
  DateTime? date;
  bool? scholarshipQuiz;
  String? quizlevel;
  String? courseName;
  String? courseId;
  bool? quizCleared;
  DateTime? quizAttemptGapForModularQuiz;
  DateTime? quizAttemptGapForCourseQuiz;
  String? quizname;
  num? quizScore;
  String? quizTakenTime;
  String? quizMark;

  factory QuizTrackModel.fromJson(Map<String, dynamic> json) => QuizTrackModel(
    quizdata: json["quizdata"] == null
        ? []
        : List<dynamic>.from(json["quizdata"]!.map((x) => x)),
    date: (json["date"] as Timestamp).toDate(),
    scholarshipQuiz: json["scholarshipQuiz"],
    quizlevel: json["quizlevel"],
    courseName: json["courseName"],
    courseId: json["courseId"],
    quizCleared: json["quizCleared"],
    quizAttemptGapForModularQuiz:
    (json["quizAttemptGapForModularQuiz"] as Timestamp).toDate(),
    quizAttemptGapForCourseQuiz:
    (json["quizAttemptGapForCourseQuiz"] as Timestamp).toDate(),
    quizname: json["quizname"],
    quizScore: json["quizScore"],
    quizTakenTime: json["quizTakenTime"],
    quizMark: json["quizMark"],
  );

  Map<String, dynamic> toJson() => {
    "quizdata":
    quizdata == null ? [] : List<dynamic>.from(quizdata!.map((x) => x)),
    "date": date,
    "scholarshipQuiz": scholarshipQuiz,
    "quizlevel": quizlevel,
    "courseName": courseName,
    "courseId": courseId,
    "quizCleared": quizCleared,
    "quizAttemptGapForModularQuiz": quizAttemptGapForModularQuiz,
    "quizAttemptGapForCourseQuiz": quizAttemptGapForCourseQuiz,
    "quizname": quizname,
    "quizScore": quizScore,
    "quizTakenTime": quizTakenTime,
    "quizMark": quizMark
  };

  toMap() {}
}
