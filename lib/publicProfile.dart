import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class PublicProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var userId = arg['userId'];
    var userName = arg['userName'];
    print(userName);
    print(userId);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 30)),
          Text("Here"),
      FutureBuilder(
      future: fetchArticlesByUserID(userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            print('i am here');
          //print(snapshot.data[1][4]);
          print(snapshot.data.length);
          return Flexible(
              child: ArticleListViewCommon(snapshot.data),);
        }
      },
    ),
        ],
      ),
    );
  }
}