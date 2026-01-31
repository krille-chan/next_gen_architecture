import 'package:flutter/material.dart';

import '../pages/home/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Next Gen Architecture', home: const HomePage());
  }
}
