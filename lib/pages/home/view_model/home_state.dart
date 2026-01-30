import '../../../../services/todo/models/todo.dart';

class HomeState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const HomeState({required this.todos, required this.isLoading, this.error});

  factory HomeState.initial() =>
      const HomeState(todos: [], isLoading: true, error: null);

  HomeState copyWith({List<Todo>? todos, bool? isLoading, String? error}) {
    return HomeState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
