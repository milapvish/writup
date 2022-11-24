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
    //print("JWT is " + jwt);
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
  //print(rowsAsListOfValues);

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
  //print(response.body);
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
  //print(rowsAsListOfValues);
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
  //print(rowsAsListOfValues);

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
  //print(rowsAsListOfValues);

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> toggleBookmark(int post_id, bool bookmark) async {
  print(post_id);
  print(bookmark);
  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['post_id'] = post_id;
  jsonMap['bookmark'] = bookmark;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);//

  var url = baseBackendUrl + '/toggleBookmark';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  return rowsAsListOfValues;
}


Future<List<List<dynamic>>> fetchArticlesByUserID(int userId) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['userId'] = userId;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/fetchArticlesByUserID';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> updateUserFollow(String followStr, int userId) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['userId'] = userId;
  jsonMap['followStr'] = followStr;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/updateUserFollow';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}


Future<String> checkUserFollow(int userId) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['userId'] = userId;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/checkUserFollow';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  //print(decoded);

  return decoded;
}


Future<List<List<dynamic>>> fetchAccountDetails( int userId ) async {

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode(userId);
  var url = baseBackendUrl + '/fetchAccountDetails';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);
  print("holaaaa");

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchArticleTags( int postid ) async {

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode(postid);
  var url = baseBackendUrl + '/fetchArticleTags';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);
  print("holaaaa");

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchArticlesByHashTag(String hashTag) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['hashTag'] = hashTag;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/fetchArticlesByHashTag';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<String> checkHashTagFollow(String hashTag) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['hashTag'] = hashTag;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/checkHashTagFollow';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  //print(decoded);

  return decoded;
}

Future<List<List<dynamic>>> updateHashTagFollow(String followStr, String hashTag) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['hashTag'] = hashTag;
  jsonMap['followStr'] = followStr;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/updateHashTagFollow';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchFollowingArticles() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('following');
  var url = baseBackendUrl + '/fetchFollowingArticles';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchMyArticles() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('my');
  var url = baseBackendUrl + '/fetchMyArticles';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchSavedPosts() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('saved');
  var url = baseBackendUrl + '/fetchSavedPosts';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchMyFollowers() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('followers');
  var url = baseBackendUrl + '/fetchMyFollowers';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchFollowingUsers() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('following');
  var url = baseBackendUrl + '/fetchFollowingUsers';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}


Future<List<List<dynamic>>> searchArticles(String searchTerm) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['searchTerm'] = searchTerm;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/searchArticles';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<String> getNbrUnreadNotifs() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/getNbrUnreadNotifs';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  //print(decoded);

  return decoded;
}


Future<List<List<dynamic>>> fetchNotifications() async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  String rawJson = jsonEncode('notifications');
  var url = baseBackendUrl + '/fetchNotifications';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}

Future<List<List<dynamic>>> fetchArticleByPostID(int postId) async {

  // get JWT and store in global variable
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['postId'] = postId;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/fetchArticleByPostID';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  //print(rowsAsListOfValues);

  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  JUST FOR INITIALIZING FIREBASE ONCE */

  return rowsAsListOfValues;
}
void markNotifSeen(int notifNbr, String notifType) async {

  // get JWT and store in global variable
  print("going to mark notif seen");
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final jwt = await user.getIdToken();
    print("JWT is " + jwt);
    jwtGlobal = jwt;
  }

  // define and create json
  var jsonMap = Map();
  jsonMap['notifNbr'] = notifNbr;
  jsonMap['notifType'] = notifType;
  String rawJson = jsonEncode(jsonMap);
  print(rawJson);

  var url = baseBackendUrl + '/markNotifSeen';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer $jwtGlobal',},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

}