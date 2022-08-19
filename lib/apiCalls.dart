import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';

Future<List<List<dynamic>>> fetchArticles() async {
  final response1 = await http.get(Uri.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vSm94b-IMqp7xuXw-9IFYs2aQvQ44VvCs4B55-RTUcwVhpriFZITrRj5A9yv1DOG5m6GfBo0vDO-Hcx/pub?gid=0&single=true&output=csv'));
  print(response1.body);
  String decoded = Utf8Decoder().convert(response1.bodyBytes);
  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = const CsvToListConverter().convert(decoded);
  print(rowsAsListOfValues);

  //var test = Utf8Decoder().convert(rowsAsListOfValues[1][4]);
  print("holaaaa");
  //print(test);

  return rowsAsListOfValues;
}