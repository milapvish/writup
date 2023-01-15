class CreateArticleDetailState extends State<CreateArticleDetail> {
  final _formKey1 = GlobalKey<FormState>();

  final _isPostingNotifier = ValueNotifier<bool>(false);
  final _isEmptyNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _isPostingNotifier.value = false;
    _isEmptyNotifier.value = false;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var newArticle = arg['newArticle'];
    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'write article',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              HtmlEditor(
                controller: htmlcontroller, //required
                callbacks: Callbacks(onInit: () {
                  //htmlcontroller.setFullScreen();
                }),
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Write as much as you want :)",
                  autoAdjustHeight: true,
                  //initalText: "text content initial, if any",
                ),
                otherOptions: OtherOptions(
                  //height: 700,
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    //StyleButtons(),
                    FontButtons(
                        clearAll: false,
                        strikethrough: false,
                        superscript: false,
                        subscript: false),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ValueListenableBuilder(
                valueListenable: _isPostingNotifier,
                builder: (context, value, _) {
                  if (_isEmptyNotifier.value == true) {
                    return Text(
                      "Writup can't be empty",
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    );
                  }
                  return Text("");
                },
              ),
              //Padding(padding: EdgeInsets.symmetric(vertical: 60)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('done pressed');
            _isPostingNotifier.value = true;
            String inpHtml = await htmlcontroller.getText();
            newArticle['detail'] = inpHtml;
            print(inpHtml);
            _isEmptyNotifier.value = false;
            if (inpHtml.length < 1) {
              _isEmptyNotifier.value = true;
              _isPostingNotifier.value = false;
            } else {
              if (_formKey1.currentState!.validate()) {
                print("form valid");
                //print(newArticle['details']);
                await postArticle(newArticle);
                final snackBar = SnackBar(
                  content: const Text('Your Writup has been posted !!'),
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
            }
            //Navigator.pushNamed(context, '/createArticle');
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
          backgroundColor: floatingButtonColor,
        ),
      ),
    );
  }
}