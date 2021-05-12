import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/presentation/providers/authNotifier.dart';
import 'package:projectnew/features/presentation/providers/profileNotifier.dart';
import 'package:projectnew/utils/State_management/state.dart';

import 'package:projectnew/utils/Theming/Gradient.dart';

import 'package:projectnew/utils/Theming/variableproperties.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';

import 'package:projectnew/utils/properties.dart';
import 'package:projectnew/utils/reusableWidgets/SelectableList.dart';
import 'package:provider/provider.dart';

class ProfileEditView extends StatelessWidget {
  static const routeName = '/profileEditView';

  @override
  Widget build(BuildContext context) {
    print('why');
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
                        context.read<AuthNotifier>().logout();
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
    var userdata = context.read<ProfileNotifier>().userDataCase.data;
    userNameEditCotroller = TextEditingController(text: userdata.displayName);

    userDescriptionEditCotroller = TextEditingController(text: userdata.bio);

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
        EditingTextField(
            keyboardtype: TextInputType.name,
            icon: Icon(Icons.account_circle_sharp),
            hinttext: "userData.displayName",
            controllerText: userNameEditCotroller),
        SizedBox(
          height: 10,
        ),
        EditingTextField(
            keyboardtype: TextInputType.multiline,
            icon: Icon(Icons.description),
            hinttext: "userData.bio",
            controllerText: userDescriptionEditCotroller),
        SizedBox(
          height: 10,
        ),
        Builder(
          builder: (context) {
            return InkWell(
              onTap: () async {
                var oldUserData =
                    context.read<ProfileNotifier>().userDataCase.data;
                UseR useR = new UseR();

                useR = oldUserData.copyWith(
                    displayName: userNameEditCotroller.text,
                    bio: userDescriptionEditCotroller.text);
                context.read<ProfileNotifier>().updateUserData(useR);

                //Navigator.pop(context);
              },
              child: CardContainer(
                  values: CrdConValue(
                height: 50,
                linearGradient: Provider.of<ThemeModelProvider>(
                  context,
                ).gradientCurrent,
                color: Colors.red.shade500,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ProfileNotifier>(builder: (_, state, __) {
                    switch (state.userDataCase.state) {
                      case ResponseState.ERROR:
                        return Center(
                            child: Text(
                          state.userDataCase.exception,
                          style: Theme.of(context).textTheme.bodyText2,
                        ));
                        break;
                      case ResponseState.LOADING:
                        return Center(
                            child: SpinKitThreeBounce(
                                size: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .color));

                        break;
                      case ResponseState.COMPLETE:
                        return Center(
                            child: Text(
                          "Save",
                          style: Theme.of(context).textTheme.headline5,
                        ));
                        break;
                      default:
                        return Text('Click');
                    }
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
    print('keyboard');
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: Properties().borderRadius),
      child: TextField(
        autofocus: false,
        style: TextStyle(fontSize: 22),
        keyboardType: keyboardtype,
        maxLines: keyboardtype == TextInputType.multiline ? null : 1,
        controller: controllerText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
          hintText: hinttext,
          alignLabelWithHint: true,
        ),
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
                            child: Container(
                              color: Colors.red,
                            ))),
                    InkWell(
                      onTap: () {},
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
