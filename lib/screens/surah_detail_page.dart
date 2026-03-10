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
  bool _showControls = false;

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
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildSurahHeader()),
          _buildAyahsList(),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.surah.suraNameAr,
          style: const TextStyle(
            fontFamily: 'Uthmanic',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // Surah number badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.surah.suraNo}',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.surah.suraNameAr,
                  style: const TextStyle(
                    fontFamily: 'Uthmanic',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.surah.suraNameEn,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.75),
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
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoChip(Icons.format_list_numbered_rounded, '${widget.surah.numberOfAyahs} آية'),
          _buildDivider(),
          _buildInfoChip(
            isMeccan ? Icons.location_city_rounded : Icons.mosque_rounded,
            isMeccan ? 'مكية' : 'مدنية',
          ),
          _buildDivider(),
          _buildInfoChip(Icons.auto_stories_rounded, 'جزء ${widget.surah.jozz}'),
          _buildDivider(),
          _buildInfoChip(Icons.bookmark_rounded, 'ص ${widget.surah.firstPage}'),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.surface,
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

  Widget _buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showControls) ...[
          _buildMiniFab(
            heroTag: 'font_toggle',
            onPressed: _toggleFont,
            icon: _showUthmanic ? Icons.text_fields_rounded : Icons.font_download_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          _buildMiniFab(
            heroTag: 'decrease_font',
            onPressed: _decreaseFontSize,
            icon: Icons.text_decrease_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(height: 8),
          _buildMiniFab(
            heroTag: 'increase_font',
            onPressed: _increaseFontSize,
            icon: Icons.text_increase_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(height: 10),
        ],
        FloatingActionButton.small(
          heroTag: 'toggle_controls',
          onPressed: () => setState(() => _showControls = !_showControls),
          backgroundColor: AppColors.primary,
          child: AnimatedRotation(
            turns: _showControls ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniFab({
    required String heroTag,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      mini: true,
      backgroundColor: color,
      elevation: 3,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

// === Ayah Card ===

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
    final displayText = ayah.ayaTextEmlaey.isNotEmpty
        ? ayah.ayaTextEmlaey
        : _cleanAyahText(ayah.ayaText);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah number badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${ayah.ayaNo}',
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'ص ${ayah.page}',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Arabic text
          Text(
            displayText,
            style: TextStyle(
              fontFamily: 'Uthmanic',
              fontSize: fontSize,
              height: 1.9,
              color: AppColors.textPrimary,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  String _cleanAyahText(String text) {
    return text.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  }
}