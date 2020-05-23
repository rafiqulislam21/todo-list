import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/add_event_page.dart';
import 'pages/add_task_page.dart';
import 'pages/event_page.dart';
import 'pages/task_page.dart';
import 'widgets/custom_button.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<Map>("taskBox");
  await Hive.openBox<Map>("eventBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'MontserratAlternates',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  DateTime today = DateTime.now();

  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 35,
            color: Theme.of(context).accentColor,
          ),
          Positioned(
            right: 0,
            child: Text(
              '${DateFormat.d().format(today)}',
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          ),
          _mainContent(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: currentPage == 1 ? AddEventPage() : AddTaskPage(),
//                  child: AddEventPagePage(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                );
              }).then((val) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            '${DateFormat.EEEE().format(today)}',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _button(context),
        ),
        Expanded(
            child: PageView(

              controller: _pageController,
              children: <Widget>[TaskPage(), EventPage()],
            ))
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
            onPressed: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut);
            },
            buttonText: "Tasks",
            color: currentPage < 0.5
                ? Theme.of(context).accentColor
                : Colors.white,
            textColor: currentPage < 0.5
                ? Colors.white
                : Theme.of(context).accentColor,
            borderColor: currentPage < 0.5
                ? Colors.transparent
                : Theme.of(context).accentColor,
          ),
        ),
        SizedBox(
          width: 32,
        ),
        Expanded(
          child: CustomButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut);
            },
            buttonText: "Events",
            color: currentPage > 0.5
                ? Theme.of(context).accentColor
                : Colors.white,
            textColor: currentPage > 0.5
                ? Colors.white
                : Theme.of(context).accentColor,
            borderColor: currentPage > 0.5
                ? Colors.transparent
                : Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}
