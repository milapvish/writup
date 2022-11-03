import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const historyLength = 10;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  Future<List<String>> readSearchHistory() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    //await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);
    final List<String>? items = prefs.getStringList('items');
    List<String> temp = [];
    temp = items ?? [];
    print("let's see what playerprefs return");
    print(temp);
    _searchHistory = temp;
    filteredSearchHistory = filterSearchTerms(filter: '');
    setState(() {
      _searchHistory = temp;
      filteredSearchHistory = filterSearchTerms(filter: '');
    });
    return temp;
  }

  void writeSearchHistory() async {
    print("going to write prefs");
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Remove data for the 'counter' key.
    final success = await prefs.remove('items');
    await prefs.setStringList('items', _searchHistory);
  }

  List<String> filteredSearchHistory = [];

  String selectedTerm = '';

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    writeSearchHistory();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
    writeSearchHistory();
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
    readSearchHistory();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //readSearchHistory();
    //print("_searchHistory");
    //print(_searchHistory);
    List<List<dynamic>> rowsAsListOfValues = [];
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'The Search App',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search writups and hashtags...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) async {
          print("on submit search");
          rowsAsListOfValues = await fetchMyArticles();
          print(rowsAsListOfValues);
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          writeSearchHistory();
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("yahan dekho");
    if (searchTerm == null || searchTerm == '') {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Search results appear here',
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
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);

    return Column(
      children: <Widget>[
        //padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
        Padding(padding: EdgeInsets.only(top: 55)),
        FutureBuilder(
          future: searchArticles(searchTerm),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else
                print('i am here in search');
              //print(snapshot.data[1][4]);
              print(snapshot.data.length);
              return Flexible(
                child: ArticleListViewCommon(snapshot.data),
              );
            }
          },
        ),
      ],
    );
  }
}
