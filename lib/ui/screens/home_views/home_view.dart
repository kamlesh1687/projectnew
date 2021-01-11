import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/ui/screens/home_views/Feed_view.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/ui/screens/other_views/Chat_view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/homeView';
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  PageController pageController = PageController(initialPage: 0);
  @override
  @override
  Widget build(BuildContext context) {
    print('homeView');
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          indexcontroller.add(index);
        },
        controller: pageController,
        children: <Widget>[
          FeedView(),
          ChatView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: StreamBuilder<Object>(
          initialData: 0,
          stream: indexcontroller.stream,
          builder: (context, snapshot) {
            int cIndex = snapshot.data;
            return BottomNavigationBar(
              currentIndex: cIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.inbox), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
              onTap: (int value) {
                indexcontroller.add(value);
                pageController.jumpToPage(value);
              },
            );
          }),
    );
  }
}
