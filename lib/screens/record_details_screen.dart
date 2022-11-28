import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/utils/datetime_utils.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:prtracker/widgets/video_player_wrapper.dart';
import 'package:video_player/video_player.dart';

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

    return PRTrackerScaffold(
      fab: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: record.videoUri != null
                  ? VideoPlayerWrapper(videoUri: record.videoUri!)
                  : const Placeholder()),
          Expanded(child: detailsScreenWrapper(dateDisplay(context, record))),
        ],
      ),
    );
  }

  Widget dateDisplay(BuildContext context, Record record) {
    return Text(
      dateOnlyString(record.date),
      style: Theme.of(context).textTheme.bodyText2,
      textAlign: TextAlign.center,
    );
  }

  Widget detailsScreenWrapper(Widget child) {
    return Center(
        child: Padding(padding: const EdgeInsets.all(10), child: child));
  }
}
