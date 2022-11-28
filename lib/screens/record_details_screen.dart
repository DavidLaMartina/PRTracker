import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/utils/datetime_utils.dart';
import 'package:prtracker/utils/string_utils.dart';
import 'package:prtracker/widgets/record_edit_form.dart';
import 'package:prtracker/widgets/video_player_wrapper.dart';

class RecordDetailsScreenArguments {
  final Record record;
  RecordDetailsScreenArguments({required this.record});
}

class RecordDetailsScreen extends StatefulWidget {
  static const route = 'recordDetails';

  const RecordDetailsScreen({super.key});

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final record = (ModalRoute.of(context)?.settings.arguments
            as RecordDetailsScreenArguments)
        .record;

    return Scaffold(
      appBar: AppBar(
        title: titleWidget(context, record),
        centerTitle: true,
        actions: [editButton(record)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [Expanded(child: weightRepsDisplay(context, record))]),
          Expanded(
            child: record.videoUri != null
                ? VideoPlayerWrapper(videoUri: record.videoUri!)
                : const Placeholder(),
          ),
          Row(
            children: [
              Expanded(
                child: notesDisplay(context, record),
              )
            ],
          )
        ],
      ),
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
        arguments: RecordEditScreenArguments(initialRecord: record));
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
