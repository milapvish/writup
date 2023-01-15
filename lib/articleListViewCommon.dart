import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleListViewCommon extends StatelessWidget {
  var articleList;
  ArticleListViewCommon(this.articleList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articleList.length - 1,
      itemBuilder: (BuildContext context, int index) {
        final _bookmarkNotifier = ValueNotifier<bool>(false);
        final _followButtonTextNotifier = ValueNotifier<String>("Follow");
        final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);
        if (articleList[index + 1][10] == 'True' ||
            articleList[index + 1][10] == 'true') {
          _bookmarkNotifier.value = true;
        } else {
          _bookmarkNotifier.value = false;
        }
        print("testing follow notifier");
        print(articleList[index + 1][12]);
        _followButtonTextNotifier.value = articleList[index + 1][12];
        if (_followButtonTextNotifier.value == "Following")  {
          _followButtonColorNotifier.value = Colors.black54;
        }
        else {
          _followButtonColorNotifier.value = Colors.black87;
        }
        double topPadding = 1;
        if (index == 0) {
          topPadding = 10;
        }

        if (articleList[index + 1][11] == '') {
          articleList[index + 1][11] =
          "https://firebasestorage.googleapis.com/v0/b/writup-hermit-owl.appspot.com/o/profilepics%2Fdefault_1.png?alt=media&token=97bbff09-0b81-47f3-8a20-e05a22ec3e05";
        }

        return Padding(
          padding: EdgeInsets.only(left: 5, top:topPadding, right: 5, bottom: 2),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                              fontSize: 30,
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
                              fontSize: 16,
                              color: Colors.black54,
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.black54,
                                backgroundImage: NetworkImage(articleList[index + 1][11]),
                                child: Text(""),
                              ),
                              TextButton(
                                onPressed: () async {
                                  print("pressing writer name ");
                                  Navigator.pushNamed(
                                    context,
                                    '/publicProfile',
                                    arguments: {
                                      'userId': articleList[index + 1][1],
                                      'userName':
                                      articleList[index + 1][8].toString(),
                                      'dpUrl': articleList[index + 1][11],
                                    },
                                  );
                                },
                                child: Text(
                                  articleList[index + 1][8].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
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
                                      ]),
                                ),
                              ),
                              ValueListenableBuilder(
                                        valueListenable: _followButtonTextNotifier,
                                        builder: (context, value, _) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              print("follow pressed");
                                              if (_followButtonTextNotifier.value ==
                                                  "Follow") {
                                                _followButtonTextNotifier.value =
                                                "Following";
                                                _followButtonColorNotifier.value =
                                                    Colors.black54;
                                                articleList[index + 1][12] = "Following";
                                              } else {
                                                _followButtonTextNotifier.value =
                                                "Follow";
                                                _followButtonColorNotifier.value =
                                                    Colors.black87;
                                                articleList[index + 1][12] = "Follow";
                                              }
                                              updateUserFollow(
                                                  _followButtonTextNotifier.value,
                                                  articleList[index + 1][1]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                              shape: StadiumBorder(),
                                              primary:
                                              _followButtonColorNotifier.value,
                                              minimumSize: Size(40, 25),
                                            ),
                                            child: Text(
                                                _followButtonTextNotifier.value),
                                          );
                                        },
                                      ),
                            ]),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat.yMMMd().format(
                              DateTime.parse(articleList[index + 1][6])),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
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
                    //Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    if (articleList[index + 1][4] > 0)
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
                              Text(
                                " by",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 3,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),
                              Text(
                                    " " + articleList[index + 1][5].toString(),
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
                              Text(
                                " readers",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 3,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),
                            ],
                          ),
                          Spacer(),
                          Spacer(),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ValueListenableBuilder(
                                valueListenable: _bookmarkNotifier,
                                builder: (context, value, _) {
                                  return IconButton(
                                    onPressed: () {
                                      _bookmarkNotifier.value =
                                      !_bookmarkNotifier.value;
                                      articleList[index + 1][10] =
                                          _bookmarkNotifier.value.toString();
                                      toggleBookmark(articleList[index + 1][0],
                                          _bookmarkNotifier.value);
                                    },
                                    icon: _bookmarkNotifier.value == true
                                        ? Icon(Icons.bookmark)
                                        : Icon(Icons.bookmark_border),
                                  );
                                },
                              ),
                              Icon(Icons.share_rounded),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (articleList[index + 1][4] <= 0)
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
                                    " No ratings",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
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
                              ],
                            ),
                            Spacer(),
                            Spacer(),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ValueListenableBuilder(
                                  valueListenable: _bookmarkNotifier,
                                  builder: (context, value, _) {
                                    return IconButton(
                                      onPressed: () {
                                        _bookmarkNotifier.value =
                                        !_bookmarkNotifier.value;
                                        articleList[index + 1][10] =
                                            _bookmarkNotifier.value.toString();
                                        toggleBookmark(articleList[index + 1][0],
                                            _bookmarkNotifier.value);
                                      },
                                      icon: _bookmarkNotifier.value == true
                                          ? Icon(Icons.bookmark)
                                          : Icon(Icons.bookmark_border),
                                    );
                                  },
                                ),
                                Icon(Icons.share_rounded),
                              ],
                            ),
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


Future<String> fetchDPUrl(user_id) async {
  final storageRef = FirebaseStorage.instance.ref();
  print("profilepics/" + user_id.toString() + ".jpeg");
  final testImagesRef = storageRef.child("profilepics/" + user_id.toString() + ".jpeg");

  var testurl = '';
  try {
    testurl = await testImagesRef.getDownloadURL();
  }
  catch (e) {
    final testImagesRef = storageRef.child("profilepics/writup.app.png");
    testurl = await testImagesRef.getDownloadURL();
  }
  print("testurl is " + testurl);
  return testurl;
}
