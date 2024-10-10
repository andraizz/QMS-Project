import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qms_application/data/models/models.dart';
import 'package:qms_application/data/source/sources.dart';


class UserDataCubit extends Cubit<UserData?> {
  final UserSource _userSource;

  UserDataCubit(this._userSource) : super(null);

  Future<void> fetchUserData(int userId) async {
    final userData = await _userSource.getUsers(userId);
    emit(userData);
  }

  void clearUserData() {
    emit(null); // Menghapus data user jika diperlukan
  }
}
