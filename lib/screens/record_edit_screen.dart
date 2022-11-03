import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:prtracker/widgets/record_edit_form.dart';

class RecordEditScreenArguments {
  final Record? iniitalRecord;
  RecordEditScreenArguments({required this.iniitalRecord});
}

class RecordEditScreen extends StatelessWidget {
  static const route = 'newRecord';

  const RecordEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PRTrackerScaffold(fab: null, child: const RecordEditForm());
  }
}
