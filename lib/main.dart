import 'package:flutter/material.dart';

import 'package:next_gen_architecture/config/app_constants.dart';
import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';
import 'package:next_gen_architecture/widgets/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppWidget(
      usersApiService: UsersApiService(baseUri: AppConstants.usersApiBase),
      userDatabaseService: await UserDatabaseService.init(),
    ),
  );
}
