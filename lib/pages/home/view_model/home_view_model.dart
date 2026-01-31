import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_gen_architecture/services/user_management/models/user.dart';
import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';

import 'home_state.dart';

final homeViewModelProvider = StateNotifierProvider.autoDispose(
  (ref) => HomeViewModel(
    ref.read(usersApiServiceProvider),
    ref.read(userDatabaseServiceProvider.future),
    HomeState.initial(),
  ),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final UsersApiService _usersApiService;
  final Future<UserDatabaseService> _userDatabaseService;

  HomeViewModel(this._usersApiService, this._userDatabaseService, super.state) {
    _loadUsers();
  }

  void _loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    final userDatabaseService = await _userDatabaseService;

    try {
      final users = await _usersApiService.getUsers();
      final localUsers = await userDatabaseService.getLocalUsers();
      users.insertAll(0, localUsers);
      state = state.copyWith(isLoading: false, users: users);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    _usersApiService.clearCache();
    _loadUsers();
  }

  Future<void> createUser(
    String firstName,
    String lastName,
    String email,
  ) async {
    final userDatabaseService = await _userDatabaseService;
    final users = state.users;
    if (users == null) {
      throw 'Can not create a new user without having all remote users cached!';
    }
    final maxId = users.fold(0, (id, user) => max(id, user.id));
    await userDatabaseService.createLocalUser(
      User(
        id: maxId + 1,
        firstName: firstName,
        lastName: lastName,
        email: email,
        avatar: null,
      ),
    );
    refresh();
  }
}
