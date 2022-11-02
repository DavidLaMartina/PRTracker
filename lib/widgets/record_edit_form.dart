import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class RecordEditForm extends StatefulWidget {
  final Record? initialRecord;

  final String? restorationId;

  const RecordEditForm({super.key, this.initialRecord, this.restorationId});

  @override
  // ignore: library_private_types_in_public_api
  _RecordEditFormState createState() => _RecordEditFormState();
}

// TODOs
// Location data
// Pop scope / dirty

class _RecordEditFormState extends State<RecordEditForm> with RestorationMixin {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
              restorationId: 'date_picker_dialog',
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate:
                  DateTime.fromMillisecondsSinceEpoch(arguments! as int),
              firstDate: DateTime(2021),
              lastDate: DateTime(2023));
        });
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected ${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  TextEditingController? _exerciseTextController;
  TextEditingController? _notesTextController;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void initState() {
    super.initState();
    _exerciseTextController =
        TextEditingController(text: widget.initialRecord?.exercise);
    _notesTextController =
        TextEditingController(text: widget.initialRecord?.notes);
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: exerciseForm(),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: notesForm(),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: datePickerButton(),
              )
            ])));
  }

  Widget datePickerButton() {
    return Scaffold(
        body: Center(
      child: OutlinedButton(
        onPressed: () => _restorableDatePickerRouteFuture.present(),
        child: const Text('Open date selector'),
      ),
    ));
  }

  Widget exerciseForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Exercise',
        border: OutlineInputBorder(),
      ),
      controller: _exerciseTextController,
      validator: (val) => val!.isNotEmpty ? null : 'Exercise must not be empty',
    );
  }

  Widget notesForm() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: 'Notes', border: OutlineInputBorder()),
      controller: _notesTextController,
      validator: (val) => val!.isNotEmpty ? null : 'Exercise must not be empty',
    );
  }
}
