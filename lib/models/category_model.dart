class Category {
  final int? id;
  final String name;
  final String icon;
  final String color;
  final DateTime createdDate;
  final String? translationKey;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.createdDate,
    this.translationKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'createdDate': createdDate.toIso8601String(),
      'translationKey': translationKey,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as String,
      createdDate: DateTime.parse(map['createdDate'] as String),
      translationKey: map['translationKey'] as String?,
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
    DateTime? createdDate,
    String? translationKey,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdDate: createdDate ?? this.createdDate,
      translationKey: translationKey ?? this.translationKey,
    );
  }
}