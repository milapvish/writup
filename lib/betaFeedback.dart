import 'package:flutter/material.dart';
import 'apiCalls.dart';

class BetaFeedback extends StatefulWidget {
  //const CreatArticle({super.key});

  @override
  BetaFeedbackState createState() {
    return BetaFeedbackState();
  }
}

class BetaFeedbackState extends State<BetaFeedback> {
  final _formKey1 = GlobalKey<FormState>();

  final _isPostingNotifier = ValueNotifier<bool>(false);

  final List<String> category = <String>[
    "Bug/Issue",
    "Feedback/Suggestion",
    "Something Else"
  ];

  @override
  Widget build(BuildContext context) {
    _isPostingNotifier.value = false;

    var newFeedback = Map();
    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            'Beta Feedback',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DropdownButtonFormField(
              isExpanded: true,
              hint: Text('Select Category',
                  style: const TextStyle(fontSize: 18)),
              //value: category[0],
              onChanged: (newValue) {
                print("dropdown changed");
              },
              items: category.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(item,
                        style: const TextStyle(fontSize: 18)),
                  );
                },
              ).toList(),
              validator: (value) {
                if (value == null) return "Please select a category";
                newFeedback['category'] = value;
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
                  newFeedback['description'] = value;
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Please describe the issue",
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
              await postFeedback(newFeedback);
              final snackBar = SnackBar(
                content: const Text('Your feedback has been submitted'),
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
