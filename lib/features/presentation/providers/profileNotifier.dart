import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/data/models/postModel.dart';
import 'package:projectnew/features/data/models/userProfile.dart';
import 'package:projectnew/features/data/repositories/post/postDataImpl.dart';
import 'package:projectnew/features/domain/entities/user.dart';
import 'package:projectnew/features/domain/repositories/Post/PostData.dart';
import 'package:projectnew/features/domain/usecases/profile/CreateUser.dart';
import 'package:projectnew/features/domain/usecases/profile/GetFollowers.dart';
import 'package:projectnew/features/domain/usecases/profile/GetPosts.dart';
import 'package:projectnew/features/domain/usecases/profile/GetUserData.dart';
import 'package:projectnew/features/presentation/providers/appstate.dart';
import 'package:projectnew/utils/State_management/state_manage.dart';

PostData postData = PostDataImpl();

class ProfileNotifier extends AppState {
  final CreateUser _createUser;
  final GetUserData _getUserData;
  final GetUserPosts _getUserPosts;
  final GetFollowers _getFollowers;

  UserData _userData;

  ProfileNotifier({
    @required CreateUser createUser,
    @required GetUserData getUserData,
    @required GetUserPosts getUserPosts,
    @required GetFollowers getFollowers,
  })  : assert(createUser != null),
        assert(getUserData != null),
        assert(getUserPosts != null),
        _createUser = createUser,
        _getUserData = getUserData,
        _getUserPosts = getUserPosts,
        _getFollowers = getFollowers;

  get userName => _userData.userName;
  get userBio => _userData.userBio;
  get followerCount => _userData.followerCount;
  get followingCount => _userData.followingCount;
  get postCount => _userData.postCount;
  get picUrl => _userData.picUrl;

  Response<UserData> userDataCase = Response<UserData>();

  _setUser(Response response) {
    userDataCase = response;
    notifyListeners();
  }

  Future getUserData() async {
    _setUser(Response.loading<UserData>());
    String uid = FirebaseAuth.instance.currentUser.uid;
    _getUserData.getUserData(uid).then((value) {
      if (value.errorState == ErrorState.NoError) {
        _userData = UserData(user: value.data);
        _setUser(Response.complete<UserData>(UserData(user: value.data)));
      } else {
        _setUser(Response.error(value.error));
      }
    });
  }

  setUserName(String name) async {
    _userData.user.displayName = name;
    notifyListeners();
  }

  Response<UseR> newUserCase = Response<UseR>();

  _setUpNewUser(Response response) {
    newUserCase = response;
    notifyListeners();
  }

  resetState() {
    _setUpNewUser(Response<UseR>());
  }

  Future createUser(String userName, String bio) async {
    _setUpNewUser(Response.loading<UseR>());

    Future.delayed(Duration(seconds: 2)).then((value) {
      switch (value.errorState) {
        case ErrorState.OnError:
          _setUpNewUser(Response.error(value.error));
          break;
        case ErrorState.NoError:
          _setUpNewUser(Response.complete<UseR>(value));
          break;
      }
    });
  }

/* ---------------------------- UserProfileSetup ---------------------------- */

  Response<ProfileUser> profileUserCase = Response<ProfileUser>();
  void _setProfileUser(Response<ProfileUser> _response) {
    profileUserCase = _response;
    notifyListeners();
  }

  setUpUserProfile(UseR _newUserData) async {
    _setProfileUser(Response.loading<ProfileUser>());
    try {
      List<PosT> _newPostList = [];

      if (_newUserData != null) {
        ProfileUser _newProfile =
            ProfileUser(postList: _newPostList, userData: _newUserData);
        _setProfileUser(Response.complete<ProfileUser>(_newProfile));
      } else {
        throw new Exception(['User Data is null']);
      }
    } on Exception catch (e) {
      _setProfileUser(Response.error<ProfileUser>(e.toString()));
    }
  }

  Future<ProfileUser> getUserDataFromLocal(UseR _user) async {
    _setProfileUser(Response.loading<ProfileUser>());
    try {
      ProfileUser _userData = await handleUserData(_user).then((value) {
        _setProfileUser(Response.complete<ProfileUser>(value));
        return value;
      });
      return _userData;
    } catch (e) {
      _setProfileUser(Response.error<ProfileUser>(e.toString()));
      return e;
    }
  }

  Future getUserProfileData(String _userId) async {
    print("lloading");
    _setProfileUser(Response.loading<ProfileUser>());
  }

  Future<ProfileUser> handleUserData(UseR _userData) async {
    print('getting');
    ProfileUser _profileUser;
    UseR _tempUserData;
    List<PosT> _postList = await postData.getPosts(_userData.userId);
    List<String> _followersList;
    //  =
    //     await profileData.getFollowers(_userData.userId);
    List<String> _followingList;
    // =
    //     await profileData.getFollowing(_userData.userId);
    int _postCount = _postList.length;
    int _followersCount = _followersList.length;
    int _followingCount = _followingList.length;
    _tempUserData = _userData.copyWith(
        followers: _followersCount,
        following: _followingCount,
        followersList: _followersList,
        followingList: _followingList,
        postcount: _postCount);
    _profileUser = ProfileUser(postList: _postList, userData: _tempUserData);
    print(_tempUserData.followersList.length.toString());
    // _profileUserList = [];
    // _profileUserList.add(_profileUser);
    return _profileUser;
  }
}

class UName {
  setUserName(String name) {
    return name;
  }
}
