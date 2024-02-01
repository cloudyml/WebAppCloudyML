// To parse this JSON data, do
//
//     final studentReviewsModel = studentReviewsModelFromJson(jsonString);

import 'dart:convert';

StudentReviewsModel studentReviewsModelFromJson(String str) => StudentReviewsModel.fromJson(json.decode(str));

String studentReviewsModelToJson(StudentReviewsModel data) => json.encode(data.toJson());

class StudentReviewsModel {
    List<Review>? reviews;
    Avgrating? avgrating;

    StudentReviewsModel({
        this.reviews,
        this.avgrating,
    });

    factory StudentReviewsModel.fromJson(Map<String, dynamic> json) => StudentReviewsModel(
        reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
        avgrating: json["avgrating"] == null ? null : Avgrating.fromJson(json["avgrating"]),
    );

    Map<String, dynamic> toJson() => {
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "avgrating": avgrating?.toJson(),
    };
}

class Avgrating {
    double? one;
    int? two;
    double? three;
    double? four;
    double? five;
    dynamic total;

    Avgrating({
        this.one,
        this.two,
        this.three,
        this.four,
        this.five,
        this.total,
    });

    factory Avgrating.fromJson(Map<String, dynamic> json) => Avgrating(
        one: json["one"]?.toDouble(),
        two: json["two"],
        three: json["three"]?.toDouble(),
        four: json["four"]?.toDouble(),
        five: json["five"]?.toDouble(),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "one": one,
        "two": two,
        "three": three,
        "four": four,
        "five": five,
        "total": total,
    };
}

class Review {
    DateTime? date;
    String? uid;
    String? linkdinlink;
    String? name;
    String? course;
    String? id;
    String? experience;
    String? email;
    String? reviewdescription;
    String? rating;

    Review({
        this.date,
        this.uid,
        this.linkdinlink,
        this.name,
        this.course,
        this.id,
        this.experience,
        this.email,
        this.reviewdescription,
        this.rating,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        uid: json["uid"],
        linkdinlink: json["linkdinlink"],
        name: json["name"],
        course: json["course"],
        id: json["id"],
        experience: json["experience"],
        email: json["email"],
        reviewdescription: json["reviewdescription"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "uid": uid,
        "linkdinlink": linkdinlink,
        "name": name,
        "course": course,
        "id": id,
        "experience": experience,
        "email": email,
        "reviewdescription": reviewdescription,
        "rating": rating,
    };
}
