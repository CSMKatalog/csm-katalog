import 'package:flutter/material.dart';

class Screen {
  String label;
  IconData icon;
  Widget Function() widgetFunction;

  Screen({required this.label, required this.icon, required this.widgetFunction});
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
