import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/domain/entities/user.dart';

class UpdateUserData {
  String userName;
  String userPic;
  String userBio;
  UpdateUserData({this.userBio, this.userName, this.userPic});

  Future<UserData> update() async {
    UseR _user = UseR(bio: userBio, displayName: 'sfrsd', profilePic: userPic);
    UserData _newData = UserData(user: _user);

    return Future.delayed(Duration(seconds: 5)).then((value) {
      return _newData;
    });
  }
}
