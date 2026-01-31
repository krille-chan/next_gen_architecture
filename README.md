# Frontend Architecture: Flutter App

Our goal is to create a maintainable MVVM architecture that is:

- easy to understand
- expandable
- easy to downscale
- intuitive
- testable
- accessible without deep knowledge of specific state solutions (Riverpod, BloC)

We aim to minimize dependencies on Riverpod while leveraging its strengths. The goal is **low coupling and high cohesion**.

To achieve this, we use basic Dart classes, Dart functions, and basic Flutter Widgets wherever possible. ViewModels and Services are basic Dart classes with Riverpod providers. Flows are simple Dart functions. We avoid Riverpod dependencies where possible.

We also minimize state usage. Page views must be stateless, and we separate state from view models. This intentionally adds overhead and makes app state changes less convenient to enforce careful consideration of each change.

## Directory structure

- android
- assets
    - images
    - sounds
- integration_test
- ios
- lib
    - config
        - constants.dart
        - routes.dart
        - themes.dart
    - extensions
        - matrix
        - ui
    - l10n
        - l10n_de.arb
        - l10n_en.arb
        - l10n_de.dart
        - ...
    - pages
        - home
            - flows
                - create_something_flow.dart
            - view_model
                - home_state.dart
                - home_view_model.dart
                - extra_provider.dart
            - widgets
            - home_page.dart
        - login
        - settings
    
    - services
        - matrix
            - flows
                - build_client.dart
            - client_service.dart
            - extra_provider.dart
        - push
        - calls
    - utils
    - widgets
        - dialogs
        - layouts
        - ...
        - my_app.dart
    - main.dart
- test
    - extensions
    - pages
        - home
            - home_view_model_test.dart
            - home_page_test.dart
    - services
        - matrix
            - models
                - client_model.dart
            - flows
                - build_client_test.dart
            - client_service_test.dart
    - widgets
        - my_app_test.dart
- web

## Pages & View Models

Every page in the app has it’s own directory. Every page directory is divided into:

- view_model
    - `<page>`_state.dart
    - `<page>`_view_model.dart
- widgets
    - reusable_widget.dart
- `<page>`_page.dart

While `<page>` is the name of the page.

### View Model State

`<page>`_state.dart contains a pure dart class with the state of the page. This dart class includes a `copyWith()` method.

**Example:**

```dart
class CounterState {
  final int count;
  final bool isLoading;
  final String? error;

  const CounterState({
    required this.count,
    required this.isLoading,
    this.error,
  });

  CounterState copyWith({
    int? count,
    bool? isLoading,
    String? error,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
```

<aside>
💡

> There are no dependencies to Riverpod or Flutter allowed here!
> 
</aside>

### View Model

The View Model in `<page>`_view_model.dart is a dart class extending StateNotifier with a auto dispose StateNotifierProvider, using the view model state.

**Example:**

```dart
final counterViewModelProvider = NotifierProvider.autoDispose(
	CounterViewModel.new
);

class CounterViewModel extends Notifier<CounterState> {
	@override
	CounterState build() = CounterState(
    count: 0,
    isLoading: false,
    error: null,
  );

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  Future<void> incrementAsync() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        count: state.count + 1,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
```

A page **can** have **multiple** view models or additional small providers if needed.

<aside>
💡

View Models **must not** have dependencies to Flutter! They must be independent from the UI.

</aside>

### UI & Widgets

The UI `<page>`_page.dart is a **stateless** **ConsumerWidget** which uses the View Model. Optionally widgets can be abstracted into a `widgets`directory. This is the **view layer!**

Example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterViewModelProvider);
    final viewModel = ref.read(counterViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Count: ${state.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            if (state.isLoading)
              const CircularProgressIndicator(),

            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: viewModel.increment,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => viewModel.incrementAsync(),
              child: const Text('Increment async'),
            ),
          ],
        ),
      ),
    );
  }
}
```

<aside>
💡

> There is no state or logic allowed in the view layer.
> 
</aside>

Reusable widgets under the `widgets` directory:

- **Must** never be used in other pages or in any other scope
- Can be stateful but s**hould** avoid own states and instead pass callbacks and states up to the view model
- **Should** avoid dependencies to Riverpod

<aside>
💡

Flows which contain the `BuildContext` (usually showing a dialog or multiple in a row) **must not** be part of the View Model, but become their own flow under `/lib/pages/<pagename>/flows/` !

</aside>

## Reusable Widgets

Reusable widgets under the universal `widgets` directory:

- **Must** be moved to the specific page directory if only used in one page
- **Can** be stateful but s**hould** avoid own states and instead pass callbacks and states up
- **Must** not have any dependencies to Riverpod

## Services & Flows

Services are holding the app logic and necessary app state. Services **must** be scoped under topics and can contain different types: Services, Flows, Providers.

Services must be suffixed with `_service.dart`  and are dart classes with a Riverpod provider, similar to view models. But their scope is not bound to a specific page.

Additionally a service topic can also contain small providers.

Example service  `counter_service.dart`:

```dart
final counterServiceProvider = Provider((ref) => CounterService());

class CounterService {
  CounterData _data = CounterData.initial;

  CounterData get data => _data;

  Future<void> load() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // hier z.B. SharedPreferences
    _data = CounterData(value: 0);
  }

  Future<void> save(CounterData newData) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _data = newData;
    // hier speichern
  }

  /// Convenience
  Future<void> increment() async {
    final newData = _data.copyWith(value: _data.value + 1);
    await save(newData);
  }
}
```

With a state model in the models directory `models/counter_data.dart`

```dart
class CounterData {
  final int value;

  const CounterData({required this.value});

  CounterData copyWith({int? value}) {
    return CounterData(value: value ?? this.value);
  }

  static const initial = CounterData(value: 0);
}
```

Flows must be in a subdirectory `flows` and are just simple dart functions. Examples are:

- `processPushNotification()`
- `buildDatabase()`
- `buildMatrixClient()`

In a service scope there can also be small additional providers.

## Extensions

Extensions are pure Dart/Flutter **extensions** to Classes from external libraries. Extensions must be scoped under topics.

They should be handy additions to existing classes. For example:

- Localization helpers like `Event.toLocalizedString()` (scoped under ``lib/extensions/matrix/`)
- UserSettingsClientExtension to get user settings from a Matrix Client by `Client.famedlyUserSettings`  (scoped under `/lib/extensions/matrix/famedly_user_settings/`)

<aside>
💡

> Extensions **must not** have any dependencies to Riverpod!
> 
</aside>

### Tests

Tests must reflect the lib file structure. Every file should have one test file while we use unit tests where we have no flutter dependencies.