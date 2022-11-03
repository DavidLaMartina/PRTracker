import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/main.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import '../utils/datetime_utils.dart';

class RecordListScreen extends StatefulWidget {
  static const route = '/';

  @override
  _RecordsListScreenState createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordListScreen> {
  RecordsService _recordsService = GetIt.I.get();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PRTrackerScaffold(
      fab: newRecordFab(context),
      child: StreamBuilder<List<Record>>(
          stream: _recordsService.onRecords(),
          builder: (context, snapshot) {
            var records = snapshot.data;
            if (records == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  var record = records[index];
                  return ListTile(
                      title: Text(
                          '${dateOnlyString(record.date)} ${record.exercise}'),
                      subtitle: const Text('This is my subtitle.'),
                      onTap: () => listItemOnTap(context, record));
                });
          }),
    );
  }

  void listItemOnTap(BuildContext context, Record record) {
    Navigator.pushNamed(context, RecordDetailsScreen.route,
        arguments: RecordDetailsScreenArguments(record: record));
  }

  FloatingActionButton newRecordFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => newRecordButtonPressed(context),
      tooltip: 'New Record',
      child: const Icon(Icons.add),
    );
  }

  void newRecordButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, RecordEditScreen.route,
        arguments: RecordEditScreenArguments(iniitalRecord: null));
  }
}
