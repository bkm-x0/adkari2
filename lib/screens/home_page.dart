import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import '../constants/app_colors.dart';
import 'athkar_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<AthkarCategory> _categories = [];
  bool _isLoading = true;
  String _selectedLanguage = 'العربية';
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = _selectedLanguage == 'العربية'
          ? await _apiService.getArabicCategories()
          : await _apiService.getEnglishCategories();
      
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
        _headerController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('فشل تحميل البيانات. تحقق من اتصال الإنترنت.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Amiri')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _selectedLanguage = _selectedLanguage == 'العربية' ? 'English' : 'العربية';
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'جاري التحميل...',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_categories.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            _buildCategoryList(),
          // Bottom padding to avoid floating nav overlap
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _headerAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                children: [
                  // Top action row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircleButton(
                        icon: Icons.language_rounded,
                        onTap: _toggleLanguage,
                        tooltip: _selectedLanguage == 'العربية' ? 'English' : 'العربية',
                      ),
                      _buildCircleButton(
                        icon: Icons.refresh_rounded,
                        onTap: () {
                          _apiService.clearCache();
                          _loadData();
                        },
                        tooltip: 'تحديث',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'حصن المسلم',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _selectedLanguage == 'العربية' ? 'الأذكار والأدعية' : 'Athkar & Supplications',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _selectedLanguage,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'لا توجد أذكار',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Amiri')),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _AnimatedCategoryCard(
              category: _categories[index],
              index: index,
              onTap: () => _navigateToCategoryDetail(_categories[index]),
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Future<void> _navigateToCategoryDetail(AthkarCategory category) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'جاري تحميل الأذكار...',
                style: TextStyle(fontFamily: 'Amiri', fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final categoryWithItems = await _apiService.loadCategoryWithItems(category);
      if (mounted) Navigator.pop(context);

      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AthkarDetailPage(category: categoryWithItems),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.15, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showError('فشل تحميل الأذكار');
      }
    }
  }
}

// === Animated Category Card ===

class _AnimatedCategoryCard extends StatefulWidget {
  final AthkarCategory category;
  final int index;
  final VoidCallback onTap;

  const _AnimatedCategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 40)),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _opacity,
        child: _CategoryCard(
          category: widget.category,
          index: widget.index,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  IconData _getCategoryIcon() {
    final title = category.title.toLowerCase();
    if (title.contains('صباح') || title.contains('morning')) return Icons.wb_sunny_rounded;
    if (title.contains('مساء') || title.contains('evening')) return Icons.nightlight_round;
    if (title.contains('نوم') || title.contains('sleep')) return Icons.bedtime_rounded;
    if (title.contains('استيقاظ') || title.contains('waking')) return Icons.light_mode_rounded;
    if (title.contains('صلاة') || title.contains('مسجد') || title.contains('prayer') || title.contains('mosque')) return Icons.mosque_rounded;
    if (title.contains('سفر') || title.contains('travel')) return Icons.flight_rounded;
    if (title.contains('طعام') || title.contains('food')) return Icons.restaurant_rounded;
    if (title.contains('وضوء') || title.contains('ablution')) return Icons.water_drop_rounded;
    return Icons.auto_stories_rounded;
  }

  static const _iconColors = [
    Color(0xFF1A6B5A),
    Color(0xFFC9A84C),
    Color(0xFF2E8B76),
    Color(0xFFA68A30),
    Color(0xFF43A088),
    Color(0xFF5BB8D4),
  ];

  Color _getColor() => _iconColors[index % _iconColors.length];

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: color.withOpacity(0.08),
          highlightColor: color.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textLight,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}