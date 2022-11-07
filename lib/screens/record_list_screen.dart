import 'dart:io';
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
  // ignore: library_private_types_in_public_api
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
        startActionPane: recordListTileStartActionPane(context, record),
        endActionPane: recordListTileEndActionPane(context, record),
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
      try {
        File imageFile =
            _localMediaService.openFileFromDisk(record.thumbnailUri!);
        return Image.file(imageFile);
      } catch (err) {
        return const FittedBox();
      }
    } else {
      return const FittedBox();
    }
  }

  ActionPane recordListTileStartActionPane(
      BuildContext context, Record record) {
    return ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: record.id != null ? startSlideActions(record.id!) : []);
  }

  ActionPane recordListTileEndActionPane(BuildContext context, Record record) {
    return ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: endSlideActions(record));
  }

  List<SlidableAction> startSlideActions(int recordId) {
    return <SlidableAction>[
      SlidableAction(
        onPressed: (((context) => _recordsService.deleteRecord(recordId))),
        icon: Icons.delete,
        label: 'Delete Record',
      )
    ];
  }

  List<SlidableAction> endSlideActions(Record record) {
    return <SlidableAction>[
      SlidableAction(
          onPressed: ((context) => openEditScreenForRecord(record)),
          icon: Icons.edit,
          label: 'Edit Record')
    ];
  }

  void openEditScreenForRecord(Record record) {
    Navigator.pushNamed(context, RecordEditScreen.route,
        arguments: RecordEditScreenArguments(initialRecord: record));
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
        arguments: RecordEditScreenArguments(initialRecord: null));
  }
}
