import 'package:flutter/material.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';

class NewWasteScreenArguments {
  final String localVideoPath;
  NewWasteScreenArguments({this.localVideoPath = ''});
}

class NewRecordScreen extends StatelessWidget {
  static const route = 'newRecord';

  const NewRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PRTrackerScaffold(
        child: const Placeholder(child: Text('New Record Screen')));
  }
}
