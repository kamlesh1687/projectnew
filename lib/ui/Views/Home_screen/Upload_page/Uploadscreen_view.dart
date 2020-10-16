import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:projectnew/ui/Views/Home_screen/Upload_page/UploadScreen_viewmodel.dart';

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
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.cyan, width: 2)),
                              height: MediaQuery.of(context).size.width - 50,
                              width: MediaQuery.of(context).size.width - 50,
                              child: _values.fileImage == null
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _values
                                                        .pickImageFromGallery();
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.image_outlined,
                                                          size: 60,
                                                        ),
                                                        Text(
                                                          'Gallery',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.cyan,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _values
                                                        .takeImageFromCamera();
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 60,
                                                        ),
                                                        Text('Camera',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.cyan,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.file(
                                        _values.fileImage,
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.width -
                                                50,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _values.fileImage == null
                            ? Container()
                            : RaisedButton(
                                onPressed: () {
                                  _values.removeImage();
                                  _values.captionController.clear();
                                  _values.locationController.clear();
                                },
                                child: Text("Clear")),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(width: 2, color: Colors.cyan)),
                          color: Theme.of(context).cardColor,
                          shadowColor: Colors.cyan,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                hintext: 'Enter Your Location.....')
            : InputField(
                controller: _value.locationController,
                hintext: 'Enter Your Caption.....'),
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
  final hintext;
  final controller;
  InputField({@required this.controller, @required this.hintext});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabled: true,
        enabledBorder: InputBorder.none,
        labelText: hintext,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        isDense: true,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
