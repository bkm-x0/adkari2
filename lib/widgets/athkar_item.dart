import 'package:flutter/material.dart';
import '../models/athkar_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class AthkarItemWidget extends StatefulWidget {
  final AthkarItem item;
  final VoidCallback? onCompleted;

  const AthkarItemWidget({
    Key? key,
    required this.item,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<AthkarItemWidget> createState() => _AthkarItemWidgetState();
}

class _AthkarItemWidgetState extends State<AthkarItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;
  late Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      duration: const Duration(milliseconds: 100),
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

  void _decrementCounter() {
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
    return text.contains('﴿') ||
        text.contains('﴾') ||
        text.contains('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ');
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.isCompleted;
    final isQuran = _isQuranText(widget.item.text);
    final remaining = widget.item.currentCount;
    final total = widget.item.count;
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: isCompleted
              ? Border.all(color: AppColors.success.withOpacity(0.35), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? AppColors.success.withOpacity(0.08)
                  : AppColors.shadowLight,
              blurRadius: 14,
              offset: const Offset(0, 5),
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
                  // Text
                  Text(
                    widget.item.text,
                    style: (isQuran ? AppStyles.quranText : AppStyles.bodyLarge).copyWith(
                      color: isCompleted
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 18),
                  // Mini progress
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