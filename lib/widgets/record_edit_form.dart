import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class RecordEditForm extends StatefulWidget {
  final Record? initialRecord;

  const RecordEditForm({super.key, this.initialRecord});

  @override
  // ignore: library_private_types_in_public_api
  _RecordEditFormState createState() => _RecordEditFormState();
}

class _RecordEditFormState extends State<RecordEditForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('Record Edit Form Placeholder'),
    );
  }
}
