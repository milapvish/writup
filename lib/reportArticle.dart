import 'package:flutter/material.dart';
import 'apiCalls.dart';

class ReportArticle extends StatefulWidget {
  //const CreatArticle({super.key});

  @override
  ReportArticleState createState() {
    return ReportArticleState();
  }
}

class ReportArticleState extends State<ReportArticle> {
  final _formKey1 = GlobalKey<FormState>();

  final _isPostingNotifier = ValueNotifier<bool>(false);

  final List<String> category = <String>[
    "Plagiarism/Copyright",
    "Hate Speech",
    "False Information",
    "Suicide or Self Injury",
    "Harassment",
    "Violence",
    "Terrorism",
    "Something Else"
  ];

  @override
  Widget build(BuildContext context) {
    _isPostingNotifier.value = false;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var thisArticle = arg['thisArticle'];
    var newReport = Map();
    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Report Writup',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            DropdownButtonFormField(
              isExpanded: true,
              hint: Text('Select Category'),
              //value: category[0],
              onChanged: (newValue) {
                print("dropdown changed");
              },
              items: category.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(item),
                  );
                },
              ).toList(),
              validator: (value) {
                if (value == null) return "Please select a category";
                newReport['category'] = value;
                return null;
              },
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            SizedBox(
              //height: 500,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description can't be empty";
                  }
                  newReport['description'] = value;
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Description and relevant links",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 500,
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('done pressed');
            if (_formKey1.currentState!.validate()) {
              print("form valid");
              _isPostingNotifier.value = true;
              newReport['post_id'] = thisArticle[0];
              await postReport(newReport);
              final snackBar = SnackBar(
                content: const Text('Your report has been submitted'),
                backgroundColor: (Colors.black87),
                //action: SnackBarAction(
                //  label: 'dismiss',
                //  onPressed: () {},
               // ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            }
          },
          //label: const Text('4K'),
          child: ValueListenableBuilder(
            valueListenable: _isPostingNotifier,
            builder: (context, value, _) {
              if (_isPostingNotifier.value == false) {
                return Icon(Icons.done);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}
