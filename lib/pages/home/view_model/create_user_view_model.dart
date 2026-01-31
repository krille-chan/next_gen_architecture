import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_gen_architecture/pages/home/view_model/home_view_model.dart';

final createUserViewModelProvider = StateNotifierProvider.autoDispose(
  (ref) => CreateUserViewModel(
    ref.read(homeViewModelProvider.notifier),
    AsyncSnapshot.nothing(),
  ),
);

class CreateUserViewModel extends StateNotifier<AsyncSnapshot> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final HomeViewModel _homeViewModel;

  CreateUserViewModel(this._homeViewModel, super.state);

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

    await _homeViewModel.createUser(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
    );

    state = AsyncSnapshot.withData(ConnectionState.done, null);
  }
}
