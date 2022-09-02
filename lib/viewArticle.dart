import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var articleList = arg['articleList'];
    var thisIndex = arg['thisIndex'];
    PageController controller = PageController(initialPage: thisIndex);
    print("here goes article list ");
    print(articleList.length);
    print(thisIndex);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'writup',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: PageView.builder(
        controller: controller,
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
          print("bookmark value " + articleList[itemIndex + 1][15]);
          if (articleList[itemIndex + 1][15] == 'True' || articleList[itemIndex + 1][15] == 'true') {
            _bookmarkNotifier.value = true;
          }
          else {
            _bookmarkNotifier.value = false;
          }
          print("bookmark value " + _bookmarkNotifier.value.toString());

          return SingleChildScrollView(
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
                      articleList[itemIndex + 1][3],
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
                          articleList[itemIndex + 1][13].toString() +
                          "  |  " +
                          articleList[itemIndex + 1][11].toString(),
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
                          return Center(child: Text('loading...'));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
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
                          },),
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
                                  _bookmarkNotifier.value = !_bookmarkNotifier.value;
                                  articleList[itemIndex + 1][15] = _bookmarkNotifier.value.toString();
                                  toggleBookmark(articleList[itemIndex + 1][0], _bookmarkNotifier.value);
                                },
                                icon: _bookmarkNotifier.value == true ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),);
                            },),
                          Icon(Icons.share_rounded),
                      ],),
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
                  initialRating: articleList[itemIndex + 1][14],
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
                    var prevMyrating = articleList[itemIndex + 1][14];
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
                    articleList[itemIndex + 1][14] = myrating;
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
                );},),
              ],
            ),
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
