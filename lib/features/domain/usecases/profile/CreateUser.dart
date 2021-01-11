import 'package:projectnew/core/failures/errorHandling.dart';

import 'package:projectnew/features/domain/repositories/Profile/ProfileRepo.dart';

class CreateUser {
  final ProfileRepo profileRepo;

  CreateUser(this.profileRepo);

  Future<ErrorHandle> createUser(String bio, String userName) async {
    return profileRepo.creatNewUser(bio: bio, userName: userName);
  }
}
