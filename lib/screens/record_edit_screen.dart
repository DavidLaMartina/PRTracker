import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/widgets/record_edit_form.dart';

class RecordEditScreenArguments {
  final Record? initialRecord;
  RecordEditScreenArguments({required this.initialRecord});
}

class RecordEditScreen extends StatelessWidget {
  static const route = '/editRecord';
  Record? initialRecord;

  RecordEditScreen({super.key, this.initialRecord});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final initialRecord =
        args is RecordEditScreenArguments ? args.initialRecord : null;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Record')),
      body: Padding(
          padding: const EdgeInsets.all(5),
          // Use of SingleChildScrollView adapated from
          // https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: RecordEditForm(
                      initialRecord: initialRecord,
                    ))
                  ],
                )),
              ));
            },
          )),
    );
  }
}
