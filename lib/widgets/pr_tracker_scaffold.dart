import 'package:flutter/material.dart';

class PRTrackerScaffold extends StatelessWidget {
  final Widget child;
  final FloatingActionButton? fab;

  PRTrackerScaffold({super.key, required this.child, required this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PR Tracker'),
        centerTitle: true,
      ),
      body: Center(child: child),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
