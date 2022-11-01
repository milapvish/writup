import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class SavedPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _followButtonTextNotifier = ValueNotifier<String>("Follow");
    final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 30)),
          Icon(Icons.bookmarks, size: 100),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Text("Saved Writups",
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                //fontStyle: FontStyle.italic,
                //letterSpacing: 5,
                //wordSpacing: 2,
                //backgroundColor: Colors.yellow,
                shadows: [
                  Shadow(
                      color: Colors.white70,
                      offset: Offset(1, .5),
                      blurRadius: 10)
                ]),),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder(
            future: fetchSavedPosts(),
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
