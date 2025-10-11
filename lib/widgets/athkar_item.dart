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

class _AthkarItemWidgetState extends State<AthkarItemWidget> {
  void _decrementCounter() {
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

  // Check if text contains Quranic verses (brackets or specific markers)
  bool _isQuranText(String text) {
    return text.contains('﴿') || 
           text.contains('﴾') || 
           text.contains('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ');
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.isCompleted;
    final isQuran = _isQuranText(widget.item.text);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppStyles.cardDecoration.copyWith(
        border: Border.all(
          color: isCompleted ? AppColors.success : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCompleted ? null : _decrementCounter,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Athkar Text - Use Uthmanic font for Quran, Amiri for others
                Text(
                  widget.item.text,
                  style: (isQuran ? AppStyles.quranText : AppStyles.bodyLarge).copyWith(
                    color: isCompleted 
                        ? AppColors.textSecondary 
                        : AppColors.textPrimary,
                    decoration: isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                
                const SizedBox(height: 20),
                
                // Counter and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reset Button
                    if (widget.item.currentCount != widget.item.count)
                      TextButton.icon(
                        onPressed: _resetCounter,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text(
                          'إعادة',
                          style: TextStyle(fontFamily: 'Amiri'),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    
                    // Counter Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? AppColors.success 
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: (isCompleted 
                                    ? AppColors.success 
                                    : AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCompleted)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            )
                          else
                            const Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 20,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted 
                                ? 'مكتمل' 
                                : '${widget.item.currentCount}',
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              color: Colors.white,
                              fontSize: 18,
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
    );
  }
}