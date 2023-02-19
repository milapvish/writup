import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class FollowingTabView extends StatefulWidget {
  var test;

  @override
  FollowingTabViewState createState() {
    return FollowingTabViewState();
  }
}

class FollowingTabViewState extends State<FollowingTabView> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("here aaya");
    var data;
    return RefreshIndicator(
      color: Colors.black54,
        onRefresh: () async {
      print("refreshing");
      var temp = await fetchFollowingArticles();
      setState(() {
        data = temp;
      });
    },
      child: FutureBuilder(
      future: fetchFollowingArticles(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.black54,));
        } else {
          if (snapshot.hasError)
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Network Error"),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  IconButton(
                    onPressed: () async {
                      var temp = await fetchArticles();
                      setState(() {
                        data = temp;
                      });
                    },
                    icon: Icon(Icons.refresh_rounded,
                      size: 40,
                      color: Colors.black54,),
                  )
                ],),
            );
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text("Writups from hashtags and people you follow appear here"),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    IconButton(
                      onPressed: () async {
                        var temp = await fetchFollowingArticles();
                        setState(() {
                          data = temp;
                        });
                      },
                      icon: Icon(Icons.refresh_rounded,
                      size: 40,
                      color: Colors.black54,),
                    )
              ],),
            );
          }
        }
      },
    ),);
  }
}
