import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';

import 'package:projectnew/features/data/models/userProfile.dart';

import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

class GetUserData {
  final ProfileRepo profileRepo;

  GetUserData(this.profileRepo);
  Future<ErrorHandle<UseR>> call(String userId) {
    return profileRepo.getData(uId: userId);
  }
}
