import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';

final loadUsersProvider = FutureProvider((Ref ref) async {
  final userDatabaseService = ref
      .read(userDatabaseServiceProvider)
      .requireValue;

  final users = await ref.read(usersApiServiceProvider).getUsers();
  final localUsers = await userDatabaseService.getLocalUsers();
  users.insertAll(0, localUsers);
  return users;
});
