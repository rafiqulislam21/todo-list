import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/tasks.dart';
import 'package:todolist/pages/task_page.dart';
import 'package:todolist/widgets/custom_date_time_picker.dart';
import 'package:todolist/widgets/custom_modal_action_button.dart';
import 'package:todolist/widgets/custom_textfield.dart';

class AddTaskPage extends StatefulWidget {
  final updateTaskData;
  final updateIndex;

  const AddTaskPage({Key key, this.updateTaskData, this.updateIndex,}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddTaskState();
  }
}

class _AddTaskState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _textTaskController;
  Box<Map> taskBox;

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        _selectedDate = datepick;
      });
  }

  @override
  void initState() {
    super.initState();
    _textTaskController = TextEditingController(text: widget.updateTaskData != null ? widget.updateTaskData['taskName'] : "");
    _textTaskController.addListener(() {
      _textTaskController.text;
    });
    taskBox = Hive.box<Map>("taskBox");

  }

  @override
  void dispose() {
    super.dispose();
    _textTaskController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              widget.updateIndex == null ? "Add new task" : "Update task",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          SizedBox(
            height: 24,
          ),

          CustomTextfield(labelText: 'Enter task name', controller: _textTaskController,),
//          TextField(
//            decoration: InputDecoration(
//                border: OutlineInputBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(12)),
//                ),
//                labelText: 'Enter task name',
//            ),
//
//          ),

          SizedBox(
            height: 24,
          ),

          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
          ),

          SizedBox(
            height: 24,
          ),

          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              if ( _textTaskController.text == ""){
                print("data not found");
              }else{
//                taskBox.put(1,_textTaskController.text);
              widget.updateIndex != null ? taskBox.put(widget.updateIndex, {
                'taskName': _textTaskController.text,
                'taskDate': _selectedDate,
                'lastUpdatedDate': DateTime.now(),
                'isComplete': false
              }) : taskBox.add({
                'taskName': _textTaskController.text,
                'taskDate': _selectedDate,
                'lastUpdatedDate': DateTime.now(),
                'isComplete': false
              });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
