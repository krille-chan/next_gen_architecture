import 'package:flutter/widgets.dart';

class CreateUserViewModel extends ValueNotifier<AsyncSnapshot> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final Future<void> Function(String, String, String) onCreateUser;

  CreateUserViewModel(this.onCreateUser) : super(AsyncSnapshot.nothing());

  Future<void> createUser({required VoidCallback onClose}) async {
    value = AsyncSnapshot.waiting();

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty) {
      value = AsyncSnapshot.withError(
        ConnectionState.none,
        'Please fill out all fields',
      );
      return;
    }

    if (!emailController.text.contains('@')) {
      value = AsyncSnapshot.withError(
        ConnectionState.none,
        'Please enter a valid email address',
      );
      return;
    }

    await onCreateUser(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
    );

    value = AsyncSnapshot.withData(ConnectionState.done, null);
    onClose();
  }
}
