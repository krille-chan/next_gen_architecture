import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_gen_architecture/services/user_management/models/user.dart';
import 'package:sqflite/sqflite.dart';

final userDatabaseServiceProvider = FutureProvider(
  (ref) => UserDatabaseService.init(),
);

class UserDatabaseService {
  final Database _database;

  const UserDatabaseService(this._database);

  static Future<UserDatabaseService> init() async {
    final directory = await getDatabasesPath();
    final path = '$directory/db.sqlite';
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, _) async {
        database.execute(
          'CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, email TEXT, avatar TEXT)',
        );
      },
    );
    return UserDatabaseService(database);
  }

  Future<void> createLocalUser(User user) async {
    await _database.insert('Users', user.toJson());
  }

  Future<List<User>> getLocalUsers() async {
    final result = await _database.query('Users');
    return result.map(User.fromJson).toList();
  }
}
