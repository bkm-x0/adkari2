import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_model.dart';

class QuranService {
  static QuranService? _instance;
  List<QuranAyah>? _allAyahs;
  List<Surah>? _surahs;

  QuranService._();

  factory QuranService() {
    _instance ??= QuranService._();
    return _instance!;
  }

  Future<List<QuranAyah>> loadAllAyahs() async {
    if (_allAyahs != null) {
      return _allAyahs!;
    }

    try {
      final String jsonString = 
          await rootBundle.loadString('assets/data/quran.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      
      _allAyahs = jsonData
          .map((ayah) => QuranAyah.fromJson(ayah))
          .toList();
      
      return _allAyahs!;
    } catch (e) {
      print('Error loading Quran: $e');
      return [];
    }
  }

  Future<List<Surah>> loadQuran() async {
    if (_surahs != null) {
      return _surahs!;
    }

    final allAyahs = await loadAllAyahs();
    
    // Group ayahs by surah number
    Map<int, List<QuranAyah>> surahMap = {};
    
    for (var ayah in allAyahs) {
      if (!surahMap.containsKey(ayah.suraNo)) {
        surahMap[ayah.suraNo] = [];
      }
      surahMap[ayah.suraNo]!.add(ayah);
    }

    // Create Surah objects
    _surahs = surahMap.entries.map((entry) {
      final ayahs = entry.value;
      return Surah(
        suraNo: entry.key,
        suraNameEn: ayahs.first.suraNameEn,
        suraNameAr: ayahs.first.suraNameAr,
        ayahs: ayahs,
      );
    }).toList();

    // Sort by surah number
    _surahs!.sort((a, b) => a.suraNo.compareTo(b.suraNo));

    return _surahs!;
  }

  List<Surah> get surahs => _surahs ?? [];

  Surah? getSurahByNumber(int number) {
    return _surahs?.firstWhere(
      (surah) => surah.suraNo == number,
      orElse: () => _surahs!.first,
    );
  }

  List<Surah> searchSurahs(String query) {
    if (_surahs == null) return [];
    
    final lowerQuery = query.toLowerCase();
    return _surahs!.where((surah) {
      return surah.suraNameAr.contains(query) ||
          surah.suraNameEn.toLowerCase().contains(lowerQuery) ||
          surah.suraNo.toString().contains(query);
    }).toList();
  }

  // Get ayahs by page
  List<QuranAyah> getAyahsByPage(int page) {
    if (_allAyahs == null) return [];
    return _allAyahs!.where((ayah) => ayah.page == page).toList();
  }

  // Get ayahs by jozz
  List<QuranAyah> getAyahsByJozz(int jozz) {
    if (_allAyahs == null) return [];
    return _allAyahs!.where((ayah) => ayah.jozz == jozz).toList();
  }

  // Get total number of pages
  int get totalPages {
    if (_allAyahs == null || _allAyahs!.isEmpty) return 0;
    return _allAyahs!.map((a) => a.page).reduce((a, b) => a > b ? a : b);
  }

  // Get total number of jozz
  int get totalJozz {
    if (_allAyahs == null || _allAyahs!.isEmpty) return 0;
    return _allAyahs!.map((a) => a.jozz).reduce((a, b) => a > b ? a : b);
  }
}