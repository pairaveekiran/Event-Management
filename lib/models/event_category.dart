class EventCategory {
  final int
      id;
  final String
      title;

  const EventCategory({
    required this.id,
    required this.title,
  });

  factory EventCategory.fromJson(
      Map json) {
    final dynamic
        rawId =
        json['id'];
    final dynamic
        rawTitle =
        json['title'];

    return EventCategory(
      id: rawId is int ? rawId : int.parse(rawId.toString()),
      title: rawTitle?.toString() ?? '',
    );
  }

  Map<String, dynamic>
      toJson() {
    return <String,
        dynamic>{
      'id': id,
      'title': title,
    };
  }
}
