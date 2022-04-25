import '../datasources/remote_datasource.dart';

abstract class UserRepository {
  static final UserRepository _singleton = _UserRepositoryImpl(RemoteDataSource());

  factory UserRepository() => _singleton;

  Stream<String> get userImageStream;

  Stream<String> get usernameStream;

  Future<void> updateUserImage({required String userImage});

  Future<void> updateUsername({required String username});
}

class _UserRepositoryImpl implements UserRepository {
  final RemoteDataSource _dataSource;

  _UserRepositoryImpl(this._dataSource);

  @override
  Stream<String> get userImageStream => _dataSource.userImageStream;

  @override
  Stream<String> get usernameStream => _dataSource.usernameStream;

  @override
  Future<void> updateUserImage({required String userImage}) =>
      _dataSource.updateUserImage(userImage: userImage);

  @override
  Future<void> updateUsername({required String username}) =>
      _dataSource.updateUsername(username: username);
}
