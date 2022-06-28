class Event{
  int? id;
  String? name;
  String? description;
  DateTime? endDate;

  Event({this.name, this.description, this.endDate});
  Event.withId({this.id, this.name, this.description, this.endDate});
}