import 'package:flutter/material.dart';

import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';
import '../pages/home/home_page.dart';

class AppWidget extends StatelessWidget {
  final UsersApiService usersApiService;
  final UserDatabaseService userDatabaseService;
  const AppWidget({
    required this.usersApiService,
    required this.userDatabaseService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Gen Architecture',
      home: HomePage(usersApiService, userDatabaseService),
    );
  }
}
