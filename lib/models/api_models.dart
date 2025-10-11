// Language Model
class Language {
  final int id;
  final String language;
  final String languageUrl;

  Language({
    required this.id,
    required this.language,
    required this.languageUrl,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['ID'] as int,
      language: json['LANGUAGE'] as String,
      languageUrl: json['LANGUAGE_URL'] as String,
    );
  }
}

// Category Model (Abwab)
class AthkarCategory {
  final int id;
  final String title;
  final String audioUrl;
  final String textUrl;
  List<AthkarItem>? items; // Will be loaded separately

  AthkarCategory({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.textUrl,
    this.items,
  });

  factory AthkarCategory.fromJson(Map<String, dynamic> json) {
    return AthkarCategory(
      id: json['ID'] as int,
      title: json['TITLE'] as String,
      audioUrl: json['AUDIO_URL'] as String,
      textUrl: json['TEXT'] as String,
    );
  }
}

// Athkar Item Model
class AthkarItem {
  final int id;
  final String arabicText;
  final String? languageArabicTranslatedText;
  final String? translatedText;
  final int repeat;
  final String? audio;
  int currentCount;

  AthkarItem({
    required this.id,
    required this.arabicText,
    this.languageArabicTranslatedText,
    this.translatedText,
    required this.repeat,
    this.audio,
  }) : currentCount = repeat;

  factory AthkarItem.fromJson(Map<String, dynamic> json) {
    return AthkarItem(
      id: json['ID'] as int,
      arabicText: json['ARABIC_TEXT'] as String,
      languageArabicTranslatedText: json['LANGUAGE_ARABIC_TRANSLATED_TEXT'] as String?,
      translatedText: json['TRANSLATED_TEXT'] as String?,
      repeat: json['REPEAT'] as int? ?? 1,
      audio: json['AUDIO'] as String?,
    );
  }

  void decrementCount() {
    if (currentCount > 0) {
      currentCount--;
    }
  }

  void resetCount() {
    currentCount = repeat;
  }

  bool get isCompleted => currentCount == 0;
  
  // For display
  String get displayText => arabicText;
  int get totalCount => repeat;
}