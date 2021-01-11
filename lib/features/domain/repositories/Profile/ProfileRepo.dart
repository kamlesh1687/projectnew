import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';

abstract class ProfileRepo {
  Future<ErrorHandle> creatNewUser({String bio, String userName});
  Future<ErrorHandle<UseR>> getData({String uId});
  Future<void> updateUserData({UseR newData});
  Future<List<String>> getFollowers(String _userId);
  Future<List<String>> getFollowing(String _userId);
  Future<ErrorHandle> createProfileUser(UseR user);
  bool isFollowing();
}
