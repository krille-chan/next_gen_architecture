import 'package:flutter/material.dart';

import 'package:next_gen_architecture/pages/home/home_page_presenter.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Gen Architecture',
      home: const HomePagePresenter(),
    );
  }
}
