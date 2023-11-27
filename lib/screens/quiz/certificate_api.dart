import 'dart:convert';

import 'package:cloudyml_app2/screens/quiz/certificatemodel.dart';
import 'package:http/http.dart' as http;
import 'package:cloudyml_app2/global_variable.dart' as globals;

void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
class certificateApi {
  static getCertificate(CertificateModel certificateInfo) async {
    print(certificateInfo.toJson());
    var url = Uri.parse(
        'https://us-central1-cloudyml-app.cloudfunctions.net/certificate/certificate');
    var response = await http.post(url, body: certificateInfo.toJson());
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print('aaaaaaaaaaaa');
      printWrapped("aaaaabbb==$jsonString");
      globals.downloadCertificateLink = jsonString.toString().trim();
    } else {
      print(response.statusCode);
      print(response.body);
      
      throw Exception('Failed to load certificate');
    }
  }
}
