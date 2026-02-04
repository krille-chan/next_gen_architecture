import 'package:flutter/material.dart';

import 'package:next_gen_architecture/pages/home/widgets/center_info.dart';
import 'package:next_gen_architecture/pages/home/widgets/user_list_tile.dart';
import '../../../services/user_management/models/user.dart';

class HomePage extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() refresh;
  final void Function() onCreateUser;
  final String? error;
  final List<User>? users;

  const HomePage({
    super.key,
    required this.isLoading,
    required this.refresh,
    this.error,
    this.users,
    required this.onCreateUser,
  });

  @override
  Widget build(BuildContext context) {
    final users = this.users;
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            onPressed: isLoading ? null : refresh,
            icon: isLoading ? CircularProgressIndicator() : Icon(Icons.refresh),
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
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) => UserListTile(user: users[i]),
              ),
            ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: onCreateUser,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
