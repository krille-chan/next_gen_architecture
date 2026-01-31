import 'package:flutter/material.dart';

class CenterInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const CenterInfo({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 16,
          children: [
            Icon(icon),
            Text(label, textAlign: .center),
          ],
        ),
      ),
    );
  }
}
