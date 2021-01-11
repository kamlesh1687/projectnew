import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:projectnew/features/presentation/providers/Profile_viewmodel.dart';
import 'package:projectnew/features/presentation/providers/profileNotifier.dart';
import 'package:projectnew/ui/screens/home_views/home_view.dart';
import 'package:projectnew/utils/State_management/state.dart';

import 'package:projectnew/utils/reusableWidgets/CustomTextField.dart';

import 'package:provider/provider.dart';

import 'GetStartedScreen.dart';

ProfileViewModel profileViewModel = ProfileViewModel();

class CreateNewUser extends StatefulWidget {
  static const routeName = '/CreateNewUser';

  @override
  _CreateNewUserState createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  TextEditingController userNameController;
  TextEditingController bioController;
  TextEditingController phoneController;
  var _newUserFormkey = GlobalKey<FormState>();
  @override
  void initState() {
    userNameController = TextEditingController();
    bioController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building newuseer');
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _newUserFormkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  _title(),
                  SizedBox(
                    height: 50,
                  ),
                  _emailPasswordWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<ProfileNotifier>(
                    builder: (_, state, __) {
                      switch (state.newUserCase.state) {
                        case ResponseState.LOADING:
                          return Center(
                            child: SpinKitThreeBounce(
                              color: Colors.deepOrange,
                            ),
                          );
                          break;
                        case ResponseState.ERROR:
                          return Center(
                            child: Column(
                              children: [
                                Text(state.newUserCase.exception),
                                TextButton(
                                  child: Text('try again'),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          );
                          break;
                        case ResponseState.COMPLETE:
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            state.resetState();
                            Navigator.pushNamed(context, HomeView.routeName);
                          });
                          break;
                      }
                      return Container();
                    },
                  ),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
          // Positioned(
          //     top: -MediaQuery.of(context).size.height * .15,
          //     right: -MediaQuery.of(context).size.width * .4,
          //     child: BezierContainer())
        ],
      ),
    )));
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return RoundedFlatBtn(
      color: Colors.deepOrange,
      onPressed: () {
        if (_newUserFormkey.currentState.validate()) {
          print('tapped');
          print(bioController.text);
          print(userNameController.text);
          {
            context
                .read<ProfileNotifier>()
                .createUser(userNameController.text, bioController.text)
                .then((value) {
              print(value.toString());
              // if (value != null) {
              //   context.read<ProfileViewModel>().setUpUserProfile(value);
              // }
            });
          }
        }
      },
      text: "Submit",
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Let',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          children: [
            TextSpan(
              text: 'talk',
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        TextFormFieldOther(
            controller: userNameController, hinttext: "Username"),
        TextFormFieldOther(
          controller: bioController,
          hinttext: 'Bio',
        ),
      ],
    );
  }
}
