import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/ui/screens/home_views/Feed_view.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  @override
  void initState() {
    var _data = context.read<ProfileViewModel>();
    print(_data.userID);
    if (_data.isLoggedIn != null && _data.isLoggedIn) {
      context.read<FeedViewModel>().createFeed(_data.userID);

      _data.getUserDataOnline(_data.userID);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _data = Provider.of<FeedViewModel>(context);
    print('homeView');
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          indexcontroller.add(index);
        },
        controller: _data.pageController,
        children: <Widget>[
          FeedView(),
          Container(),
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
                var _value = context.read<FeedViewModel>();
                indexcontroller.add(value);
                _value.pageController.jumpToPage(value);
              },
            );
          }),
    );
  }
}
