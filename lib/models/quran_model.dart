class QuranAyah {
  final int id;
  final int jozz;
  final int suraNo;
  final String suraNameEn;
  final String suraNameAr;
  final int page;
  final int lineStart;
  final int lineEnd;
  final int ayaNo;
  final String ayaText;
  final String ayaTextEmlaey;

  QuranAyah({
    required this.id,
    required this.jozz,
    required this.suraNo,
    required this.suraNameEn,
    required this.suraNameAr,
    required this.page,
    required this.lineStart,
    required this.lineEnd,
    required this.ayaNo,
    required this.ayaText,
    required this.ayaTextEmlaey,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      id: json['id'] as int,
      jozz: json['jozz'] as int,
      suraNo: json['sura_no'] as int,
      suraNameEn: json['sura_name_en'] as String,
      suraNameAr: json['sura_name_ar'] as String,
      page: json['page'] as int,
      lineStart: json['line_start'] as int,
      lineEnd: json['line_end'] as int,
      ayaNo: json['aya_no'] as int,
      ayaText: json['aya_text'] as String,
      ayaTextEmlaey: json['aya_text_emlaey'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jozz': jozz,
      'sura_no': suraNo,
      'sura_name_en': suraNameEn,
      'sura_name_ar': suraNameAr,
      'page': page,
      'line_start': lineStart,
      'line_end': lineEnd,
      'aya_no': ayaNo,
      'aya_text': ayaText,
      'aya_text_emlaey': ayaTextEmlaey,
    };
  }
}

class Surah {
  final int suraNo;
  final String suraNameEn;
  final String suraNameAr;
  final List<QuranAyah> ayahs;

  Surah({
    required this.suraNo,
    required this.suraNameEn,
    required this.suraNameAr,
    required this.ayahs,
  });

  int get numberOfAyahs => ayahs.length;
  
  int get firstPage => ayahs.isNotEmpty ? ayahs.first.page : 0;
  
  int get jozz => ayahs.isNotEmpty ? ayahs.first.jozz : 0;

  // Get revelation type based on Surah number (common knowledge)
  String get revelation {
    const meccanSurahs = [
      1, 6, 7, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 28, 29,
      30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 50, 51, 52,
      53, 54, 55, 56, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
      82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 99, 100,
      101, 102, 103, 104, 105, 106, 107, 109, 111, 112, 113, 114
    ];
    return meccanSurahs.contains(suraNo) ? 'Meccan' : 'Medinan';
  }
}