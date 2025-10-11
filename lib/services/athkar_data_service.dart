import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/athkar_model.dart';

class AthkarDataService {
  static AthkarDataService? _instance;
  List<AthkarCategory>? _categories;

  AthkarDataService._();

  factory AthkarDataService() {
    _instance ??= AthkarDataService._();
    return _instance!;
  }

  Future<List<AthkarCategory>> loadAthkar() async {
    if (_categories != null) {
      return _categories!;
    }

    try {
      final String jsonString = 
          await rootBundle.loadString('assets/data/adhkar.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _categories = jsonList
          .map((json) => AthkarCategory.fromJson(json))
          .toList();
      
      return _categories!;
    } catch (e) {
      print('Error loading athkar: $e');
      return [];
    }
  }

  List<AthkarCategory> get categories => _categories ?? [];

  AthkarCategory? getCategoryById(int id) {
    return _categories?.firstWhere(
      (category) => category.id == id,
      orElse: () => _categories!.first,
    );
  }

  List<String> get allCategories {
    return _categories?.map((c) => c.category).toList() ?? [];
  }
}