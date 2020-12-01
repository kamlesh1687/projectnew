import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';
import 'package:projectnew/utils/Theming/Gradient.dart';
import 'package:projectnew/utils/Theming/Style.dart';
import 'package:projectnew/utils/Theming/variableproperties.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:provider/provider.dart';

class ProfileEditView extends StatefulWidget {
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  @override
  Widget build(BuildContext context) {
    print("building profileeditview");
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          ListView(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  HeaderSectionProfileEdit(),
                  SizedBox(
                    height: 20,
                  ),
                  BodySectionProfileEdit(),
                  SizedBox(
                    height: 10,
                  ),
                  ThemeSection()
                ],
              ),
            ),
          ]),
          SpecialButton(
            isCurrentuser: false,
            left: 0,
            color: Colors.white,
            clickFunction: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    ));
  }
}

class ThemeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModelProvider>(builder: (context, gradient, __) {
      return CardContainer(
          values: CrdConValue(
              color: Theme.of(context).cardColor,
              linearGradient: gradient.curretGradient,
              child: themeBody(gradient, context)));
    });
  }

  themeBody(gradient, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          "Theme",
          style: Theme.of(context).textTheme.headline5,
        ),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DarkMode",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch(
                  onChanged: (value) {
                    gradient.themeSwitchFunction(value);
                  },
                  value: gradient.isDark ?? false,
                )
              ],
            ),
            Container(
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: listColors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              cardShadowpositive,
                            ],
                            gradient: listColors[index]),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(),
                          onPressed: () {
                            gradient.gradientSelection(index);
                          },
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class BodySectionProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      values:
          CrdConValue(color: Theme.of(context).cardColor, child: bodySection()),
    );
  }

  bodySection() {
    TextEditingController userNameEditCotroller = TextEditingController();
    TextEditingController userDescriptionEditCotroller =
        TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Consumer<ProfileViewModel>(builder: (context, _value, __) {
            UseR _userData = _value.profileUserModel;
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
            UseR _userData = _value.profileUserModel;

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
                      context.read<ProfileViewModel>().profileUserModel;
                  _func.updating(true);

                  _func
                      .updateProfile(
                          _userData,
                          userDescriptionEditCotroller.text,
                          userNameEditCotroller.text)
                      .then((value) {
                    //upate user data
                  }).then((value) {
                    _func.updating(false);
                    Navigator.pop(context);
                  });
                },
                child: CardContainer(
                    values: CrdConValue(
                  linearGradient: Provider.of<ThemeModelProvider>(
                    context,
                  ).curretGradient,
                  color: Colors.red.shade500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Consumer<ProfileViewModel>(builder: (_, _status, __) {
                      return Center(
                          child: _status.isUpdating
                              ? CircularProgressIndicator()
                              : Text(
                                  "Save",
                                  style: Style().buttonTxtXl,
                                ));
                    }),
                  ),
                )),
              );
            },
          )
        ],
      ),
    );
  }
}

class HeaderSectionProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    // _fourthprovider.fileImage != null
                    //     ? ProfileImage(
                    //         isCurrentUser: false,
                    //         imageWidget: Image.file(
                    //           _fourthprovider.fileImage,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       )
                    //     : ProfileImage(
                    //         isCurrentUser: false,
                    //         imageWidget: CachedNetworkImage(
                    //           imageUrl: _userData.photoUrl,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
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
      color: Colors.grey[50],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: TextField(
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
