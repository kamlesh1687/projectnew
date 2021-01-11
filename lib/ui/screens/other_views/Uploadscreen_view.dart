import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/features/presentation/providers/Feed_viewmodel.dart';
import 'package:projectnew/features/presentation/providers/Profile_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/properties.dart';
import 'package:projectnew/utils/reusableWidgets/customAppBar.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  static const routeName = '/uploadView';

  @override
  Widget build(BuildContext context) {
    print("building Upload page");
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
                appBar: customAppBar('Upload', context),
                body: ListView(
                  children: [
                    UploadPageBody(),
                  ],
                )),
            SpecialButton(
              isRight: false,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fileImage;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            child: fileImage == null ? SelectImageBox() : PostDetailsInput()),
      ],
    );
  }
}

class SelectImageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      values: CrdConValue(
          height: MediaQuery.of(context).size.width,
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ImageSelectBtn(
                      btnText: 'Gallery',
                      onTap: () {},
                    ),
                    ImageSelectBtn(
                      btnText: 'Camera',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class ImageSelectBtn extends StatelessWidget {
  final onTap;
  final btnText;

  const ImageSelectBtn({Key key, this.onTap, this.btnText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.width - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 60,
              ),
              Text(
                btnText,
                // style: Style().buttonTxtXl,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PostDetailsInput extends StatefulWidget {
  @override
  _PostDetailsInputState createState() => _PostDetailsInputState();
}

class _PostDetailsInputState extends State<PostDetailsInput> {
  TextEditingController captionController;
  TextEditingController locationController;

  @override
  void initState() {
    captionController = TextEditingController();
    locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    var value = Provider.of<FeedViewModel>(context);
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.file(
                    value.fileImage,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.mapMarked),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        value.removeImage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: Properties().borderRadius),
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: TextStyle(fontSize: 22),
                    controller: captionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      fillColor: Colors.green,
                      border: InputBorder.none,
                      hintText: "Whats in your mind?",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: Properties().borderRadius),
            child: TextField(
              style: TextStyle(fontSize: 22),
              controller: locationController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: "Location",
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text('Upload'),
          onPressed: () {
            context.read<FeedViewModel>().createPost(
                caption: captionController.text,
                location: locationController.text,
                userDta:
                    context.read<ProfileViewModel>().myProfileData.userData);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
