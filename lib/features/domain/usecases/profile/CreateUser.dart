import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';

import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

class CreateUser {
  final ProfileRepo profileRepo;

  CreateUser(this.profileRepo);

  Future<ErrorHandle<UseR>> call(String bio, String userName) async {
    return profileRepo.creatNewUser(bio: bio, userName: userName);
  }
}
