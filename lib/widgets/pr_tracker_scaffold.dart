import 'package:flutter/material.dart';

class PRTrackerScaffold extends StatelessWidget {
  final Widget child;

  PRTrackerScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PR Tracker'),
          centerTitle: true,
        ),
        body: Center(child: child));
  }
}
