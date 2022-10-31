import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class HashTagPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var hashTag = arg['hashTag'];
    print(hashTag);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 40)),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
          child: FittedBox(
          child: Text(hashTag,
            style: TextStyle(
                fontSize: 40,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                //fontStyle: FontStyle.italic,
                //letterSpacing: 3,
                //wordSpacing: 2,
                //backgroundColor: Colors.yellow,
                shadows: [
                  Shadow(
                      color: Colors.black38,
                      offset: Offset(.5, .5),
                      blurRadius: 10)
                ]),),),),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder(
            future: fetchArticlesByHashTag(hashTag),
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
                  child: ArticleListViewCommon(snapshot.data),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
