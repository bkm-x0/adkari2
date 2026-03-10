import 'package:flutter/material.dart';
import 'package:dorar_hadith/dorar_hadith.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/hadith_service.dart';

class HadithSearchPage extends StatefulWidget {
  const HadithSearchPage({Key? key}) : super(key: key);

  @override
  State<HadithSearchPage> createState() => _HadithSearchPageState();
}

class _HadithSearchPageState extends State<HadithSearchPage>
    with TickerProviderStateMixin {
  final HadithService _hadithService = HadithService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Hadith> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int _currentPage = 1;
  bool _hasNextPage = false;
  String _lastQuery = '';

  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  // Filter state
  HadithDegree? _selectedDegree;
  SearchMethod _searchMethod = SearchMethod.anyWord;

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
    _headerController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _search({bool loadMore = false}) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    if (!loadMore) {
      _currentPage = 1;
      _lastQuery = query;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _hadithService.searchHadith(
        query,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          if (loadMore) {
            _results.addAll(response.data);
          } else {
            _results = response.data;
          }
          _hasSearched = true;
          _isLoading = false;
          _hasNextPage = response.metadata.hasNextPage ?? false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasSearched = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء البحث',
              style: const TextStyle(fontFamily: 'Amiri'),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _loadMore() {
    if (!_isLoading && _hasNextPage) {
      _currentPage++;
      _search(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          if (_isLoading && !_hasSearched)
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
                      'جاري البحث...',
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
          else if (_hasSearched && _results.isEmpty && !_isLoading)
            SliverFillRemaining(child: _buildEmptyState())
          else if (!_hasSearched)
            SliverFillRemaining(child: _buildInitialState())
          else
            _buildResultsList(),
          if (_isLoading && _hasSearched)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          if (_hasNextPage && !_isLoading)
            SliverToBoxAdapter(child: _buildLoadMoreButton()),
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
                  const SizedBox(height: 8),
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
                      Icons.library_books_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'البحث في الأحاديث',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'موسوعة الدرر السنية',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 17),
              decoration: InputDecoration(
                hintText: 'ابحث عن حديث...',
                hintStyle: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search_rounded, color: AppColors.primary),
                  onPressed: _search,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: AppColors.textLight, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results.clear();
                            _hasSearched = false;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: [
          _buildFilterChip(
            label: 'الكل',
            selected: _selectedDegree == null,
            onTap: () => setState(() => _selectedDegree = null),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'صحيح',
            selected: _selectedDegree == HadithDegree.authenticHadith,
            onTap: () => setState(
                () => _selectedDegree = HadithDegree.authenticHadith),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'صحيح السند',
            selected: _selectedDegree == HadithDegree.authenticChain,
            onTap: () =>
                setState(() => _selectedDegree = HadithDegree.authenticChain),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'ضعيف',
            selected: _selectedDegree == HadithDegree.weakHadith,
            onTap: () =>
                setState(() => _selectedDegree = HadithDegree.weakHadith),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.textLight.withOpacity(0.3),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 72,
            color: AppColors.textLight.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'ابحث في أحاديث النبي ﷺ',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اكتب كلمة أو جملة للبحث',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textLight.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'حاول البحث بكلمات مختلفة',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hadith = _results[index];
          return _buildHadithCard(hadith, index);
        },
        childCount: _results.length,
      ),
    );
  }

  Widget _buildHadithCard(Hadith hadith, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GestureDetector(
        onTap: () => _showHadithDetail(hadith),
        child: Container(
          decoration: AppStyles.cardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header row: number + grade badge
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _gradeColor(hadith.hukm).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hadith.hukm,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _gradeColor(hadith.hukm),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Hadith text
                Text(
                  hadith.hadith,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 17,
                    height: 2.0,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                // Divider
                Container(
                  height: 1,
                  color: AppColors.surface,
                ),
                const SizedBox(height: 10),
                // Footer: rawi + book
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              hadith.rawi,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              hadith.mohdith,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHadithDetail(Hadith hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Grade badge
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              _gradeColor(hadith.hukm).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hadith.hukm,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _gradeColor(hadith.hukm),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Hadith text
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.15)),
                      ),
                      child: Text(
                        hadith.hadith,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 20,
                          height: 2.2,
                          color: AppColors.textPrimary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Info cards
                    _buildInfoRow(
                      icon: Icons.person_rounded,
                      label: 'الراوي',
                      value: hadith.rawi,
                    ),
                    _buildInfoRow(
                      icon: Icons.school_rounded,
                      label: 'المحدث',
                      value: hadith.mohdith,
                    ),
                    _buildInfoRow(
                      icon: Icons.menu_book_rounded,
                      label: 'الكتاب',
                      value: hadith.book,
                    ),
                    _buildInfoRow(
                      icon: Icons.numbers_rounded,
                      label: 'الصفحة / الرقم',
                      value: hadith.numberOrPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextButton(
        onPressed: _loadMore,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.primary.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text(
          'تحميل المزيد',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Color _gradeColor(String grade) {
    if (grade.contains('صحيح')) return AppColors.success;
    if (grade.contains('حسن')) return AppColors.accent;
    if (grade.contains('ضعيف')) return AppColors.error;
    return AppColors.textSecondary;
  }
}
