import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/services/local_media_service.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:prtracker/widgets/calendar_date_picker.dart';

class RecordEditForm extends StatefulWidget {
  final Record? initialRecord;

  const RecordEditForm({
    super.key,
    this.initialRecord,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RecordEditFormState createState() => _RecordEditFormState();
}

class _RecordEditFormState extends State<RecordEditForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _videoPicker = ImagePicker();
  final RecordsService _recordsService = GetIt.I.get();
  final LocalMediaService _localMediaService = GetIt.I.get();

  DateTime _selectedDate = DateTime.now();
  RecordUnits _selectedUnits = RecordUnits.POUNDS;
  int _repsQuantity = 6;
  int _weightQuantity = 135;

  XFile? _pickedVideoFile;
  File? _pickedVideoThumbnailFile;

  TextEditingController? _exerciseTextController;
  TextEditingController? _notesTextController;
  TextEditingController? _weightQuantityTextController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialRecord?.date ?? DateTime.now();
    _selectedUnits = widget.initialRecord?.quantity.units ?? RecordUnits.POUNDS;
    _repsQuantity = widget.initialRecord?.reps ?? 6;
    // _weightQuantity = widget.initialRecord?.quantity.amount ?? 135;
    _pickedVideoThumbnailFile = widget.initialRecord?.thumbnailUri != null
        ? _localMediaService
            .openFileFromDisk(widget.initialRecord!.thumbnailUri!)
        : null;
    _exerciseTextController =
        TextEditingController(text: widget.initialRecord?.exercise);
    _notesTextController =
        TextEditingController(text: widget.initialRecord?.notes);
    _weightQuantityTextController = TextEditingController(
        text: widget.initialRecord?.quantity.amount.toString());
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
              Flexible(flex: 4, fit: FlexFit.tight, child: unitsDropdown()),
              Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: weightQuantityField(context)),
              Flexible(flex: 4, fit: FlexFit.tight, child: repsPicker()),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: datePickerButton(),
              ),
              Flexible(flex: 4, fit: FlexFit.tight, child: videoPickerButton()),
              Flexible(flex: 4, fit: FlexFit.tight, child: saveButton(context))
            ])));
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
        ));
      });
    }
  }

  Widget datePickerButton() {
    return Scaffold(
        body: Center(
            child: PRTrackerDatePicker(
      caption: 'Open date selector',
      onDateSelected: _selectDate,
      restorationId: 'record_edit_form',
    )));
  }

  Widget exerciseForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Exercise',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
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

  Widget weightQuantityField(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: _weightQuantityTextController,
          decoration: const InputDecoration(
              labelText: 'Quantity', border: OutlineInputBorder()),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headline5,
          validator: (value) => validateWeightQuantity(value!),
        ));
  }

  String? validateWeightQuantity(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return 'Enter an integer value for the number of pounds, kilograms, or plates.';
    } else {
      return null;
    }
  }

  Widget repsPicker() {
    return NumberPicker(
        minValue: 0,
        maxValue: 100,
        value: _repsQuantity,
        onChanged: (quantity) => setState(() => _repsQuantity = quantity));
  }

  // https://api.flutter.dev/flutter/material/showDatePicker.html
  Widget unitsDropdown() {
    return DropdownButton<RecordUnits>(
      items: RecordUnitsMap.entries.map<DropdownMenuItem<RecordUnits>>((entry) {
        return DropdownMenuItem<RecordUnits>(
            value: entry.key, child: Text(entry.value));
      }).toList(),
      value: _selectedUnits,
      onChanged: (value) {
        setState(() {
          _selectedUnits = value!;
        });
      },
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
      ),
    );
  }

  // TODO: Auto-choose time in the middle of the clip for thumbnail and / or allow
  // user to select their own time.

  Future _pickVideo() async {
    final pickedVideoFile =
        await _videoPicker.pickVideo(source: ImageSource.gallery);
    final pickedVideoThumbnailFile = pickedVideoFile != null
        ? File((await _localMediaService
            .generateThumbnailFromVideoFile(pickedVideoFile!))!)
        : null;
    setState(() {
      _pickedVideoFile = pickedVideoFile;
      _pickedVideoThumbnailFile = pickedVideoThumbnailFile;
    });
  }

  Widget videoPickerButton() {
    return ElevatedButton(
        onPressed: () async {
          await _pickVideo();
        },
        child: thumbnailDisplay());
  }

  Widget thumbnailDisplay() {
    return _pickedVideoThumbnailFile != null
        ? Image.file(_pickedVideoThumbnailFile!)
        : const Placeholder();
  }

  Widget saveButton(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Semantics(
          button: true,
          enabled: true,
          onLongPressHint: 'Submit record',
          child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue)),
            child: ElevatedButton(
              onPressed: (() async {
                if (await validateAndSave()) {
                  Navigator.pop(context);
                }
              }),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.headline5,
              ),
              // onPressed: () => validateAndSave(context),
            ),
          ),
        ));
  }

  Future<bool> validateAndSave() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    Record newRecord = await buildRecord();
    await saveRecord(newRecord);
    return true;
  }

  Future<void> saveRecord(Record record) async {
    if (widget.initialRecord != null && widget.initialRecord!.id != null) {
      record.id = widget.initialRecord!.id;
      await _recordsService.updateRecord(record);
    } else {
      await _recordsService.insertRecord(record);
    }
  }

  Future<Record> buildRecord(
      {String? videoUri, String? videoThumbnailUri}) async {
    return Record(
        date: _selectedDate,
        quantity: buildRecordQuantity(),
        reps: _repsQuantity,
        exercise: _exerciseTextController!.text,
        notes: _notesTextController!.text,
        videoUri: await _localMediaService.saveXFileToDisk(_pickedVideoFile),
        thumbnailUri:
            await _localMediaService.saveFileToDisk(_pickedVideoThumbnailFile));
  }

  RecordQuantity buildRecordQuantity() {
    return RecordQuantity(
        units: _selectedUnits,
        amount: int.parse(_weightQuantityTextController!.text),
        change: 0,
        perSide: false);
  }
}
