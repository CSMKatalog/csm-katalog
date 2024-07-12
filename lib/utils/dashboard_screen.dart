import 'package:flutter/material.dart';
import 'package:csmkatalog/models/client.dart';

class DashboardScreen {
  String label;
  IconData icon;
  Widget Function() widgetFunction;

  DashboardScreen({required this.label, required this.icon, required this.widgetFunction});
}

class ProgressScreen {
  String label;
  IconData icon;
  Widget Function(Client client) widgetFunction;

  ProgressScreen({required this.label, required this.icon, required this.widgetFunction});
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
