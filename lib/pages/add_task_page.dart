import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/model/database.dart';
import 'package:flutter_to_do_list/model/todo.dart';
import 'package:flutter_to_do_list/widgets/custom_button.dart';
import 'package:flutter_to_do_list/widgets/custom_date_time_picker.dart';
import 'package:flutter_to_do_list/widgets/custom_modal_action_button.dart';
import 'package:flutter_to_do_list/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddTaskState();
  }
}

class _AddTaskState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  final _textTaskController = TextEditingController();

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
  Widget build(BuildContext context) {
    _textTaskController.clear();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              "Add new task",
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
                Database().insertTodoEntries(new TodoData(
                    id: null,
                    date: _selectedDate,
                    time: DateTime.now(),
                    task: _textTaskController.text,
                    description: "N/A",
                    isFinish: false,
                    todoType: TodoType.TYPE_TASK.index)).whenComplete(() => Navigator.of(context).pop());
              }
            },
          ),


        ],
      ),
    );
  }

}
