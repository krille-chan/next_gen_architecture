import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todo.dart';

final todoServiceProvider = Provider((ref) => TodoService());

class TodoService {
  static const String _storageKey = 'todos';
  List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  Future<void> load() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString(_storageKey);

    if (todosJson != null) {
      final List<dynamic> decoded = jsonDecode(todosJson);
      _todos = decoded.map((json) => Todo.fromJson(json)).toList();
    } else {
      _todos = [];
    }
  }

  Future<void> _save() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final todosJson = jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_storageKey, todosJson);
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );
    _todos.add(newTodo);
    await _save();
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      await _save();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _save();
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: newTitle);
      await _save();
    }
  }
}
