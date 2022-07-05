import 'dart:async';

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
  Timer? timer;
  Duration duration = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    getEvents();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Your Events"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                );
                if (result) {
                  getEvents();
                }
              },
              icon: Icon(Icons.search)
          ),
        ],
      ),
      body: buildEventList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: (){goToEventAdd();},
        child: Icon(Icons.add),
        tooltip: "Add new event",
      ),
    );
  }

  Container buildEventList() {
    return Container(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: <Widget>[
          for (int index = 0; index < eventCount; index += 1)
              Card(
                color: Colors.tealAccent,
                elevation: 2.0,
                key: ValueKey(events![index].id),
                child: SizedBox(
                    width: 300,
                    height: 90,
                    child: ListTile(
                      leading: Icon(Icons.event, size: 60,),
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
                          getTimeText(this.events![index].
                            endDate!.difference(DateTime.now()))
                          ,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      onTap: (){goToDetail(this.events![index]);},
                    )
                )
            )
        ],
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

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => changeTime());
  }

  changeTime() {
    final changeSeconds = 1;
    setState((){
      final seconds = duration.inSeconds - changeSeconds;
      duration = Duration(seconds: seconds);
    });
  }


}

String getTimeText(Duration duration) {
  var result = '';
  if (duration.inSeconds.remainder(60) < 0 ) {
    return 'The event is over!';
  }
  else {
    if (duration.inDays != 0) {
      result += '${duration.inDays} days ';
    }
    if (duration.inHours.remainder(24) != 0) {
      result += '${duration.inHours.remainder(24)} hours ';
    }
    if (duration.inMinutes.remainder(60) != 0) {
      result += '${duration.inMinutes.remainder(60)} minutes ';
    }
    result += '${duration.inSeconds.remainder(60)} seconds';
    return result;
  }
}



class CustomSearchDelegate extends SearchDelegate {
  var dbHelper = DbHelper();
  List<Event>? events = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, true);
        },
        icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Event> matchQuery = [];
    for (var event in events!) {
      if (event.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(event);
      }
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: <Widget>[
        for (int index = 0; index < matchQuery.length; index += 1)
          Card(
              color: Colors.tealAccent,
              elevation: 2.0,
              key: ValueKey(matchQuery[index].id),
              child: SizedBox(
                  width: 300,
                  height: 90,
                  child: ListTile(
                    leading: Icon(Icons.event, size: 60,),
                    title: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        matchQuery[index].name!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child:Text(
                          getTimeText(matchQuery[index].
                        endDate!.difference(DateTime.now()))
                        ,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    onTap: () async {
                      await goToEvent(context, matchQuery[index]);
                      },
                  )
              )
          )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getEvents(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: <Widget>[
        for (int index = 0; index < events!.length; index += 1)
          Card(
              color: Colors.tealAccent,
              elevation: 2.0,
              key: ValueKey(events![index].id),
              child: SizedBox(
                  width: 300,
                  height: 90,
                  child: ListTile(
                    leading: Icon(Icons.event, size: 60,),
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
                        getTimeText(this.events![index].
                        endDate!.difference(DateTime.now()))
                        ,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    onTap: () async {
                      await goToEvent(context, this.events![index]);
                      },
                  )
              )
          )
      ],
    );
  }

  getEvents(BuildContext context) {
    var eventsFuture = dbHelper.getEvents();
    eventsFuture.then((data) {
      events = data;
    });
  }

  Future<void> goToEvent(BuildContext context, Event event) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetail(event)));
    if (result) {
      getEvents(context);
    }
  }
  
}