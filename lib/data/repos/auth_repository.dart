import '../datasources/remote_datasource.dart';

abstract class AuthRepository {
  static final AuthRepository _singleton = _AuthRepositoryImpl(RemoteDataSource());

  factory AuthRepository() => _singleton;

  Future<RegisterResponse> register({required String username, required String password});

  Future<LoginResponse> login({required String username, required String password});

  void logout();
}

class _AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource _dataSource;

  _AuthRepositoryImpl(this._dataSource);

  @override
  Future<RegisterResponse> register({required String username, required String password}) =>
      _dataSource.register(username: username, password: password);

  @override
  Future<LoginResponse> login({required String username, required String password}) =>
      _dataSource.login(username: username, password: password);

  @override
  void logout() => _dataSource.logout();
}