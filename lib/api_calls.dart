import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neptunplus_app/main.dart';

var query = {
  "TotalRowCount": -1,
  "ExceptionsEnum": 0,
  "UserLogin": "",
  "Password": "",
  "NeptunCode": "",
  "CurrentPage": 0,
  "StudentTrainingID": null,
  "LCID": 1038,
  "ErrorMessage": "",
  "MobileVersion": "1.5"
};

String urlDomain = 'neptun.szte.hu';
String urlPath = 'hallgato/MobileService.svc';
Map<String, String> urlHeaders = {'Content-Type': 'application/json'};

// ignore: camel_case_types
class apiCalls {
  static getCurriculums(username, password) async {
    query['UserLogin'] = storage.getItem('username');
    query['Password'] = storage.getItem('password');
    String apiCallName = '/GetCurriculums';
    var response = await getApiCall(apiCallName);
    String errorMessage = jsonDecode(response)['ErrorMessage'];
    if (errorMessage != '') {
      return '';
    }
    return await getApiCall(apiCallName);
  }

  static getMessages() async {
    query['UserLogin'] = storage.getItem('username');
    query['Password'] = storage.getItem('password');
    String apiCallName = '/GetMessages';
    var response = await getApiCall(apiCallName);
    return jsonDecode(response)['MessagesList'];
  }

  static getPeriodTerms() async {
    query['UserLogin'] = storage.getItem('username');
    query['Password'] = storage.getItem('password');
    String apiCallName = '/GetPeriodTerms';
    var response = await getApiCall(apiCallName);
    return jsonDecode(response)['PeriodTermsList'];
  }
}

getApiCall(apiCallName) async {
  var url = Uri.https(urlDomain, '$urlPath/$apiCallName');
  var response =
      await http.post(url, headers: urlHeaders, body: jsonEncode(query));
  return response.body;
}
