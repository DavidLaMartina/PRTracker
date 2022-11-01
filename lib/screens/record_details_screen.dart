import 'package:flutter/material.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';

class RecordDetailsScreen extends StatelessWidget {
  static const route = 'recordDetails';

  const RecordDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PRTrackerScaffold(
        child: const Placeholder(
      child: Text('Details screen'),
    ));
  }
}
