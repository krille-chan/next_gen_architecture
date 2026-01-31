import 'package:next_gen_architecture/services/user_management/models/user.dart';

class HomeState {
  final List<User>? users;
  final bool isLoading;
  final String? error;

  static const _unset = Object();

  const HomeState({required this.users, required this.isLoading, this.error});

  HomeState copyWith({
    List<User>? users,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return HomeState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}
