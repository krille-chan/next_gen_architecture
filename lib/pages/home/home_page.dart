import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_gen_architecture/pages/home/flows/add_task_flow.dart';

import 'view_model/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: state.isLoading ? null : viewModel.deleteCompletedTodos,
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Text(
                state.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          Expanded(
            child: state.isLoading && state.todos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(128),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No todos yet',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(128),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add one using the button below',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(128),
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return Dismissible(
                        key: Key(todo.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: Theme.of(context).colorScheme.error,
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                        onDismissed: (_) => viewModel.deleteTodo(todo.id),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: state.isLoading
                                ? null
                                : (_) => viewModel.toggleTodo(todo.id),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isCompleted
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(128)
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: state.isLoading
                                ? null
                                : () => viewModel.deleteTodo(todo.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (state.isLoading && state.todos.isNotEmpty)
            const LinearProgressIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.isLoading
            ? null
            : () => showAddTodoDialog(context, viewModel.addTodo),
        child: const Icon(Icons.add),
      ),
    );
  }
}
