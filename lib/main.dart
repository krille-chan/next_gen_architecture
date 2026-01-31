import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_gen_architecture/widgets/app_widget.dart';

void main() {
  runApp(const ProviderScope(child: AppWidget()));
}
