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
import 'package:projectnew/features/domain/usecases/profile/updateUserData.dart';
import 'package:projectnew/features/presentation/providers/appstate.dart';
import 'package:projectnew/utils/State_management/state_manage.dart';

PostData postData = PostDataImpl();

class ProfileNotifier extends AppState {
  final CreateUser _createUser;
  final GetUserData _getUserData;
  final UpdateUserData _updateUserData;
  final GetUserPosts _getUserPosts;
  final GetFollowers _getFollowers;

  ProfileNotifier({
    @required CreateUser createUser,
    @required GetUserData getUserData,
    @required GetUserPosts getUserPosts,
    @required UpdateUserData updateUserData,
    @required GetFollowers getFollowers,
  })  : assert(createUser != null),
        assert(getUserData != null),
        assert(getUserPosts != null),
        _createUser = createUser,
        _getUserData = getUserData,
        _getUserPosts = getUserPosts,
        _updateUserData = updateUserData,
        _getFollowers = getFollowers;
  List<UseR> _userDataList;

  UseR get _userData {
    if (_userDataList != null && _userDataList.length > 0) {
      return _userDataList.last;
    } else {
      return null;
    }
  }

  Response<UseR> userDataCase = Response<UseR>();
  get userName => userDataCase.data.displayName;
  get userBio => userDataCase.data.bio;
  get followerCount => userDataCase.data.followers;
  get followingCount => userDataCase.data.following;
  get postCount => userDataCase.data.postcount;
  get picUrl => userDataCase.data.profilePic;

  _setUser(Response response) {
    userDataCase = response;
    notifyListeners();
  }

  Future<bool> getUserData() async {
    _setUser(Response.loading<UseR>());
    //String uid = FirebaseAuth.instance.currentUser.uid;
    return _getUserData.call('ff').then((value) {
      if (value.errorState == ErrorState.NoError) {
        _userDataList = _userDataList == null ? [] : _userDataList;
        _userDataList.add(value.data);
        _setUser(Response.complete<UseR>(_userData));
        return true;
      } else {
        _setUser(Response.error(value.error));
        return false;
      }
    });
  }

  updateUserData(UseR useR) {
    _setUser(Response.loading<UserData>());
    _updateUserData.call(useR).then((value) {
      if (value.errorState == ErrorState.NoError) {
        UserData userData = UserData(user: value.data);
        _setUser(Response.complete<UserData>(userData));
      } else {
        _setUser(Response.error<UserData>('Oops,Something went wrong'));
      }
    });
  }

  Response<UseR> newUserCase = Response<UseR>();

  _setUpNewUser(Response response) {
    newUserCase = response;
    notifyListeners();
  }

  resetState() {
    _setUpNewUser(Response<UseR>());
  }

  Future<bool> createUser(String userName, String bio) async {
    _setUpNewUser(Response.loading<UseR>());

    return _createUser.call(bio, userName).then((value) {
      switch (value.errorState) {
        case ErrorState.OnError:
          _setUpNewUser(Response.error<UseR>(value.error));
          return false;
          break;
        case ErrorState.NoError:
          _setUpNewUser(Response.complete<UseR>(value.data));
          return true;
          break;

        default:
          return false;
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

    return _profileUser;
  }
}
