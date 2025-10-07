class Note {
  final String title;
  final String body;
  final String createdAt;
  final String updatedAt;

  Note({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  List<dynamic> toList() {
    return [title, body, createdAt, updatedAt];
  }

  factory Note.fromList(List<dynamic> list) {
    return Note(
      title: list[0] as String,
      body: list[1] as String,
      createdAt: list[2] as String,
      updatedAt: list[3] as String,
    );
  }
}
