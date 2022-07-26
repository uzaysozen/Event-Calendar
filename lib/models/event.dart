class Event{
  int? id;
  String? type;
  String? name;
  String? description;
  DateTime? endDate;

  Event({this.type, this.name, this.description, this.endDate});
  Event.withId({this.id, this.type, this.name, this.description, this.endDate});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["type"] = type;
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
    this.type = o["type"];
    this.name = o["name"];
    this.description = o["description"];
    this.endDate = DateTime.tryParse(o["endDate"]);
  }
}