import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class MyPostsTabView extends StatelessWidget {
  var test;
  //HomeTabView(this.test);

  @override
  Widget build(BuildContext context) {
    print("here in my posts tab");
    print(test);
    return FutureBuilder(
      future: fetchMyArticles(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            print('i am here in following');
          //print(snapshot.data[1][4]);
          print(snapshot.data.length);
          return ArticleListViewCommon(snapshot.data);
        }
      },
    );
  }
}
