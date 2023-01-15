import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class MyPostsTabView extends StatefulWidget {
  var test;

  @override
  MyPostsTabViewState createState() {
    return MyPostsTabViewState();
  }
}

class MyPostsTabViewState extends State<MyPostsTabView> {

  @override
  Widget build(BuildContext context) {
    print("here aaya");
    var data;
    return RefreshIndicator(
      color: Colors.black54,
        onRefresh: () async {
      print("refreshing");
      var temp = await fetchMyArticles();
      setState(() {
        data = temp;
      });
    },
      child: FutureBuilder(
      future: fetchMyArticles(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.black54,));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            print('i am here in following');
          //print(snapshot.data[1][4]);
          print(snapshot.data.length);
          if (snapshot.data.length > 1) {
            return ArticleListViewCommon(snapshot.data);
          }
          else
            {
              return Center(
                child: Text("Your Writups will appear here"),
              );
            }
        }
      },
    ),);
  }
}
