import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';

import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:projectnew/features/presentation/providers/Search_viewmodel.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/properties.dart';

import 'package:provider/provider.dart';
import 'package:projectnew/utils/reusableWidgets/customAppBar.dart';

class SearchView extends StatefulWidget {
  static const routeName = '/searchView';
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    print("building ThirdView");
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
                appBar: customAppBar('Search', context),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CardContainer(
                        values: CrdConValue(
                          linearGradient:
                              Provider.of<ThemeModelProvider>(context)
                                  .gradientCurrent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Searchtextfield(
                              hinttext: 'Search',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: UserList(),
                      )
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SpecialButton(
                  isRight: true,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<QueryDocumentSnapshot> searchUserList = snapshot.data.docs;

              return ListView.builder(
                itemCount: searchUserList.length,
                itemBuilder: (context, index) {
                  UseR currentUser =
                      UseR.fromJson(searchUserList[index].data());
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProfileView.routeName);
                      },
                      child: CustomCardUserList(
                        userList: currentUser,
                      ),
                    ),
                  );
                },
              );
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
  final UseR userList;

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
                  child: CachedNetworkImage(
                    imageUrl: userList?.profilePic,
                    errorWidget: (context, url, error) {
                      return FittedBox(
                          child: Icon(
                        FontAwesomeIcons.questionCircle,
                      ));
                    },
                  ),
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
class Searchtextfield extends StatefulWidget {
  final hinttext;
  Searchtextfield({@required this.hinttext});

  @override
  _SearchtextfieldState createState() => _SearchtextfieldState();
}

class _SearchtextfieldState extends State<Searchtextfield> {
  TextEditingController _searchInputText;
  @override
  void initState() {
    _searchInputText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchInputText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          borderRadius: Properties().borderRadius,
          elevation: 0,
          child: ClipRRect(
            borderRadius: Properties().borderRadius,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: TextField(
                autofocus: false,
                style: TextStyle(fontSize: 20),
                controller: _searchInputText,
                onSubmitted: (value) {
                  context.read<SearchViewModel>().searchedName =
                      _searchInputText.text;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: _searchInputText.text.isEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchInputText.clear();
                          })
                      : Container(
                          width: 1,
                        ),
                  hintText: widget.hinttext,
                  alignLabelWithHint: true,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ));
  }
}
