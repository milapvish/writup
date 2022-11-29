import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleListViewCommon extends StatelessWidget {
  var articleList;
  ArticleListViewCommon(this.articleList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articleList.length - 1,
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
                  'articleList': articleList,
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
                          articleList[index + 1][2],
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
                    if (articleList[index + 1][3] != '')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          articleList[index + 1][3],
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
                              articleList[index + 1][8].toString() +
                              "  |  " +
                              articleList[index + 1][6].toString(),
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
                    // below if condition handles extra </p> html tag at the end
                    if (articleList[index + 1][7].length > 4)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Html(
                          data: articleList[index + 1][7].substring(0, articleList[index + 1][7].length -4) + '...',
                        ),
                                /*child: Text(
                                articleList[index + 1]
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
                    if (articleList[index + 1][7].length <= 4)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Html(
                            data: articleList[index + 1][7] + '...',
                          ),
                          /*child: Text(
                                articleList[index + 1]
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.star),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  " " + articleList[index + 1][4].toString(),
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
}
