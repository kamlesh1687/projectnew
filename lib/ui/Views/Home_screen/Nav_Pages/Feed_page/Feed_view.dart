import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/Upload_page/Uploadscreen_view.dart';

class FeedView extends StatefulWidget {
  final String userId;
  FeedView({@required this.userId});
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Building SecondView");
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadScreen(widget.userId)));
            },
            child: Icon(Icons.add_a_photo_outlined)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
