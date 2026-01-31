import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_gen_architecture/pages/home/view_model/create_user_view_model.dart';

class CreateUserBottomSheet extends ConsumerWidget {
  const CreateUserBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createUserViewModelProvider);
    final viewModel = ref.read(createUserViewModelProvider.notifier);

    return Material(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create New User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Error Message
              if (state.hasError)
                Text(
                  state.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              if (state.hasError) const SizedBox(height: 16),

              // First Name Field
              const Text('First Name'),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.firstNameController,
                enabled: state.connectionState != ConnectionState.waiting,
                decoration: const InputDecoration(hintText: 'Enter first name'),
              ),
              const SizedBox(height: 16),

              // Last Name Field
              const Text('Last Name'),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.lastNameController,
                enabled: state.connectionState != ConnectionState.waiting,
                decoration: const InputDecoration(hintText: 'Enter last name'),
              ),
              const SizedBox(height: 16),

              // Email Field
              const Text('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.emailController,
                enabled: state.connectionState != ConnectionState.waiting,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: state.connectionState == ConnectionState.waiting
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          disabledBackgroundColor: Colors.blue.shade300,
                        ),
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await viewModel.createUser();
                          if (context.mounted && state.error == null) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Create User',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: state.connectionState == ConnectionState.waiting
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
