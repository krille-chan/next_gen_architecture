import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterPage extends StatelessWidget {
  final int counter;
  final void Function() increase;
  const CounterPage({super.key, required this.counter, required this.increase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter example')),
      body: Center(child: Text(counter.toString())),
      floatingActionButton: FloatingActionButton(
        onPressed: increase,
        child: Icon(Icons.add),
      ),
    );
  }
}

final counterViewModelProvider = NotifierProvider.autoDispose(
  CounterViewModel.new,
);

class CounterViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void increase() {
    state = state + 1;
  }
}

class CounterPagePresenter extends ConsumerWidget {
  const CounterPagePresenter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CounterPage(
      counter: ref.watch(counterViewModelProvider),
      increase: ref.read(counterViewModelProvider.notifier).increase,
    );
  }
}
