import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/data/datasources/remote/userServices.dart';

import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final UserService userService;

  ProfileRepoImpl({this.userService});
  @override
  Future<ErrorHandle> creatNewUser({String bio, String userName}) {
    return userService.createUser(bio, userName);
  }

  @override
  Future<ErrorHandle<UseR>> getData({String uId}) async {
    return await userService.getUser(uId);
  }

  @override
  Future<void> updateUserData({UseR newData}) {
    return null;
  }

  @override
  Future<ErrorHandle> createProfileUser(UseR user) {
    return null;
  }

  @override
  Future<List<String>> getFollowers(String _userId) async {
    try {
      final _list = await userService.getFollowersList(_userId);
      return _list;
    } catch (e) {}
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getFollowing(String _userId) async {
    try {
      final _list = await userService.getFollowingList(_userId);
      return _list;
    } catch (e) {}
    throw UnimplementedError();
  }

  @override
  bool isFollowing() {
    throw UnimplementedError();
  }
}
