import 'package:projectnew/core/failures/errorHandling.dart';

abstract class CommonRepo {
  Future<ErrorHandle> getData();
  Future updateData(ErrorHandle _data);
  Future deleteData(var _data);
}
