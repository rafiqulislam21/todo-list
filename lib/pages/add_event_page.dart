import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/widgets/custom_date_time_picker.dart';
import 'package:todolist/widgets/custom_modal_action_button.dart';
import 'package:todolist/widgets/custom_textfield.dart';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddEventPage();
  }
}

class _AddEventPage extends State<AddEventPage> {
  String _selectedDate = 'Pick date';
  String _selectedTime = 'Pick time';

  TextEditingController eventNameController;
  TextEditingController eventDetailsController;

  Box<Map> eventBox;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    eventDetailsController = TextEditingController();
    eventNameController.addListener(() {
      eventNameController.text;
    });
    eventDetailsController.addListener(() {
      eventDetailsController.text;
    });
    eventBox = Hive.box<Map>("eventBox");
  }
  @override
  void dispose() {
    eventNameController.dispose();
    eventDetailsController.dispose();
    super.dispose();
  }


  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        _selectedDate = datepick.toString();
      });
  }

  Future _pickTime() async {
    TimeOfDay timepick = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());

    if (timepick != null)
      setState(() {
        _selectedTime = timepick.format(context).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                "Add new event",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            CustomTextfield(
              labelText: 'Enter event name',
              controller: eventNameController,
            ),
            SizedBox(
              height: 24,
            ),
            CustomTextfield(
              labelText: 'Enter Description',
              controller: eventDetailsController,
            ),
            SizedBox(
              height: 15,
            ),
            CustomDateTimePicker(
              icon: Icons.date_range,
              onPressed: _pickDate,
              value: _selectedDate,
            ),
            CustomDateTimePicker(
              icon: Icons.access_time,
              onPressed: _pickTime,
              value: _selectedTime,
            ),

            SizedBox(
              height: 24,
            ),
            CustomModalActionButton(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSave: () {
                eventBox.add({
                  'eventName': eventNameController.text,
                  'eventDetails': eventDetailsController.text,
                  'eventDate': _selectedDate,
                  'eventTime': _selectedTime,
                  'lastUpdatedDate': DateTime.now(),
                  'isComplete': false
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }


}
