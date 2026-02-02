import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:next_gen_architecture/services/user_management/models/user.dart';
import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';
import 'home_state.dart';

class HomeViewModel extends ValueNotifier<HomeState> {
  final UsersApiService _usersApiService;
  final UserDatabaseService _userDatabaseService;
  HomeViewModel(this._usersApiService, this._userDatabaseService)
    : super(HomeState(users: null, isLoading: false)) {
    _loadUsers();
  }

  void _loadUsers() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final users = await _usersApiService.getUsers();
      final localUsers = await _userDatabaseService.getLocalUsers();
      users.insertAll(0, localUsers);
      value = value.copyWith(isLoading: false, users: users);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
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
    final users = value.users;
    if (users == null) {
      throw 'Can not create a new user without having all remote users cached!';
    }
    final maxId = users.fold(0, (id, user) => max(id, user.id));
    await _userDatabaseService.createLocalUser(
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
