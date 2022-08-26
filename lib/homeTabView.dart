import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class HomeTabView extends StatelessWidget {
  var test;
  HomeTabView(this.test);

  @override
  Widget build(BuildContext context) {
    print("here aaya");
    print(test);
    return FutureBuilder(
      future: fetchArticles(),
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
          return ListView.builder(
            itemCount: snapshot.data.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    print("tapped");
                    Navigator.pushNamed(
                      context,
                      '/viewArticle',
                      arguments: {
                        'articleList': snapshot.data,
                        'thisIndex': index,
                      },
                    );
                  },
                  child: Card(
                    elevation: 20,
                    //color: Colors.blueGrey,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data[index + 1][2],
                                style: TextStyle(
                                    fontSize: 26,
                                    //color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    //fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data[index + 1][3],
                                style: TextStyle(
                                    fontSize: 18,
                                    //color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "by " +
                                    snapshot.data[index + 1][13].toString() +
                                    "  |  " +
                                    snapshot.data[index + 1][11].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    //color: Colors.white,
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
                                    ]),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Html(
                                data: snapshot.data[index + 1][12] + '...',
                              ),
                              /*child: Text(
                                snapshot.data[index + 1]
                                        [12] + //.substring(0, 200) +
                                    '...',
                                style: TextStyle(
                                    fontSize: 16,
                                    //color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    //fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),*/
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(Icons.star),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        " " +
                                            snapshot.data[index + 1][4]
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            //color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            //fontStyle: FontStyle.italic,
                                            //letterSpacing: 5,
                                            //wordSpacing: 2,
                                            //backgroundColor: Colors.yellow,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.white70,
                                                  offset: Offset(1, .5),
                                                  blurRadius: 10)
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Spacer(),
                                Spacer(),
                                Icon(Icons.share_rounded),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
