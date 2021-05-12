import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';

import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

class UpdateUserData {
  final ProfileRepo profileRepo;

  UpdateUserData(this.profileRepo);
  Future<ErrorHandle<UseR>> call(UseR userData) async {
    return profileRepo.updateUserData(userData);
  }

  //Future<UserData> call(String userName, String userPic, String userBio) async {
  //  UseR _user = UseR(bio: userBio, displayName: 'sfrsd', profilePic: userPic);
  //  UserData _newData = UserData(user: _user);

  //  return Future.delayed(Duration(seconds: 5)).then((value) {
  //    return _newData;
  //  });
  //}
}
