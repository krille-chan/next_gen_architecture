import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/pages/home/view_models/load_users.dart';
import 'package:next_gen_architecture/pages/home/widgets/home_page.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';

class HomePagePresenter extends ConsumerWidget {
  const HomePagePresenter({super.key});

  Future<void> refresh(WidgetRef ref) async {
    ref.read(usersApiServiceProvider).clearCache();
    ref.invalidate(loadUsersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(loadUsersProvider);

    return HomePage(
      isLoading: users.isLoading,
      refresh: () => refresh(ref),
      users: users.value,
      error: users.error?.toString(),
      onCreateUser: () {
        // TODO: Implement me
      },
    );
  }
}
