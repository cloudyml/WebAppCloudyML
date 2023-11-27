// certificate model
// To parse this JSON data, do
//
//     final certificateModel = certificateModelFromJson(jsonString);

import 'dart:convert';

CertificateModel certificateModelFromJson(String str) => CertificateModel.fromJson(json.decode(str));

String certificateModelToJson(CertificateModel data) => json.encode(data.toJson());

class CertificateModel {
    CertificateModel({
        this.uid,
        this.name,
        this.course,
        this.finishdate,
    });

    String? uid;
    String? name;
    String? course;
    String? finishdate;

    factory CertificateModel.fromJson(Map<String, dynamic> json) => CertificateModel(
        uid: json["uid"],
        name: json["name"],
        course: json["course"],
        finishdate: json["finishdate"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "course": course,
        "finishdate": finishdate,
    };
}
