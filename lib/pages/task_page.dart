import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todolist/pages/add_task_page.dart';
import 'package:todolist/widgets/custom_button.dart';

class TaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TaskPage();
  }
}

class _TaskPage extends State<TaskPage>{
  Box<Map> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Map>("taskBox");
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box<Map> taskList, _){
//        print(taskList.length);
       return taskList.length == 0
           ? Center(child: Text(
         'No Tasks',
         style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0x10000000)),
       ),)
           :  ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: taskList.length??0,
          itemBuilder: (context, index){

            final key = taskList.keys.toList()[index];
            final value = taskList.get(key);
//            print(taskList.getAt(index));
            return value['isComplete'] == true
                ? _taskComplete(value, key)
                : _taskIncomplete(value, key);
          },
        );
      },

    );
  }


  Widget _taskIncomplete(Map data, int index) {
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
                      Text(data['taskName']),

                      SizedBox(
                        height: 24,
                      ),
//                      Text(new DateFormat("dd-MM-yyyy").format("10/02/2020")),

                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        onPressed: (){
                          setState(() {
                            taskBox.put(index, {
                              'taskName': data['taskName'],
                              'taskDate': data['taskDate'],
                              'lastUpdatedDate': DateTime.now(),
                              'isComplete': true
                            });
                          });
                          Navigator.pop(context);
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
                      Text(data['taskName']),

                      SizedBox(
                        height: 24,
                      ),
//                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),

                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        onPressed: (){
                          setState(() {
                            print(index);
                            taskBox.delete(index);
                            Navigator.pop(context);
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
      child: ListTile(
        isThreeLine: true,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal:5),
        leading: Icon(
          Icons.radio_button_unchecked,
          color: Theme.of(context).accentColor,
          size: 20,
        ),
        title: Text(data['taskName']),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Task date: ${DateFormat.yMMMd().format(data['taskDate'])}',style: TextStyle(fontSize: 9),),
            Text('last update: ${DateFormat.yMMMd().format(data['lastUpdatedDate'])}',style: TextStyle(fontSize: 9),),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext contex) {
                  return Dialog(
                    //update task
                    child: AddTaskPage(
                      updateIndex: index,
                      updateTaskData: data,
                    ),
//                  child: AddEventPagePage(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  );
                }).then((val) {
              setState(() {});
            });
          },
          icon: Icon(
          Icons.edit,
          color: Theme.of(context).accentColor,
          size: 20,
        ),),
      )
    );
  }

  Widget _taskComplete(Map data, int index) {
    return InkWell(
      child: Container(
        foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
        child: ListTile(
          isThreeLine: true,
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal:5),
          leading: Icon(
            Icons.radio_button_checked,
            color: Theme.of(context).accentColor,
            size: 20,
          ),
          title: Text(data['taskName']),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Task date: ${DateFormat.yMMMd().format(data['taskDate'])}',style: TextStyle(fontSize: 9),),
              Text('last update: ${DateFormat.yMMMd().format(data['lastUpdatedDate'])}',style: TextStyle(fontSize: 9),),
            ],
          ),
          trailing: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
          ),
        ),
      ),
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
                      Text(data['taskName']),

                      SizedBox(
                        height: 24,
                      ),
//                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),

                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        onPressed: (){
                          setState(() {
                            taskBox.delete(index);
                            Navigator.pop(context);
                            /*Database()
                                .deleteTodoEntries(data.id)
                                .whenComplete(()=> Navigator.of(context).pop());*/
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
    );
  }

}