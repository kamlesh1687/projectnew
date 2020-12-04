import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:projectnew/business_logics/view_models/Search_viewmodel.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';

import 'package:projectnew/utils/Widgets.dart';

import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final String userId;
  SearchView({@required this.userId});
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("building ThirdView");
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CardContainer(
              values: CrdConValue(
                linearGradient:
                    Provider.of<ThemeModelProvider>(context).curretGradient,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Searchtextfield(
                    hinttext: 'Search',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(child: UserList())
          ],
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var value = Provider.of<SearchViewModel>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: value.searchedName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (snapshot.data != null && value.searchedName != '') {
              return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                UserModel searchUserList = UserModel.fromJson(document.data());

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfileView(
                            true,
                            userData: searchUserList,
                            userId: searchUserList.userId,
                          );
                        },
                      ));
                    },
                    child: CustomCardUserList(
                      userList: searchUserList,
                    ),
                  ),
                );
              }).toList());
            }

            return Center(
              child: Text('No User Found'),
            );
          }
          return Center(child: Text('No data'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CustomCardUserList extends StatelessWidget {
  final UserModel userList;

  const CustomCardUserList({Key key, @required this.userList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      values: CrdConValue(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      CachedNetworkImageProvider(userList?.profilePic),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            userList.displayName,
                            // style: Style().cardTitle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userList.email,
                        // style: Style().cardSubTitle,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
class Searchtextfield extends StatelessWidget {
  final hinttext;
  Searchtextfield({@required this.hinttext});

  TextEditingController _searchInputText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var value = Provider.of<SearchViewModel>(context);
    return Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: TextField(
                style: TextStyle(fontSize: 20),
                onChanged: (txt) {
                  value.searchedName = _searchInputText.text;
                },
                controller: _searchInputText,
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: value.searchedName != ''
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            value.searchedName = '';
                            _searchInputText.clear();
                          })
                      : Container(
                          width: 1,
                        ),
                  hintText: hinttext,
                  alignLabelWithHint: true,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ));
  }
}
