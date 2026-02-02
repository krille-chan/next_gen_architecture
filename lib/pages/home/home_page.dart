import 'package:flutter/material.dart';

import 'package:next_gen_architecture/pages/home/widgets/center_info.dart';
import 'package:next_gen_architecture/pages/home/widgets/create_user_bottom_sheet.dart';
import 'package:next_gen_architecture/pages/home/widgets/user_list_tile.dart';
import 'package:next_gen_architecture/services/user_management/user_database_service.dart';
import 'package:next_gen_architecture/services/user_management/users_api_service.dart';
import 'package:next_gen_architecture/widgets/view_model_builder.dart';
import 'view_model/home_view_model.dart';

class HomePage extends StatelessWidget {
  final UsersApiService usersApiService;
  final UserDatabaseService userDatabaseService;
  const HomePage(this.usersApiService, this.userDatabaseService, {super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      create: () => HomeViewModel(usersApiService, userDatabaseService),
      builder: (context, viewModel, _) {
        final state = viewModel.value;
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
                builder: (context) =>
                    CreateUserBottomSheet(onCreateUser: viewModel.createUser),
              ),
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
