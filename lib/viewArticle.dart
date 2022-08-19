import 'package:flutter/material.dart';

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
          return SingleChildScrollView(
            child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  articleList[itemIndex + 1][3],
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
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  articleList[itemIndex + 1][4],
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
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "by " +
                        articleList[itemIndex + 1][1] +
                        "  |  " +
                        articleList[itemIndex + 1][2],
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    articleList[itemIndex + 1][7],
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
                                articleList[itemIndex + 1][5]
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
          ),);
        },
      ),
      //Text(articleList[thisIndex + 1][3]),
    );
  }
}
