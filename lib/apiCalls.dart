import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'consts.dart';

Future<List<List<dynamic>>> fetchArticles() async {

  String rawJson = jsonEncode('all');   // to fetch all articles
  var url = baseBackendUrl + '/fetchArticles';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

  return rowsAsListOfValues;
}

Future<String> postArticle(Map newArticle) async {
  print(newArticle['detail']);
  String rawJson = jsonEncode(newArticle);
  //String encoded = Utf8Encoder().convert(rawJson);
  var url = baseBackendUrl + '/createArticle';
  final response = await http.post(Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: rawJson
  );
  print("getting response for post");
  print (response.statusCode);
  print(response.body);
  return "success";
}


Future<List<List<dynamic>>> fetchArticleDetail( int id ) async {
  String rawJson = jsonEncode(id);
  var url = baseBackendUrl + '/fetchArticleDetail';
  final response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: rawJson
  );
  String decoded = Utf8Decoder().convert(response.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);
  print("holaaaa");

  return rowsAsListOfValues;
}

