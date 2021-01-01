import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/utils/Theming/Gradient.dart';

import 'package:projectnew/utils/Theming/variableproperties.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/utils/properties.dart';
import 'package:projectnew/utils/reusableWidgets/SelectableList.dart';
import 'package:provider/provider.dart';

class ProfileEditView extends StatefulWidget {
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  @override
  Widget build(BuildContext context) {
    print("building profileeditview");
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
                body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    HeaderSectionProfileEdit(),
                    SizedBox(
                      height: 20,
                    ),
                    CardContainer(
                        values: CrdConValue(
                            color: Colors.black12,
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: EditingField()))),
                    SizedBox(
                      height: 10,
                    ),
                    themeSection(),
                    SizedBox(
                      height: 10,
                    ),
                    CircularBtn(
                      onPressed: () {
                        firebaseServices.signOut();
                        context.read<ProfileViewModel>().logoutCallBack();
                        context.read<FeedViewModel>().resetData();
                        Navigator.pop(context);
                      },
                      txt: 'Logout',
                    )
                  ],
                ),
              ),
            ])),
            SpecialButton(
              isRight: false,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget themeSection() {
    return Consumer<ThemeModelProvider>(builder: (context, gradient, __) {
      return CardContainer(
          values: CrdConValue(
              color: Theme.of(context).cardColor,
              linearGradient: gradient.gradientCurrent,
              child: themeBody(gradient, context)));
    });
  }

  Widget themeBody(gradient, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          "Theme",
          style: Theme.of(context).textTheme.headline5,
        ),
        subtitle: Column(
          children: [
            Consumer<ThemeModelProvider>(
              builder: (context, notifier, child) => SwitchListTile(
                title: Text("Dark Mode"),
                onChanged: (value) {
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme,
              ),
            ),
            Container(
                height: 100,
                child: SelectableList(
                  preselected: listColors.indexOf(gradient.gradientCurrent),
                  getSelectedItem: (index) {
                    gradient.gradientSelection(index);
                  },
                  list: listColors,
                  scrollDirection: Axis.horizontal,
                  color: Colors.transparent,
                  builder: (index) {
                    return Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: Properties().borderRadius,
                          boxShadow: [
                            cardShadowpositive,
                          ],
                          gradient: listColors[index]),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EditingField extends StatefulWidget {
  @override
  _EditingFieldState createState() => _EditingFieldState();
}

class _EditingFieldState extends State<EditingField> {
  TextEditingController userNameEditCotroller;

  TextEditingController userDescriptionEditCotroller;
  @override
  void initState() {
    userNameEditCotroller = TextEditingController();

    userDescriptionEditCotroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userNameEditCotroller.dispose();
    userDescriptionEditCotroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('text input field building');
    return Column(
      children: [
        Consumer<ProfileViewModel>(builder: (context, _value, __) {
          UseR _userData = _value.profileUser.userData;

          if (_userData == null) {
            return Center(
              child: LinearProgressIndicator(),
            );
          } else
            return EditingTextField(
                keyboardtype: TextInputType.name,
                icon: Icon(Icons.account_circle_sharp),
                hinttext: _userData.displayName,
                controllerText: userNameEditCotroller);
        }),
        SizedBox(
          height: 10,
        ),
        Consumer<ProfileViewModel>(builder: (context, _value, __) {
          UseR _userData = _value.profileUser.userData;

          if (_userData == null) {
            return Center(
              child: LinearProgressIndicator(),
            );
          } else
            return EditingTextField(
                keyboardtype: TextInputType.multiline,
                icon: Icon(Icons.description),
                hinttext: _userData.bio,
                controllerText: userDescriptionEditCotroller);
        }),
        SizedBox(
          height: 10,
        ),
        Builder(
          builder: (context) {
            var _func = Provider.of<ProfileViewModel>(context, listen: false);
            return InkWell(
              onTap: () async {
                UseR _userData =
                    context.read<ProfileViewModel>().myProfileData.userData;
                Navigator.pop(context);
                _func
                    .updateProfile(_userData, userDescriptionEditCotroller.text,
                        userNameEditCotroller.text)
                    .then((value) {
                  //upate user data
                });
              },
              child: CardContainer(
                  values: CrdConValue(
                linearGradient: Provider.of<ThemeModelProvider>(
                  context,
                ).gradientCurrent,
                color: Colors.red.shade500,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ProfileViewModel>(builder: (_, _status, __) {
                    return Center(
                        child: Text(
                      "Save",
                      style: Theme.of(context).textTheme.headline5,
                    ));
                  }),
                ),
              )),
            );
          },
        )
      ],
    );
  }
}

class EditingTextField extends StatelessWidget {
  final controllerText;
  final hinttext;
  final icon;
  final keyboardtype;
  EditingTextField(
      {@required this.hinttext,
      @required this.controllerText,
      @required this.icon,
      @required this.keyboardtype});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: TextField(
            autofocus: false,
            style: TextStyle(fontSize: 22),
            keyboardType: keyboardtype,
            maxLines: keyboardtype == TextInputType.multiline ? null : 1,
            controller: controllerText,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabled: true,
              enabledBorder: InputBorder.none,
              hintText: hinttext,
              alignLabelWithHint: true,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSectionProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('builfing');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              blurRadius: 15,
                              spreadRadius: 2)
                        ], borderRadius: BorderRadius.circular(15)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Consumer<ProfileViewModel>(
                              builder: (_, value, __) {
                                if (value.myProfileData?.userData == null) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (value.fileImage == null) {
                                  return CachedNetworkImage(
                                      imageUrl:
                                          value.profileUser.userData.profilePic,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      fit: BoxFit.cover);
                                } else
                                  return Image.file(
                                    value.fileImage,
                                    fit: BoxFit.cover,
                                  );
                              },
                            ))),
                    InkWell(
                      onTap: () {
                        context.read<ProfileViewModel>().pickImageFromGallery();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        child: Center(
                          child: Icon(Icons.camera_alt,
                              size: 100, color: Colors.black45),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
