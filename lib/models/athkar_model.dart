class AthkarCategory {
  final int id;
  final String category;
  final String? audio;
  final String? filename;
  final List<AthkarItem> array;

  AthkarCategory({
    required this.id,
    required this.category,
    this.audio,
    this.filename,
    required this.array,
  });

  factory AthkarCategory.fromJson(Map<String, dynamic> json) {
    return AthkarCategory(
      id: json['id'] as int,
      category: json['category'] as String,
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
      array: (json['array'] as List)
          .map((item) => AthkarItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'audio': audio,
      'filename': filename,
      'array': array.map((item) => item.toJson()).toList(),
    };
  }
}

class AthkarItem {
  final int id;
  final String text;
  final int count;
  final String? audio;
  final String? filename;
  int currentCount;

  AthkarItem({
    required this.id,
    required this.text,
    required this.count,
    this.audio,
    this.filename,
  }) : currentCount = count;

  factory AthkarItem.fromJson(Map<String, dynamic> json) {
    return AthkarItem(
      id: json['id'] as int,
      text: json['text'] as String,
      count: json['count'] as int,
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'count': count,
      'audio': audio,
      'filename': filename,
    };
  }

  void decrementCount() {
    if (currentCount > 0) {
      currentCount--;
    }
  }

  void resetCount() {
    currentCount = count;
  }

  bool get isCompleted => currentCount == 0;
}