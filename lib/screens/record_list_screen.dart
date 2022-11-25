import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/models/record_filter.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/services/local_media_service.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:prtracker/widgets/record_filter_bar.dart';
import '../utils/datetime_utils.dart';

class RecordListScreen extends StatefulWidget {
  static const route = '/';

  const RecordListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordsListScreenState createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordListScreen> {
  final RecordsService _recordsService = GetIt.I.get();
  final LocalMediaService _localMediaService = GetIt.I.get();

  RecordFilter? _recordFilter;

  void _onFilter(RecordFilter filter) {
    setState(() => {_recordFilter = filter});
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('PR Tracker'),
        ),
        body: Column(children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: ExpandablePanel(
                header: const Text('Header'),
                collapsed: const Text('Collapsed'),
                expanded: RecordFilterBar(onFilter: _onFilter),
              ),
            ),
          ),
          Flexible(
            child: StreamBuilder<List<Record>>(
                stream: _recordsService.onRecordsFilter(_recordFilter),
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
          ),
        ]));
  }

  // TODO: Different actions for L and R sliders?
  // TODO: Check whether file exists before attempting to instantiate image with file path
  Widget recordListTile(BuildContext context, Record record) {
    return Slidable(
        key: ValueKey(record.hashCode),
        startActionPane: recordListTileStartActionPane(context, record),
        endActionPane: recordListTileEndActionPane(context, record),
        child: ListTile(
            title: Text(recordHeadingText(record)),
            subtitle: Text('${dateOnlyString(record.date)}'),
            trailing: trailingImage(record),
            onTap: () => listItemOnTap(context, record)));
  }

  Widget? trailingImage(Record record) {
    if (record.thumbnailUri != null) {
      try {
        File imageFile =
            _localMediaService.openFileFromDisk(record.thumbnailUri!);
        return Image.file(imageFile);
      } catch (err) {
        return null;
      }
    } else {
      return null;
    }
  }

  String recordHeadingText(Record record) {
    return '${record.exercise}: ${weightRepsDisplay(record)}';
  }

  String weightRepsDisplay(Record record) {
    return '${weightQuantitydisplay(record.quantity)} x ${record.reps}';
  }

  String weightQuantitydisplay(RecordQuantity quantity) {
    return '${quantity.amount} ${RecordUnitsMap[quantity.units]}';
  }

  ActionPane recordListTileStartActionPane(
      BuildContext context, Record record) {
    return ActionPane(
        motion: const ScrollMotion(),
        children: record.id != null ? startSlideActions(record.id!) : []);
  }

  ActionPane recordListTileEndActionPane(BuildContext context, Record record) {
    return ActionPane(
        motion: const ScrollMotion(), children: endSlideActions(record));
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
