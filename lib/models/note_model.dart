class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdDate;
  final int? categoryId;
  final bool isFavorite;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    this.categoryId,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'categoryId': categoryId,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdDate: DateTime.parse(map['createdDate'] as String),
      categoryId: map['categoryId'] as int?,
      isFavorite: (map['isFavorite'] as int?) == 1,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdDate,
    int? categoryId,
    bool? isFavorite,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      categoryId: categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}