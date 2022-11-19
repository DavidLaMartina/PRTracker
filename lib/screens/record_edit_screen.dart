import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:prtracker/widgets/record_edit_form.dart';

class RecordEditScreenArguments {
  final Record? initialRecord;
  RecordEditScreenArguments({required this.initialRecord});
}

class RecordEditScreen extends StatelessWidget {
  static const route = '/editRecord';
  Record? initialRecord;

  RecordEditScreen({super.key, this.initialRecord});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final initialRecord =
        args is RecordEditScreenArguments ? args.initialRecord : null;
    return PRTrackerScaffold(
        fab: null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RecordEditForm(initialRecord: initialRecord),
        ));
  }
}
