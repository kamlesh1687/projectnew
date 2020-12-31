import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:projectnew/business_logics/models/postModel.dart';

import 'package:projectnew/utils/Widgets.dart';

import 'package:timer_builder/timer_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostView extends StatelessWidget {
  final PosT postData;
  final profileTapFunc;

  const PostView({Key key, this.postData, this.profileTapFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      values: CrdConValue(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: profileTapFunc,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              CachedNetworkImageProvider(postData.ownerPic)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'name',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(postData.postlocation,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(FontAwesomeIcons.gripVertical),
                    onPressed: () {
                      print('More');
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: CachedNetworkImage(
                      imageUrl: postData.postimageurl,
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(FontAwesomeIcons.thumbsUp),
                            onPressed: () {}),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            icon: Icon(FontAwesomeIcons.comment),
                            onPressed: () {}),
                      ],
                    ),
                    Text("15 Likes"),
                    Expanded(
                      child: Container(),
                    ),
                    TimerBuilder.periodic(
                      Duration(seconds: 1),
                      builder: (context) {
                        return Text(timeago.format(postData.posttime.toDate()));
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(postData.postdescription),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
