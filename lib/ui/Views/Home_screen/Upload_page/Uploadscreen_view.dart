import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:projectnew/ui/Views/Home_screen/Upload_page/UploadScreen_viewmodel.dart';
import 'package:projectnew/utils/Style.dart';
import 'package:projectnew/utils/Widgets.dart';

import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  final String userid;
  UploadScreen(this.userid);
  @override
  Widget build(BuildContext context) {
    print("building Upload page");
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Post"),
      ),
      body: Consumer<UploadScreenViewModel>(builder: (context, _values, __) {
        _values.userId = userid;
        return _values.isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SelectImageBox(
                      values: _values,
                    ),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        CardContainer(
                          color: Theme.of(context).cardColor,
                          color2: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: NextButton(),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class SelectImageBox extends StatelessWidget {
  final values;

  const SelectImageBox({Key key, this.values}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: CardContainer(
              color: Theme.of(context).cardColor,
              color2: Theme.of(context).cardColor,
              height: MediaQuery.of(context).size.width - 40,
              child: values.fileImage == null
                  ? Column(
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
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        values.fileImage,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width - 50,
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          values.fileImage == null
              ? Container()
              : Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 100,
                        child: CardContainer(
                          color: Colors.teal,
                          color2: Colors.blue,
                          height: 15,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          values.removeImage();
                          values.captionController.clear();
                          values.locationController.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Clear",
                            textAlign: TextAlign.center,
                            style: Style().buttonTxtSm,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
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
                style: Style().buttonTxtXl,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Uploadpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).cardColor),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NextButton(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NextButton extends StatefulWidget {
  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool isNext = false;
  @override
  Widget build(BuildContext context) {
    var _value = Provider.of<UploadScreenViewModel>(context);
    return Column(
      children: [
        isNext
            ? InputField(
                controller: _value.captionController,
                hinttext: 'Enter Your Location.....')
            : InputField(
                controller: _value.locationController,
                hinttext: 'Enter Your Caption.....'),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            isNext
                ? IconButton(
                    icon: Icon(Icons.navigate_before_outlined),
                    onPressed: () {
                      setState(() {
                        isNext = false;
                      });
                    })
                : Container(),
            Expanded(child: Container()),
            isNext
                ? _value.fileImage != null
                    ? RaisedButton(
                        onPressed: () {
                          _value.updateImageToStorage();
                        },
                        child: Text(
                          "Upload",
                        ))
                    : AnimatedContainer(
                        duration: Duration(seconds: 2),
                        child: Text(
                          'No Image Selected',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                : IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      setState(() {
                        isNext = true;
                      });
                    })
          ],
        )
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final hinttext;
  final controller;
  InputField({@required this.controller, @required this.hinttext});
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
            controller: controller,
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
