import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/services/local_media_service.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import '../utils/datetime_utils.dart';

class RecordListScreen extends StatefulWidget {
  static const route = '/';

  @override
  _RecordsListScreenState createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordListScreen> {
  final RecordsService _recordsService = GetIt.I.get();
  final LocalMediaService _localMediaService = GetIt.I.get();

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
                  return recordListTile(context, record);
                });
          }),
    );
  }

  // TODO: Different actions for L and R sliders?
  // TODO: Check whether file exists before attempting to instantiate image with file path
  Widget recordListTile(BuildContext context, Record record) {
    return Slidable(
        key: ValueKey(record.hashCode),
        startActionPane: recordListTileActionPane(context, record),
        endActionPane: recordListTileActionPane(context, record),
        child: ListTile(
            title: Text('${dateOnlyString(record.date)} ${record.exercise}'),
            subtitle: const Text('This is my subtitle.'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                trailingImage(record),
              ],
            ),
            onTap: () => listItemOnTap(context, record)));
  }

  Widget trailingImage(Record record) {
    if (record.thumbnailUri != null) {
      return Image.file(
          _localMediaService.openFileFromDisk(record.thumbnailUri!));
    } else {
      return const FittedBox();
    }
  }

  ActionPane recordListTileActionPane(BuildContext context, Record record) {
    return ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: record.id != null ? slideActions(record.id!) : []);
  }

  List<SlidableAction> slideActions(int recordId) {
    return <SlidableAction>[
      SlidableAction(
        onPressed: (((context) => _recordsService.deleteRecord(recordId))),
        icon: Icons.delete,
        label: 'Delete Record',
      )
    ];
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
