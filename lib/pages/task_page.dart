import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/model/database.dart';
import 'package:flutter_to_do_list/model/todo.dart';
import 'package:flutter_to_do_list/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TaskPage();
  }
}

class Task{
  final String task;
  final bool isFinish;
  const Task(this.task, this.isFinish);
}
final List<Task> _taskList = [
  new Task('Call Tom about apointment.', false),
  new Task('Fix on boarding experience.', false),
  new Task('Edit API documentation.', false),
  new Task('Set up user focus group.', false),

  new Task('Have coffee with Sam.', true),
  new Task('Meet with Sales.', true),
  new Task('Have coffee with Sam.', true),
  new Task('Meet with Sales.', true),
  new Task('Have coffee with Sam.', true),
  new Task('Meet with Sales.', true),
  new Task('Have coffee with Sam.', true),
  new Task('Meet with Sales.', true),
];

class _TaskPage extends State<TaskPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: Database().getTodoByType(TodoType.TYPE_TASK.index),
      builder: (context, snapshot){
       return snapshot.data == null
           ? Center(child: CircularProgressIndicator())
           : ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            return snapshot.data[index].isFinish
                ? _taskComplete(snapshot.data[index])
                : _taskUncomplete(snapshot.data[index]);
          },
        );
      },

    );
  }


  Widget _taskUncomplete(TodoData data) {
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
          builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),

                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),

                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),

                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        onPressed: (){
                          setState(() {
                            Database()
                                .completeTodoEntries(data.id)
                                .whenComplete(()=> Navigator.of(context).pop());
                          });
                        },
                        buttonText: "Complete",
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,

                      ),

                    ],
                  ),
                ),
              );
          });
      },
      onLongPress: (){
        showDialog(
            context: context,
            builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Delete Task",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),

                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),

                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),

                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        onPressed: (){
                          setState(() {
                            Database()
                                .deleteTodoEntries(data.id)
                                .whenComplete(()=> Navigator.of(context).pop());
                          });
                        },
                        buttonText: "Delete",
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,

                      ),

                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data.task),
          ],
        ),
      ),
    );
  }

  Widget _taskComplete(TodoData data) {
    return Container(
      foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data.task),
          ],
        ),
      ),
    );
  }

}