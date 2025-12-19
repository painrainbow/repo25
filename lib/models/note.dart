class Note {
  final String id;
  String title;
  List<String> paragraphs;

  Note({required this.id, required this.title, required this.paragraphs});

  Note copyWith({String? title, List<String>? paragraphs}) => Note(
    id: id,
    title: title ?? this.title,
    paragraphs: paragraphs ?? this.paragraphs,
  );
}
