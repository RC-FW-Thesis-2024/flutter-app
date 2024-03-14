class Workout {
  final String id;
  final String title;
  final String date;
  final String duration;
  final String latitude;
  final String longitude;

  Workout({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.latitude,
    required this.longitude,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      title: json['title'],
      date: json['date'],
      duration: json['duration'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}