import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todolist/widgets/custom_icon_decoration.dart';

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventPageState();
  }
}

class Event {
  final String time;
  final String task;
  final String desc;
  final bool isFinish;

  const Event(this.time, this.task, this.desc, this.isFinish);
}

final List<Event> _eventList = [
  new Event("09:00", "Lear flutter.", "Personal", true),
  new Event("08:00", "Have coffe with Sam.", "Personal", true),
  new Event("09:00", "Have coffe with Alex.", "Personal", true),
  new Event("10:00", "Have coffe with Tom.", "Personal", false),
  new Event("10:50", "Edit API documentation.", "work", false),
  new Event("12:00", "Setup user focus group", "work", false),
];

class _EventPageState extends State<EventPage> {
  Box<Map> eventBox;

  @override
  void initState() {
    super.initState();
    eventBox = Hive.box<Map>("eventBox");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return ValueListenableBuilder(
        valueListenable: eventBox.listenable(),
        builder: (context, Box<Map> eventList, _) {
          return eventList.length == 0
              ? Center(
                  child: Text(
                    'No Events',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0x10000000)),
                  ),
                )
              : ListView.builder(
                  itemCount: eventList.length ?? 0,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final key = eventList.keys.toList()[index];
                    final value = eventList.get(key);
//            print(taskList.getAt(index));
//            final format = DateFormat.jm(); //"6:00 AM"
//                    print(value['eventDate']);
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Row(
                        children: <Widget>[
                          _lineStyle(context, iconSize, key,
                              eventList.length ?? 0, value['isComplete']),
                          _displayTime((value['eventTime'])),
                          _displayContent(value, key),
                        ],
                      ),
                    );
                  },
                );
        });
  }

  Expanded _displayContent(Map event, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(event['eventName']),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          Icons.done,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onTap: () {
                          setState(() {
                            eventBox.put(index, {
                              'eventName': event['eventName'],
                              'eventDetails': event['eventDetails'],
                              'eventDate': event['eventDate'],
                              'eventTime': event['eventTime'],
                              'lastUpdatedDate': DateTime.now(),
                              'isComplete': true
                            });
                          });
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.delete_sweep,
                          color: Colors.red,
                          size: 20,
                        ),
                        onTap: () {
                          setState(() {
                            eventBox.delete(index);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                event['eventDetails'],
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Event date: ${DateFormat.yMMMd().format(DateTime.parse(event['eventDate']))}',
                    style: TextStyle(fontSize: 8),
                  ),
                  Text(
                    'last update: ${DateFormat.yMMMd().format(event['lastUpdatedDate'])}',
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _displayTime(String time) {
    return Container(
        width: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${time}"),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
      decoration: CustomIconDecoration(
          iconSize: iconSize,
          lineWidth: 1,
          firstData: index == 0 ?? true,
          lastData: index == listLength - 1 ?? true),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3),
                  color: Color(0x20000000),
                  blurRadius: 5),
            ]),
        child: Icon(
            isFinish ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
            size: 20,
            color: Theme.of(context).accentColor),
      ),
    );
  }
}
