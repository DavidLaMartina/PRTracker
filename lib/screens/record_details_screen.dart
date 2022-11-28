import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:prtracker/utils/datetime_utils.dart';
import 'package:prtracker/utils/string_utils.dart';
import 'package:prtracker/widgets/video_player_wrapper.dart';

class RecordDetailsScreenArguments {
  // final Record record;
  // RecordDetailsScreenArguments({required this.record});

  final int recordId;
  RecordDetailsScreenArguments({required this.recordId});
}

class RecordDetailsScreen extends StatefulWidget {
  static const route = 'recordDetails';

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  final RecordsService _recordsService = GetIt.I.get();

  late Future<Record> _recordFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordId = (ModalRoute.of(context)?.settings.arguments
            as RecordDetailsScreenArguments)
        .recordId;

    _recordFuture = _recordsService.getRecord(recordId);

    return FutureBuilder(
      future: _recordFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final snapshotRecord = snapshot.data!;
          return Scaffold(
              appBar: AppBar(
                title: titleWidget(context, snapshotRecord),
                centerTitle: true,
                actions: [editButton(snapshotRecord)],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: weightRepsDisplay(context, snapshotRecord))
                    ],
                  ),
                  Expanded(
                      child: snapshotRecord.videoUri != null
                          ? VideoPlayerWrapper(
                              videoUri: snapshotRecord.videoUri!)
                          : const Placeholder()),
                  Row(
                    children: [
                      Expanded(
                        child: notesDisplay(context, snapshotRecord),
                      )
                    ],
                  )
                ],
              ));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget editButton(Record record) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: (() => onEditButtonPressed(context, record)),
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  void onEditButtonPressed(BuildContext context, Record record) {
    Navigator.pushNamed(context, RecordEditScreen.route,
            arguments: RecordEditScreenArguments(initialRecord: record))
        .then((_) => setState(() {}));
  }

  Widget titleWidget(BuildContext context, Record record) {
    return Column(
      children: [Text(record.exercise), dateDisplay(context, record)],
    );
  }

  Widget dateDisplay(BuildContext context, Record record) {
    return Text(
      dateOnlyString(record.date),
      style: Theme.of(context).textTheme.bodyText2,
      textAlign: TextAlign.center,
    );
  }

  Widget weightRepsDisplay(BuildContext context, Record record) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        '${record.quantity.amount} ${RecordUnitsMap[record.quantity.units]} x ${record.reps}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget notesDisplay(BuildContext context, Record record) {
    if (isNullOrEmpty(record.notes)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Text(
                  record.notes!,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
