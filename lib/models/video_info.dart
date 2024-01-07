class VideoInfoModel {
  Body? body;

  VideoInfoModel({this.body});

  VideoInfoModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  String? otp;
  String? playbackInfo;

  Body({this.otp, this.playbackInfo});

  Body.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    playbackInfo = json['playbackInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['playbackInfo'] = this.playbackInfo;
    return data;
  }
}
