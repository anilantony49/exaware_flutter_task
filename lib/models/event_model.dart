class EventModel {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
