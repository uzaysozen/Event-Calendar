import 'package:countdown_app/models/event.dart';
import 'package:countdown_app/data/dbHelper.dart';
import 'package:flutter/material.dart';

import 'event_add.dart';
import 'event_detail.dart';

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

  Container buildEventList() {
    return Container(
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: <Widget>[
          for (int index = 0; index < eventCount; index += 1)
            Card(
                color: Colors.lightBlueAccent,
                elevation: 2.0,
                key: Key('$index'),
                child: SizedBox(
                    width: 300,
                    height: 90,
                    child: ListTile(
                      leading: Icon(Icons.event, size: 65,),
                      trailing: Icon(Icons.sort),
                      title: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          this.events![index].name!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:Text(
                          "in " + this.events![index].endDate!.difference(DateTime.now()).inDays.toString() + " days",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      onTap: (){goToDetail(this.events![index]);},
                    )
                )
            )
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Event item = this.events!.removeAt(oldIndex);
            this.events!.insert(newIndex, item);
          });
        },
      ),
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

  void goToDetail(Event event) async {
    bool? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetail(event)));
    if (result != null) {
      if (result) {
        getEvents();
      }
    }
  }
}