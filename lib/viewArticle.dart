import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ViewArticle extends StatefulWidget {
  //const ViewArticle({super.key});
  //final arg = ModalRoute.of(context)!.settings.arguments as Map;

  @override
  ViewArticleState createState() {
    return ViewArticleState();
  }
}

class ViewArticleState extends State<ViewArticle> {
  //PageController controller = PageController();

  // These variables are to access article in AppBar for reporting/deletion
  var thisArticle;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var articleList = arg['articleList'];
    var thisIndex = arg['thisIndex'];
    PageController controller = PageController(initialPage: thisIndex);
    print("here goes article list ");
    print(articleList.length);
    print(thisIndex);
    final _followButtonTextNotifier = ValueNotifier<String>("Follow");
    final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);

    //thisArticle = articleList[thisIndex + 1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'writup',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                //thisArticle[2]
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Report"),
                  ),
                ];
              },
              onSelected:(value) {
                if (value == 0) {
                  print("Report is selected.");
                  Navigator.pushNamed(
                    context,
                    '/reportArticle',
                    arguments: {
                      'thisArticle': thisArticle,
                    },
                  );
                }
              }
          ),
        ],
      ),
      body: PageView.builder(
        controller: controller,
        onPageChanged: (itemIndex) {
          print("page changed ");
          setState(() {
            thisArticle = articleList[itemIndex + 1];
          });
        },
        itemCount: articleList.length - 1,
        itemBuilder: (BuildContext context, int itemIndex) {
          // define notifiers
          final _ratingNotifier = ValueNotifier<double>(0.0);
          final _nbrRatingsNotifier = ValueNotifier<int>(0);
          final _bookmarkNotifier = ValueNotifier<bool>(false);
          _ratingNotifier.value = articleList[itemIndex + 1][4];
          print("printing this");
          print(articleList[itemIndex + 1][5]);
          _nbrRatingsNotifier.value = articleList[itemIndex + 1][5].toInt();
          print("aakhir hai kitna " + articleList[itemIndex + 1][4].toString());
          //print("bookmark value " + articleList[itemIndex + 1][10]);
          if (articleList[itemIndex + 1][10] == 'True' ||
              articleList[itemIndex + 1][10] == 'true' ||
              articleList[itemIndex + 1][10] == 1) {
            _bookmarkNotifier.value = true;
          } else {
            _bookmarkNotifier.value = false;
          }
          print("bookmark value " + _bookmarkNotifier.value.toString());
          if (firstTime == true) {
            thisArticle = articleList[itemIndex + 1];
            firstTime = false;
          }

          _followButtonTextNotifier.value = articleList[itemIndex + 1][12];
          if (_followButtonTextNotifier.value == "Following")  {
            _followButtonColorNotifier.value = Colors.black54;
          }
          else {
            _followButtonColorNotifier.value = Colors.black87;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.5),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      articleList[itemIndex + 1][2],
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black87,
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
                      articleList[itemIndex + 1][3],
                      style: TextStyle(
                          fontSize: 18,
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
                            backgroundImage: NetworkImage(articleList[itemIndex + 1][11]),
                            child: Text(""),
                          ),
                          TextButton(
                            onPressed: () async {
                              print("pressing writer name ");
                              Navigator.pushNamed(
                                context,
                                '/publicProfile',
                                arguments: {
                                  'userId': articleList[itemIndex + 1][1],
                                  'userName':
                                      articleList[itemIndex + 1][8].toString(),
                                },
                              );
                            },
                            child: Text(
                              articleList[itemIndex + 1][8].toString(),
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
                                            articleList[itemIndex + 1][12] = "Following";
                                          } else {
                                            _followButtonTextNotifier.value =
                                                "Follow";
                                            _followButtonColorNotifier.value =
                                                Colors.black87;
                                            articleList[itemIndex + 1][12] = "Follow";
                                          }
                                          updateUserFollow(
                                              _followButtonTextNotifier.value,
                                              articleList[itemIndex + 1][1]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                          shape: StadiumBorder(),
                                          primary:
                                              _followButtonColorNotifier.value,
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
                          DateTime.parse(articleList[itemIndex + 1][6])),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(Icons.star),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ValueListenableBuilder(
                              valueListenable: _ratingNotifier,
                              builder: (context, value, _) {
                                if (value == null) {
                                  value = 0;
                                }
                                String valueStr = value.toString();
                                if (valueStr.length > 4) {
                                  valueStr = valueStr.substring(0, 4);
                                }
                                return Text(
                                  " " + (valueStr),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
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
                                );
                              },
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
                          ValueListenableBuilder(
                            valueListenable: _nbrRatingsNotifier,
                            builder: (context, value, _) {
                              return Text(
                                " " + value.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
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
                              );
                            },
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
                                  articleList[itemIndex + 1][10] =
                                      _bookmarkNotifier.value.toString();
                                  toggleBookmark(articleList[itemIndex + 1][0],
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
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      future: fetchArticleDetail(articleList[itemIndex + 1][0]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text(''));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            print('i am here substring');
                          //print(snapshot.data[1][4]);
                          print(snapshot.data.length);
                          var detailWritup;
                          detailWritup = snapshot.data[1][1];
                          print(snapshot.data[1][1].substring(0, 3));
                          if (snapshot.data[1][1].substring(0, 3) == '<p>') {
                            print("inside substring");
                            detailWritup = snapshot.data[1][1].substring(3, detailWritup.length);
                          }
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: detailWritup,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(17.0),
                                  //fontWeight: FontWeight.bold,
                                ),
                              },
                            ),
                          );
                        }
                      },
                    ),
                    /* child: Text(
                    articleList[itemIndex + 1][12],
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      future: fetchArticleTags(articleList[itemIndex + 1][0]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text(''));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            print('i am here 456');
                          //print(snapshot.data[1][4]);
                          print(snapshot.data.length);
                          if (snapshot.data.length > 1) {
                            print(snapshot.data[1][0]);
                            return Align(
                              alignment: Alignment.centerLeft,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 4,
                                  runSpacing: 1,
                                  children: <Widget>[
                                    for (int index = 1; index < snapshot.data.length; index++)
                                        ElevatedButton(
                                          onPressed: () async {
                                            print("tag pressed");
                                            Navigator.pushNamed(
                                              context,
                                              '/hashTagPosts',
                                              arguments: {
                                                'hashTag': snapshot.data[index][0],
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                            shape: StadiumBorder(),
                                            primary: Colors.black54,
                                          ),
                                          child:
                                              Text(snapshot.data[index][0]),
                                        ),
                                    ],
                                ),
                            );
                          }
                          else {
                            return Text("");
                          }
                        }
                      },
                    ),
                  ),
                ),
                //ArticleDetailHtml(articleList[itemIndex + 1][0]),
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
                            child: ValueListenableBuilder(
                              valueListenable: _ratingNotifier,
                              builder: (context, value, _) {
                                if (value == null) {
                                  value = 0;
                                }
                                String valueStr = value.toString();
                                if (valueStr.length > 4) {
                                  valueStr = valueStr.substring(0, 4);
                                }
                                return Text(
                                  " " + (valueStr),
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
                                );
                              },
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
                          ValueListenableBuilder(
                            valueListenable: _nbrRatingsNotifier,
                            builder: (context, value, _) {
                              return Text(
                                " " + value.toString(),
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
                              );
                            },
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
                                  articleList[itemIndex + 1][10] =
                                      _bookmarkNotifier.value.toString();
                                  toggleBookmark(articleList[itemIndex + 1][0],
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
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Text(
                  "YOUR RATING",
                  style: TextStyle(
                      fontSize: 20,
                      //color: Colors.white,
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: 3,
                      //wordSpacing: 2,
                      //backgroundColor: Colors.yellow,
                      shadows: [
                        Shadow(
                            color: Colors.white70,
                            offset: Offset(1, .5),
                            blurRadius: 10)
                      ]),
                ),
                RatingBar.builder(
                  initialRating: articleList[itemIndex + 1][9].toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 10,
                  itemSize: 30.0,
                  //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  onRatingUpdate: (myrating) {
                    print("my rating is : ");
                    print(myrating);
                    var prevMyrating = articleList[itemIndex + 1][9];
                    if (prevMyrating == 0) {
                      // not rated previously
                      _ratingNotifier.value =
                          (_ratingNotifier.value * _nbrRatingsNotifier.value +
                                  myrating) /
                              (_nbrRatingsNotifier.value + 1);
                      _nbrRatingsNotifier.value = _nbrRatingsNotifier.value + 1;
                    } else {
                      _ratingNotifier.value =
                          (_ratingNotifier.value * _nbrRatingsNotifier.value -
                                  prevMyrating +
                                  myrating) /
                              _nbrRatingsNotifier.value;
                    }
                    articleList[itemIndex + 1][4] = _ratingNotifier.value;
                    articleList[itemIndex + 1][5] = _nbrRatingsNotifier.value;
                    articleList[itemIndex + 1][9] = myrating;
                    postRating(articleList[itemIndex + 1][0], myrating);
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  "GLOBAL RATING",
                  style: TextStyle(
                      fontSize: 20,
                      //color: Colors.white,
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: 3,
                      //wordSpacing: 2,
                      //backgroundColor: Colors.yellow,
                      shadows: [
                        Shadow(
                            color: Colors.white70,
                            offset: Offset(1, .5),
                            blurRadius: 10)
                      ]),
                ),
                ValueListenableBuilder(
                  valueListenable: _ratingNotifier,
                  builder: (context, value, _) {
                    return RatingBarIndicator(
                      rating: _ratingNotifier.value,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                      itemCount: 10,
                      itemSize: 30.0,
                      direction: Axis.horizontal,
                    );
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 40)),
              ],
            ),),
          );
        },
      ),
      //Text(articleList[thisIndex + 1][3]),
    );
  }
}

class ArticleDetailHtml extends StatelessWidget {
  var articleID;
  ArticleDetailHtml(this.articleID);

  @override
  Widget build(BuildContext context) {
    print("ArticleDetailHtml");
    print(articleID);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FutureBuilder(
          future: fetchArticleDetail(articleID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else
                print('i am here 123');
              //print(snapshot.data[1][4]);
              print(snapshot.data.length);
              return Align(
                alignment: Alignment.centerLeft,
                child: Html(
                  data: snapshot.data[1][1],
                ),
              );
            }
          },
        ),
        /* child: Text(
                    articleList[itemIndex + 1][12],
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
    );
  }
}
