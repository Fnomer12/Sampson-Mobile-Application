class Note {
  final String id;
  String title;
  String content;
  bool isPinned;
  DateTime lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'lastEdited': lastEdited.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        isPinned: json['isPinned'] ?? false,
        lastEdited: DateTime.parse(json['lastEdited']),
      );
}