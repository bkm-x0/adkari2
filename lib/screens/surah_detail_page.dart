import 'package:flutter/material.dart';
import '../models/quran_model.dart';
import '../constants/app_colors.dart';

class SurahDetailPage extends StatefulWidget {
  final Surah surah;

  const SurahDetailPage({
    Key? key,
    required this.surah,
  }) : super(key: key);

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  double _fontSize = 26.0;
  bool _showUthmanic = true;

  void _increaseFontSize() {
    setState(() {
      if (_fontSize < 36) _fontSize += 2;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 16) _fontSize -= 2;
    });
  }

  void _toggleFont() {
    setState(() {
      _showUthmanic = !_showUthmanic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quranBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildSurahHeader(),
          ),
          _buildAyahsList(),
        ],
      ),
      floatingActionButton: _buildControls(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.primaryBlue],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.surah.suraNo}',
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.surah.suraNameAr,
                  style: const TextStyle(
                    fontFamily: 'Uthmanic',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.surah.suraNameEn,
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
      ),
    );
  }

  Widget _buildSurahHeader() {
    final isMeccan = widget.surah.revelation.toLowerCase().contains('mec');
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                Icons.format_list_numbered,
                '${widget.surah.numberOfAyahs} آية',
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.textLight,
              ),
              _buildInfoItem(
                isMeccan ? Icons.location_city : Icons.mosque,
                isMeccan ? 'مكية' : 'مدنية',
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.textLight,
              ),
              _buildInfoItem(
                Icons.book,
                'جزء ${widget.surah.jozz}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'صفحة ${widget.surah.firstPage}',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAyahsList() {
    if (widget.surah.ayahs.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'لا توجد آيات متاحة',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ayah = widget.surah.ayahs[index];
          return _AyahCard(
            ayah: ayah,
            fontSize: _fontSize,
            showUthmanic: _showUthmanic,
            index: index,
          );
        },
        childCount: widget.surah.ayahs.length,
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'font_toggle',
            onPressed: _toggleFont,
            mini: true,
            backgroundColor: AppColors.primary,
            child: Icon(
              _showUthmanic ? Icons.text_fields : Icons.font_download,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'decrease_font',
            onPressed: _decreaseFontSize,
            mini: true,
            backgroundColor: AppColors.accent,
            child: const Icon(
              Icons.text_decrease,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'increase_font',
            onPressed: _increaseFontSize,
            mini: true,
            backgroundColor: AppColors.accent,
            child: const Icon(
              Icons.text_increase,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  final QuranAyah ayah;
  final double fontSize;
  final bool showUthmanic;
  final int index;

  const _AyahCard({
    Key? key,
    required this.ayah,
    required this.fontSize,
    required this.showUthmanic,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use ayaTextEmlaey for both since ayaText contains special characters
    final displayText = ayah.ayaTextEmlaey.isNotEmpty 
        ? ayah.ayaTextEmlaey 
        : _cleanAyahText(ayah.ayaText);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${ayah.ayaNo}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Arabic text - ALWAYS use ayaTextEmlaey for readable text
          Text(
            displayText,
            style: TextStyle(
              fontFamily: 'Uthmanic', // Use Amiri for readable Arabic
              fontSize: fontSize,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),
          // Page and line information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الصفحة: ${ayah.page}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'الأسطر: ${ayah.lineStart}-${ayah.lineEnd}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to clean special characters if needed
  String _cleanAyahText(String text) {
    // Remove any special Unicode characters that might be causing issues
    return text.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  }
}