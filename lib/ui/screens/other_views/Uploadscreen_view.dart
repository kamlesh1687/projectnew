import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/properties.dart';
import 'package:projectnew/utils/reusableWidgets/customAppBar.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  final String userid;
  UploadScreen(this.userid);
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
                body: UploadPageBody()),
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
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.width,
      child: Consumer<FeedViewModel>(builder: (_, value, __) {
        return value.fileImage == null
            ? SelectImageBox(
                values: value,
              )
            : PostDetailsInput();
      }),
    );
  }
}

class SelectImageBox extends StatelessWidget {
  final FeedViewModel values;

  const SelectImageBox({Key key, this.values}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      values: CrdConValue(
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ImageSelectBtn(
                      btnText: 'Gallery',
                      onTap: () {
                        values.pickImageFromGallery();
                      },
                    ),
                    ImageSelectBtn(
                      btnText: 'Camera',
                      onTap: () {
                        values.takeImageFromCamera();
                      },
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

  @override
  void initState() {
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<FeedViewModel>(context);
    return CardContainer(
      values: CrdConValue(
        height: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Image.file(
                    value.fileImage,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
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
      ),
    );
  }
}
