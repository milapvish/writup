import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'consts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

Future<List<List<dynamic>>> fetchArticles() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('all');   // to fetch all articles
  var url = baseBackendUrl + '/fetchArticles';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
                'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<String> postArticle(Map newArticle) async {

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode(newArticle);
  //String encoded = Utf8Encoder().convert(rawJson);
  var url = baseBackendUrl + '/createArticle';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  print("getting response for post");
  print (response.statusCode);
  print(response.body);
  return "success";
}


Future<List<List<dynamic>>> fetchArticleDetail( int postid ) async {

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode(postid);
  var url = baseBackendUrl + '/fetchArticleDetail';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);
  print("holaaaa");

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> createAccount(String email, String name) async {
  print(email);
  print(name);
  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['email'] = email;
  jsonMap['name'] = name;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);//

  var url = baseBackendUrl + '/createAccount';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> postRating(int post_id, double rating) async {
  print(post_id);
  print(rating);
  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['post_id'] = post_id;
  jsonMap['rating'] = rating;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);//

  var url = baseBackendUrl + '/postRating';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

  return rowsAsListOfValues;
}