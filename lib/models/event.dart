class Event{
  int? id;
  String? name;
  String? description;
  DateTime? endDate;

  Event({this.name, this.description, this.endDate});
  Event.withId({this.id, this.name, this.description, this.endDate});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["endDate"] = endDate.toString();
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Event.fromObject(dynamic o) {
    this.id = o["id"];
    this.name = o["name"];
    this.description = o["description"];
    this.endDate = DateTime.tryParse(o["endDate"]);
  }
}