class Event {
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? endTime;

  Event({
    required this.title,
    this.description = '',
    this.startTime,
    this.endTime,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event &&
        other.title == title &&
        other.description == description &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        startTime.hashCode ^
        endTime.hashCode;
  }
}
