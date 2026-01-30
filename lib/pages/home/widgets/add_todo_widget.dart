import 'package:flutter/material.dart';

class AddTodoWidget extends StatelessWidget {
  final void Function(String) onAddTodo;
  final TextEditingController textEditingController;
  const AddTodoWidget({
    required this.onAddTodo,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: 'Enter todo title',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            onAddTodo(value);
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (textEditingController.text.trim().isNotEmpty) {
              onAddTodo(textEditingController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
