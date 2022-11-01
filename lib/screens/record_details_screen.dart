import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/utils/datetime_utils.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';

class RecordDetailsScreenArguments {
  final Record record;
  RecordDetailsScreenArguments({required this.record});
}

class RecordDetailsScreen extends StatelessWidget {
  static const route = 'recordDetails';

  const RecordDetailsScreen({super.key});

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
              flex: 2,
              child: detailsScreenWrapper(dateDisplay(context, record))),
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
