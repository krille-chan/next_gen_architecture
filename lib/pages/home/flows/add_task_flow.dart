import 'package:flutter/material.dart';
import 'package:next_gen_architecture/pages/home/widgets/add_todo_widget.dart';

void showAddTodoDialog(BuildContext context, void Function(String) onAddTodo) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) =>
        AddTodoWidget(onAddTodo: onAddTodo, textEditingController: controller),
  );
}
