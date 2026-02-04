import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/widgets/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Initialize database service at app start
  await container.read(userDatabaseServiceProvider.future);

  runApp(
    UncontrolledProviderScope(container: container, child: const AppWidget()),
  );
}
