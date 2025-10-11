import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class ApiService {
  static ApiService? _instance;
  static const String baseUrl = 'https://hisnmuslim.com/api';
  
  // Cache
  List<Language>? _languages;
  Map<String, List<AthkarCategory>> _categoriesByLanguage = {};
  Map<int, List<AthkarItem>> _itemsByCategory = {};

  ApiService._();

  factory ApiService() {
    _instance ??= ApiService._();
    return _instance!;
  }

  // Step 1: Fetch available languages
  Future<List<Language>> fetchLanguages() async {
    if (_languages != null) return _languages!;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/husn.json'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> mainList = data['MAIN'];
        
        _languages = mainList
            .map((lang) => Language.fromJson(lang))
            .toList();
        
        return _languages!;
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      print('Error fetching languages: $e');
      return [];
    }
  }

  // Step 2: Fetch categories for a specific language
  Future<List<AthkarCategory>> fetchCategories(String languageUrl) async {
    // Check cache
    if (_categoriesByLanguage.containsKey(languageUrl)) {
      return _categoriesByLanguage[languageUrl]!;
    }

    try {
      final response = await http.get(Uri.parse(languageUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Get the first key (language name like "العربية" or "English")
        final String languageKey = data.keys.first;
        final List<dynamic> categoryList = data[languageKey];
        
        final categories = categoryList
            .map((cat) => AthkarCategory.fromJson(cat))
            .toList();
        
        _categoriesByLanguage[languageUrl] = categories;
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Step 3: Fetch athkar items for a specific category
  Future<List<AthkarItem>> fetchAthkarItems(int categoryId, String textUrl) async {
    // Check cache
    if (_itemsByCategory.containsKey(categoryId)) {
      return _itemsByCategory[categoryId]!;
    }

    try {
      final response = await http.get(Uri.parse(textUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // The response has a key like "أذكار الصباح والمساء"
        final String categoryKey = data.keys.first;
        final List<dynamic> itemsList = data[categoryKey];
        
        final items = itemsList
            .map((item) => AthkarItem.fromJson(item))
            .toList();
        
        _itemsByCategory[categoryId] = items;
        return items;
      } else {
        throw Exception('Failed to load athkar items');
      }
    } catch (e) {
      print('Error fetching athkar items: $e');
      return [];
    }
  }

  // Helper: Load category with its items
  Future<AthkarCategory> loadCategoryWithItems(AthkarCategory category) async {
    if (category.items == null) {
      category.items = await fetchAthkarItems(category.id, category.textUrl);
    }
    return category;
  }

  // Get Arabic categories (most common use case)
  Future<List<AthkarCategory>> getArabicCategories() async {
    final languages = await fetchLanguages();
    final arabicLang = languages.firstWhere(
      (lang) => lang.language == 'العربية',
      orElse: () => languages.first,
    );
    return fetchCategories(arabicLang.languageUrl);
  }

  // Get English categories
  Future<List<AthkarCategory>> getEnglishCategories() async {
    final languages = await fetchLanguages();
    final englishLang = languages.firstWhere(
      (lang) => lang.language == 'English',
      orElse: () => languages.first,
    );
    return fetchCategories(englishLang.languageUrl);
  }

  // Clear cache
  void clearCache() {
    _languages = null;
    _categoriesByLanguage.clear();
    _itemsByCategory.clear();
  }
}