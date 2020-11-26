import 'package:flutter/material.dart';
import 'package:projectnew/ui/screens/other_views/Uploadscreen_view.dart';

import 'package:projectnew/utils/reusableWidgets/PageRoute.dart';

class FeedView extends StatelessWidget {
  final String userId;
  FeedView({@required this.userId});
  @override
  @override
  Widget build(BuildContext context) {
    print("Building SecondView");
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MyCustomPageRoute(
                      previousPage: this,
                      builder: (context) => UploadScreen(userId)));
            },
            child: Icon(Icons.add_a_photo_outlined)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("hello guys ,texting her" * 50),
            )
          ],
        ));
  }
}
