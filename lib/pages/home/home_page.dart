import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/pages/home/widgets/center_info.dart';
import 'package:next_gen_architecture/pages/home/widgets/create_user_bottom_sheet.dart';
import 'package:next_gen_architecture/pages/home/widgets/user_list_tile.dart';
import 'view_model/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final error = state.error;
    final users = state.users;

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            onPressed: state.isLoading ? null : viewModel.refresh,
            icon: state.isLoading
                ? CircularProgressIndicator()
                : Icon(Icons.refresh),
          ),
        ],
      ),
      body: error != null
          ? CenterInfo(label: 'Error: $error', icon: Icons.error)
          : users == null
          ? CenterInfo(label: 'Loading...', icon: Icons.connected_tv)
          : users.isEmpty
          ? CenterInfo(label: 'No users found', icon: Icons.search)
          : RefreshIndicator.adaptive(
              onRefresh: viewModel.refresh,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) => UserListTile(user: users[i]),
              ),
            ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => showBottomSheet(
            context: context,
            builder: (context) => CreateUserBottomSheet(),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
