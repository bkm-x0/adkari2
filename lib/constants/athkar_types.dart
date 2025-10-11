enum AthkarType {
  morningEvening('أذكار الصباح والمساء'),
  afterPrayer('أذكار بعد الصلاة'),
  sleep('أذكار النوم'),
  wakeUp('أذكار الاستيقاظ'),
  other('أخرى');

  final String label;
  const AthkarType(this.label);

  static AthkarType fromCategory(String category) {
    switch (category.trim()) {
      case 'أذكار الصباح والمساء':
        return AthkarType.morningEvening;
      case 'أذكار بعد الصلاة':
        return AthkarType.afterPrayer;
      case 'أذكار النوم':
        return AthkarType.sleep;
      case 'أذكار الاستيقاظ':
      case 'أذكار الاستيقاظ من النوم':
        return AthkarType.wakeUp;
      default:
        return AthkarType.other;
    }
  }
}