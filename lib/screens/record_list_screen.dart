import 'package:flutter/material.dart';
import 'package:prtracker/main.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';

class RecordListScreen extends StatelessWidget {
  static const route = '/';

  const RecordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PRTrackerScaffold(
      child: StreamBuilder<List<Record>>(
          stream: recordsService.onRecords(),
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
                      title: Text(record.videoUri ?? ''),
                      subtitle: const Text('This is my subtitle.'),
                      onTap: () {});
                });
          }),
    );
  }
}
