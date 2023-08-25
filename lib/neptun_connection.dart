import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

const String host = 'neptun.szte.hu';
const String defaultPath = '/hallgato/MobileService.svc';
final LocalStorage storage = LocalStorage('neptun-plus');
const Map<String, String> defaultHeader = {'Content-Type': 'application/json'};

const Map<String, dynamic> defaultBody = {
  'CurrentPage': '0', //Több oldalas lekérésnél ezt változtatni kell
  'LCID': '1038' //magyar: 1038
};

getCurriculums() async {
  //Mintatantervek lekérése
  String fieldName = 'CurriculumList'; //a számunkra fontos mező neve
  Map<String, dynamic> body =
      await getLoggedInBody(); //bejelentkezett felhasználó 'body-ja'
  const String curriculumsPath = '/GetCurriculums';
  const String path = '$defaultPath$curriculumsPath';
  final url = Uri.https(host, path);
  var responseBody;
  try {
    var response =
        await http.post(url, headers: defaultHeader, body: jsonEncode(body));
    responseBody = jsonDecode(response.body);
    if (responseBody['ErrorMessage'] != '') {
      throw NeptunErrorMessage(responseBody['ErrorMessage']);
    }
  } on NeptunErrorMessage catch (e) {
    throw NeptunErrorMessage(e.errorMessage);
  } catch (e) {
    print(e);
  }
  return responseBody[fieldName];
}

Future<Map<String, dynamic>> getLoggedInBody() async {
  await storage.ready;
  String neptunCode = await storage.getItem('neptunCode');
  String password = await storage.getItem('password');
  Map<String, dynamic> body = Map.from(defaultBody);
  body['UserLogin'] = neptunCode;
  body['Password'] = password;
  return body;
}

appLogin(neptunCode, password) async {
  await storage.ready;
  await storage.setItem('neptunCode', neptunCode);
  await storage.setItem('password', password);
  // ignore: unused_local_variable
  var response;
  try {
    response = await getCurriculums();
  } on NeptunErrorMessage catch (e) {
    throw NeptunErrorMessage(e.errorMessage);
  }
  return true;
}

Future<Map<String, dynamic>> getMessages() async {
  Map<String, dynamic> body = await getLoggedInBody();
  const String messagesPath = '/GetMessages';
  const String path = '$defaultPath$messagesPath';
  final url = Uri.https(host, path);
  var responseBody;
  try {
    var response =
        await http.post(url, headers: defaultHeader, body: jsonEncode(body));
    responseBody = jsonDecode(response.body);
    if (responseBody['ErrorMessage'] != '') {
      throw NeptunErrorMessage(responseBody['ErrorMessage']);
    }
  } on NeptunErrorMessage catch (e) {
    throw NeptunErrorMessage(e.errorMessage);
  } catch (e) {
    print(e);
  }
  var messagesListAndCount = {
    'MessagesList': responseBody['MessagesList'],
    'NewMessagesNumber': responseBody['NewMessagesNumber']
  };

  return messagesListAndCount;
}

Future<List> getPeriodTerms() async {
  Map<String, dynamic> body = await getLoggedInBody();
  const String periodTermsPath = '/GetPeriodTerms';
  const String path = '$defaultPath$periodTermsPath';
  final url = Uri.https(host, path);
  var responseBody;
  try {
    var response =
        await http.post(url, headers: defaultHeader, body: jsonEncode(body));

    responseBody = jsonDecode(response.body);

    if (responseBody['ErrorMessages'] != '') {
      throw NeptunErrorMessage(responseBody['ErrorMessage']);
    }
  } on NeptunErrorMessage catch (e) {
    throw NeptunErrorMessage(e.errorMessage);
  } catch (e) {
    print(e);
  }

  var periodTermsList = responseBody['PeriodTermsList'];
  return periodTermsList;
}

class NeptunErrorMessage implements Exception {
  final String errorMessage;
  NeptunErrorMessage(this.errorMessage);
}
