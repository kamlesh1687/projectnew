import 'package:get_it/get_it.dart';
import 'package:projectnew/features/data/datasources/remote/authService.dart';
import 'package:projectnew/features/data/datasources/remote/userServices.dart';
import 'package:projectnew/features/data/repositories/auth/authRepoImpl.dart';
import 'package:projectnew/features/data/repositories/auth/dummyAuth.dart';
import 'package:projectnew/features/data/repositories/profile/dummyProfile.dart';
import 'package:projectnew/features/data/repositories/profile/profileRepoImpl.dart';

import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';
import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

import 'package:projectnew/features/domain/usecases/auth/LoginCase.dart';
import 'package:projectnew/features/domain/usecases/auth/LogoutCase.dart';
import 'package:projectnew/features/domain/usecases/auth/SignupCase.dart';
import 'package:projectnew/features/domain/usecases/profile/CreateUser.dart';
import 'package:projectnew/features/domain/usecases/profile/GetFollowers.dart';
import 'package:projectnew/features/domain/usecases/profile/GetPosts.dart';
import 'package:projectnew/features/domain/usecases/profile/GetUserData.dart';

import 'package:projectnew/features/domain/usecases/profile/updateUserData.dart';
import 'package:projectnew/features/presentation/providers/authNotifier.dart';
import 'package:projectnew/features/presentation/providers/profileNotifier.dart';

GetIt sl = GetIt.instance;

bool isTesting = true;

Future<void> setUpLocator() async {
  //DataSource
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => UserService());

  //AuthRepo
  sl.registerLazySingleton<AuthRepo>(
      () => isTesting ? DummyAuth() : AuthRepoImpl(authService: sl()));
  sl.registerLazySingleton<ProfileRepo>(
      () => isTesting ? DummyProfile() : ProfileRepoImpl(userService: sl()));

  //UseCases
  sl.registerLazySingleton(() => LoginMethod(sl()));
  sl.registerLazySingleton(() => LogoutMethod(sl()));
  sl.registerLazySingleton(() => SignupMethod(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetFollowers(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));
  sl.registerLazySingleton(() => GetUserData(sl()));
  sl.registerLazySingleton(() => UpdateUserData(sl()));

  //Provider
  sl.registerFactory(
      () => AuthNotifier(login: sl(), logout: sl(), signup: sl()));
  sl.registerFactory(() => ProfileNotifier(
        updateUserData: sl(),
        createUser: sl(),
        getFollowers: sl(),
        getUserData: sl(),
        getUserPosts: sl(),
      )..getUserData());
}
