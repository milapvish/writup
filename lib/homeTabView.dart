import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class HomeTabView extends StatefulWidget {
  var test;
  HomeTabView(this.test);

  @override
  HomeTabViewState createState() {
    return HomeTabViewState();
  }
}

class HomeTabViewState extends State<HomeTabView> {

  @override
  Widget build(BuildContext context) {
    print("here aaya");
    var data;
    return RefreshIndicator(
      color: Colors.black54,
      onRefresh: () async {
      print("refreshing");
      var temp = await fetchArticles();
      setState(() {
        data = temp;
      });
      },
      child: FutureBuilder(
      future: fetchArticles(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.black54,));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            print('i am here');
          print(snapshot.data);
          print("data 0");
          print(snapshot.data[0][4]);
          print(snapshot.data.length);
          data = snapshot.data;
          return ArticleListViewCommon(data);
        }
      },
    ),);
  }
}
