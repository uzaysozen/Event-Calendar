import 'dart:async';

import 'package:countdown_app/models/event.dart';
import 'package:countdown_app/data/dbHelper.dart';
import 'package:flutter/material.dart';

import '../util/tools.dart';
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
  int? eventCount;
  Timer? timer;
  Duration duration = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    getEvents();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
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
              icon: Icon(Icons.search)),
        ],
      ),
      body: getHomePageBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          goToEventAdd();
        },
        child: Icon(Icons.add),
        tooltip: "Add new event",
      ),
    );
  }

  Widget getHomePageBody() {
    if (eventCount == null) {
      return Center(child: CircularProgressIndicator(),);
    }
    else if (eventCount == 0) {
      return buildPlaceholder();
    }
    else {
      return buildEventList();
    }
  }

  Widget buildPlaceholder() {
    return Center(child: RichText(text: TextSpan(
      children: [
        TextSpan(
            text: "Tap to ",
            style: TextStyle(fontSize: 18, color: Colors.blueGrey)
        ),
        WidgetSpan(
          child: Icon(Icons.add, size: 22, color: Colors.black,),
        ),
        TextSpan(
            text: " icon to create a new event",
            style: TextStyle(fontSize: 18, color: Colors.blueGrey)
        ),
      ],
    ),
    )
    );
  }

  Container buildEventList() {
    return Container(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: <Widget>[
          for (int index = 0; index < eventCount!; index += 1)
            buildCard(context, index, events!, goToDetail)
        ],
      ),
    );
  }

  void goToEventAdd() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventAdd()));
    if (result != null) {
      if (result) {
        getEvents();
      }
    }
  }

  void getEvents() async {
    var eventsFuture = dbHelper.getEvents();
    eventsFuture.then((data) {
      setState(() {
        this.events = data!.reversed.toList();
        eventCount = data.length;
      });
    });
  }

  void goToDetail(BuildContext context, Event event) async {
    bool? result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventDetail(event)));
    if (result != null) {
      if (result) {
        getEvents();
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => changeTime());
  }

  void stopTimer() {
    timer?.cancel();
  }

  changeTime() {
    final changeSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds - changeSeconds;
      duration = Duration(seconds: seconds);
    });
  }
}

buildCard(BuildContext context, int index, List<Event> events, Function goToEvent) {
  return Card(
      color: events[index].endDate!.compareTo(DateTime.now()) <= 0
          ? Colors.red
          : Colors.tealAccent,
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      key: ValueKey(events[index].id),
      child: SizedBox(
          width: 300,
          height: 100,
          child: ListTile(
            leading: Icon(
              Tools.getIconData(events[index].type!),
              size: 80,
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 10, right: 50),
              child: Text(
                events[index].name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10, right: 50),
              child: Text(
                getTimeText(events[index]
                    .endDate!
                    .difference(DateTime.now())),
                style: TextStyle(fontSize: 14),
              ),
            ),
            onTap: () async {
              goToEvent(context, events[index]);
            },
          )
      )
  );
}

String getTimeText(Duration duration) {
  var result = '';
  if (duration.inSeconds <= 0) {
    return 'The event is over!';
  } else {
    if (duration.inDays != 0) {
      if (duration.inDays == 1) {
        result += '${duration.inDays} day ';
      } else {
        result += '${duration.inDays} days ';
      }
    }
    if (duration.inHours.remainder(24) != 0) {
      if (duration.inHours.remainder(24) == 1) {
        result += '${duration.inHours.remainder(24)} hour ';
      } else {
        result += '${duration.inHours.remainder(24)} hours ';
      }
    }
    if (duration.inMinutes.remainder(60) != 0) {
      if (duration.inMinutes.remainder(60) == 1) {
        result += '${duration.inMinutes.remainder(60)} minute ';
      } else {
        result += '${duration.inMinutes.remainder(60)} minutes ';
      }
    }
    if (duration.inSeconds.remainder(60) == 1) {
      result += '${duration.inSeconds.remainder(60)} second';
    } else {
      result += '${duration.inSeconds.remainder(60)} seconds';
    }
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
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, true);
        },
        icon: Icon(Icons.arrow_back));
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
          buildCard(context, index, matchQuery, goToEvent)
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
          buildCard(context, index, events!, goToEvent)
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
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventDetail(event)));
    if (result) {
      getEvents(context);
    }
  }
}
