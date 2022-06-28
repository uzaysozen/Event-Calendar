import 'package:countdown_app/models/event.dart';
import 'package:countdown_app/data/dbHelper.dart';
import 'package:flutter/material.dart';

import 'event_add.dart';

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventListState();
  }
}

class _EventListState extends State {
  var dbHelper = DbHelper();
  List<Event>? events;
  int eventCount = 0;

  @override
  void initState() {
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event List"),
      ),
      body: buildEventList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){goToEventAdd();},
        child: Icon(Icons.add),
        tooltip: "Add new event",
      ),
    );
  }

  ListView buildEventList() {
    return ListView.builder(
        itemCount: eventCount,
        itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.cyan,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.black12, child: Text("E"),),
              title: Text(this.events![position].name!),
              subtitle: Text(this.events![position].endDate.toString()),
            ),
          );
        }
    );
  }

  void goToEventAdd() async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>EventAdd()));
    if (result != null) {
      if (result) {
        getEvents();
      }
    }
  }

  void getEvents() async {
    var eventsFuture = dbHelper.getEvents();
    eventsFuture.then((data) {
      setState((){
        this.events = data;
        eventCount = data!.length;
      });
    });
  }
}