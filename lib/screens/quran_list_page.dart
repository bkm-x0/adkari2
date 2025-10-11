import 'package:flutter/material.dart';
import '../models/quran_model.dart';
import '../services/quran_service.dart';
import '../constants/app_colors.dart';
import 'surah_detail_page.dart';

class QuranListPage extends StatefulWidget {
  const QuranListPage({Key? key}) : super(key: key);

  @override
  State<QuranListPage> createState() => _QuranListPageState();
}

class _QuranListPageState extends State<QuranListPage> with TickerProviderStateMixin {
  final QuranService _quranService = QuranService();
  List<Surah> _surahs = [];
  List<Surah> _filteredSurahs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final surahs = await _quranService.loadQuran();
      if (mounted) {
        setState(() {
          _surahs = surahs;
          _filteredSurahs = surahs;
          _isLoading = false;
        });
        _headerController.forward();
      }
    } catch (e) {
      print('Error loading Quran: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _surahs;
      } else {
        _filteredSurahs = _quranService.searchSurahs(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      )
                    : _buildSurahsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(_headerAnimation),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'القرآن الكريم',
                style: TextStyle(
                  fontFamily: 'Uthmanic',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_surahs.length} سورة',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterSurahs,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ابحث عن سورة...',
            hintStyle: TextStyle(
              fontFamily: 'Amiri',
              color: AppColors.textLight,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      _filterSurahs('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSurahsList() {
    if (_filteredSurahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'لم يتم العثور على نتائج',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        return _AnimatedSurahCard(
          surah: _filteredSurahs[index],
          index: index,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SurahDetailPage(surah: _filteredSurahs[index]),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      ),
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AnimatedSurahCard extends StatefulWidget {
  final Surah surah;
  final int index;
  final VoidCallback onTap;

  const _AnimatedSurahCard({
    required this.surah,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AnimatedSurahCard> createState() => _AnimatedSurahCardState();
}

class _AnimatedSurahCardState extends State<_AnimatedSurahCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: _SurahCard(
          surah: widget.surah,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMeccan = surah.revelation.toLowerCase().contains('mec');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Number Badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${surah.suraNo}',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Surah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.suraNameAr,
                        style: const TextStyle(
                          fontFamily: 'Uthmanic',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah.suraNameEn,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isMeccan
                                  ? AppColors.accent.withOpacity(0.2)
                                  : AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isMeccan ? Icons.location_city : Icons.mosque,
                                  size: 12,
                                  color: isMeccan ? AppColors.accentDark : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isMeccan ? 'مكية' : 'مدنية',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 11,
                                    color: isMeccan ? AppColors.accentDark : AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.format_list_numbered,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${surah.numberOfAyahs} آية',
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textLight,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}