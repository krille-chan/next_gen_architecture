import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/pages/home/view_model/home_view_model.dart';

final createUserViewModelProvider = NotifierProvider.autoDispose(
  CreateUserViewModel.new,
);

class CreateUserViewModel extends Notifier<AsyncSnapshot> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  AsyncSnapshot<dynamic> build() {
    return AsyncSnapshot.nothing();
  }

  Future<void> createUser() async {
    state = AsyncSnapshot.waiting();

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty) {
      state = AsyncSnapshot.withError(
        ConnectionState.none,
        'Please fill out all fields',
      );
      return;
    }

    if (!emailController.text.contains('@')) {
      state = AsyncSnapshot.withError(
        ConnectionState.none,
        'Please enter a valid email address',
      );
      return;
    }

    await ref
        .read(homeViewModelProvider.notifier)
        .createUser(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
        );

    state = AsyncSnapshot.withData(ConnectionState.done, null);
  }
}
