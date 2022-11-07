import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:prtracker/widgets/record_edit_form.dart';

class RecordEditScreenArguments {
  final Record? initialRecord;
  RecordEditScreenArguments({required this.initialRecord});
}

class RecordEditScreen extends StatelessWidget {
  static const route = 'newRecord';

  const RecordEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final initialRecord = (ModalRoute.of(context)?.settings.arguments
            as RecordEditScreenArguments)
        .initialRecord;
    return PRTrackerScaffold(
        fab: null, child: RecordEditForm(initialRecord: initialRecord));
  }
}
