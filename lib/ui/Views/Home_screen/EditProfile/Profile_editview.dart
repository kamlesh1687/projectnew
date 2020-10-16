import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_view.dart';

import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_viewmodel.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/models/userModel.dart';

import 'package:provider/provider.dart';

class ProfileEditView extends StatefulWidget {
  final String userId;
  final UseR currentUser;
  ProfileEditView(this.currentUser, this.userId);
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState(currentUser);
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final UseR currentUser;
  _ProfileEditViewState(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Consumer<ProfileViewModel>(
                          builder: (context, _fourthprovider, __) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            child: Stack(
                              children: [
                                _fourthprovider.fileImage != null
                                    ? ProfileImage(
                                        isCurrentUser: false,
                                        imageWidget: Image.file(
                                          _fourthprovider.fileImage,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ProfileImage(
                                        isCurrentUser: false,
                                        imageWidget: CachedNetworkImage(
                                          imageUrl: currentUser.photoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                InkWell(
                                  onTap: () {
                                    _fourthprovider.pickImageFromGallery();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Center(
                                      child: Icon(Icons.camera_alt,
                                          size: 100, color: Colors.black45),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: CardContainer(
                  color: Theme.of(context).cardColor,
                  color2: Theme.of(context).cardColor,
                  widget: Column(
                    children: [
                      Consumer<ProfileViewModel>(
                          builder: (context, _fourthprovider, __) {
                        return EditingTextField(
                            keyboardtype: TextInputType.name,
                            icon: Icon(Icons.account_circle_sharp),
                            hinttext: currentUser.displayName,
                            controllerText:
                                _fourthprovider.userNameEditCotroller);
                      }),
                      Consumer<ProfileViewModel>(
                          builder: (context, _fourthprovider, __) {
                        return EditingTextField(
                            keyboardtype: TextInputType.multiline,
                            icon: Icon(Icons.description),
                            hinttext: currentUser.userDescription,
                            controllerText:
                                _fourthprovider.userDescriptionEditCotroller);
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<ProfileViewModel>(
                          builder: (context, _fourthprovider, __) {
                        return InkWell(
                          onTap: () async {
                            if (_fourthprovider.fileImage == null) {
                              _fourthprovider.isUpdating = true;
                              _fourthprovider
                                  .updateDataTofirebase(
                                      widget.userId, widget.currentUser)
                                  .then((value) {
                                _fourthprovider.eventLoadingStatus =
                                    EventLoadingStatus.Loading;
                                _fourthprovider
                                    .getdatafromfirebase(
                                        _fourthprovider.firebaseUser.uid, true)
                                    .then((value) {});
                              });
                              _fourthprovider.isUpdating = false;
                              Navigator.pop(context);
                            } else {
                              _fourthprovider.isUpdating = true;
                              _fourthprovider
                                  .updateImageToStorage(currentUser.userId)
                                  .then((value) => null)
                                  .then((value) {
                                print('All passed');
                                _fourthprovider
                                    .updateDataTofirebase(
                                        widget.userId, widget.currentUser)
                                    .then((value) {
                                  _fourthprovider.eventLoadingStatus =
                                      EventLoadingStatus.Loading;
                                  _fourthprovider.getdatafromfirebase(
                                      _fourthprovider.firebaseUser.uid, true);
                                  _fourthprovider.isUpdating = false;
                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: CardContainer(
                              color: Colors.red.shade500,
                              color2: Colors.purple.shade500,
                              widget: Center(
                                child: _fourthprovider.isUpdatingData
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ],
          ),
        ],
      ),
    ));
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
    return Padding(
        padding: EdgeInsets.all(10),
        child: Material(
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
        ));
  }
}
