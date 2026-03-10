import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class AthkarDetailPage extends StatefulWidget {
  final AthkarCategory category;

  const AthkarDetailPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<AthkarDetailPage> createState() => _AthkarDetailPageState();
}

class _AthkarDetailPageState extends State<AthkarDetailPage> {
  int _completedCount = 0;

  void _onItemCompleted() {
    setState(() {
      _completedCount = widget.category.items!
          .where((item) => item.isCompleted)
          .length;
    });

    if (_completedCount == widget.category.items!.length) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'أحسنت!',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'لقد أكملت جميع الأذكار في هذا القسم\nجزاك الله خيراً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetAll() {
    setState(() {
      for (var item in widget.category.items!) {
        item.resetCount();
      }
      _completedCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.category.items ?? [];
    final totalCount = items.length;
    final progress = totalCount > 0 ? _completedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsing app bar with progress
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            actions: [
              if (_completedCount > 0)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _resetAll,
                  tooltip: 'إعادة تعيين الكل',
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.category.title,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                      const SizedBox(height: 16),
                      // Circular progress
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accentLight,
                                ),
                                strokeWidth: 5,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(
                              '$_completedCount/$totalCount',
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الأذكار المكتملة',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Items
          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'لا توجد أذكار',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 40)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 16 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _AthkarItemWidget(
                        item: items[index],
                        index: index,
                        total: items.length,
                        onCompleted: _onItemCompleted,
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// === Athkar Item Widget ===

class _AthkarItemWidget extends StatefulWidget {
  final AthkarItem item;
  final int index;
  final int total;
  final VoidCallback? onCompleted;

  const _AthkarItemWidget({
    required this.item,
    required this.index,
    required this.total,
    this.onCompleted,
  });

  @override
  State<_AthkarItemWidget> createState() => _AthkarItemWidgetState();
}

class _AthkarItemWidgetState extends State<_AthkarItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;
  late Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  void _decrementCounter() async {
    _tapCtrl.forward().then((_) => _tapCtrl.reverse());
    setState(() {
      widget.item.decrementCount();
      if (widget.item.isCompleted && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });
  }

  void _resetCounter() {
    setState(() {
      widget.item.resetCount();
    });
  }

  bool _isQuranText(String text) {
    return text.contains('﴿') || text.contains('﴾');
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.isCompleted;
    final isQuran = _isQuranText(widget.item.displayText);
    final remaining = widget.item.currentCount;
    final total = widget.item.repeat;
    final fraction = total > 0 ? (total - remaining) / total : 0.0;

    return AnimatedBuilder(
      animation: _tapScale,
      builder: (context, child) => Transform.scale(
        scale: _tapScale.value,
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isCompleted
              ? Border.all(color: AppColors.success.withOpacity(0.4), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? AppColors.success.withOpacity(0.08)
                  : AppColors.shadowLight,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isCompleted ? null : _decrementCounter,
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColors.primary.withOpacity(0.06),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item number badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.index + 1}/${widget.total}',
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Athkar text
                  Text(
                    widget.item.displayText,
                    style: (isQuran
                        ? const TextStyle(fontFamily: 'Uthmanic', fontSize: 24, height: 2.2)
                        : const TextStyle(fontFamily: 'Amiri', fontSize: 20, height: 1.9)
                    ).copyWith(
                      color: isCompleted
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 20),
                  // Mini progress bar
                  if (total > 1) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 3,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  // Counter row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reset
                      if (remaining != total)
                        TextButton.icon(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text(
                            'إعادة',
                            style: TextStyle(fontFamily: 'Amiri', fontSize: 13),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      // Counter pill
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColors.success : AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted ? Icons.check_rounded : Icons.touch_app_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isCompleted ? 'مكتمل' : '$remaining',
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}