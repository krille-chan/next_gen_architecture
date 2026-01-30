import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/todo/todo_service.dart';
import 'home_state.dart';

final homeViewModelProvider = StateNotifierProvider.autoDispose(
  (ref) => HomeViewModel(ref.read(todoServiceProvider), HomeState.initial()),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final TodoService todoService;

  HomeViewModel(this.todoService, super.state) {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await todoService.load();
      state = state.copyWith(todos: todoService.todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await todoService.addTodo(title.trim());
      state = state.copyWith(todos: todoService.todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleTodo(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await todoService.toggleTodo(id);
      state = state.copyWith(todos: todoService.todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteTodo(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await todoService.deleteTodo(id);
      state = state.copyWith(todos: todoService.todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteCompletedTodos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      for (final todo in state.todos) {
        if (todo.isCompleted) await todoService.deleteTodo(todo.id);
      }
      state = state.copyWith(todos: todoService.todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
