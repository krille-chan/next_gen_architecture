import 'package:flutter/material.dart';

import 'package:next_gen_architecture/services/user_management/models/user.dart';

class UserListTile extends StatelessWidget {
  final User user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name = '${user.firstName} ${user.lastName}';
    final avatar = user.avatar;
    final email = user.email;
    return ListTile(
      leading: avatar == null
          ? null
          : CircleAvatar(
              radius: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                clipBehavior: Clip.hardEdge,
                child: Image.network(avatar.toString(), width: 40, height: 40),
              ),
            ),
      title: Text(name),
      subtitle: email == null ? null : Text(email),
    );
  }
}
