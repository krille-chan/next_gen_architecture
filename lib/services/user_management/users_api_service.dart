import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:next_gen_architecture/config/app_constants.dart';
import 'package:next_gen_architecture/services/user_management/models/user.dart';

final usersApiServiceProvider = Provider(
  (ref) => UsersApiService(baseUri: AppConstants.usersApiBase),
);

class UsersApiService {
  final Uri baseUri;
  UsersApiService({required this.baseUri});

  List<User>? _users;

  Future<List<User>> getUsers() async {
    return _users ??= await _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final result = await http.get(baseUri.resolveUri(Uri(path: '/api/users')));
    final json = List<Map<String, Object?>>.from(
      jsonDecode(result.body)['Users'],
    );
    return json.map(User.fromJson).toList();
  }

  void clearCache() {
    _users = null;
  }
}
