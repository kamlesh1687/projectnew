import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_view.dart';
import 'package:projectnew/utils/reusableWidgets/PageRoute.dart';

class TestClassProfile extends StatelessWidget {
  final String userId;

  const TestClassProfile({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("page1");
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: RaisedButton(
            child: Text("page 2"),
            onPressed: () => Navigator.push(
                context,
                MyCustomPageRoute(
                    previousPage: this,
                    builder: (context) => ProfileView(userId)))),
      ),
    );
  }
}

class TestClass2 extends StatefulWidget {
  @override
  _TestClass2State createState() => _TestClass2State();
}

class _TestClass2State extends State<TestClass2> {
  @override
  Widget build(BuildContext context) {
    print("page2");
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: RaisedButton(
          child: Text("page 1"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
