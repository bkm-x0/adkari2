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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              color: AppColors.success,
              size: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'أحسنت!',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'لقد أكملت جميع الأذكار في هذا القسم\nجزاك الله خيراً',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
              ),
            ),
          ),
        ],
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
      appBar: AppBar(
        title: Text(
          widget.category.title,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_completedCount > 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetAll,
              tooltip: 'إعادة تعيين الكل',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(totalCount, progress),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد أذكار',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : _buildAthkarList(items),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(int totalCount, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$_completedCount / $totalCount',
            style: const TextStyle(
              fontFamily: 'Amiri',
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'الأذكار المكتملة',
            style: TextStyle(
              fontFamily: 'Amiri',
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthkarList(List<AthkarItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _AthkarItemWidget(
            item: items[index],
            onCompleted: _onItemCompleted,
          ),
        );
      },
    );
  }
}

class _AthkarItemWidget extends StatefulWidget {
  final AthkarItem item;
  final VoidCallback? onCompleted;

  const _AthkarItemWidget({
    required this.item,
    this.onCompleted,
  });

  @override
  State<_AthkarItemWidget> createState() => _AthkarItemWidgetState();
}

class _AthkarItemWidgetState extends State<_AthkarItemWidget> {
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

  bool _isQuranText(String text) {
    return text.contains('﴿') || text.contains('﴾');
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.isCompleted;
    final isQuran = _isQuranText(widget.item.displayText);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppColors.success : Colors.transparent,
          width: 2,
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
          onTap: isCompleted ? null : _decrementCounter,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Athkar Text
                Text(
                  widget.item.displayText,
                  style: (isQuran 
                      ? const TextStyle(fontFamily: 'Uthmanic', fontSize: 26, height: 2.2)
                      : const TextStyle(fontFamily: 'Amiri', fontSize: 22, height: 2.0)
                  ).copyWith(
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
                    if (widget.item.currentCount != widget.item.repeat)
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
                        gradient: LinearGradient(
                          colors: isCompleted 
                              ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                              : [AppColors.primary, AppColors.primaryLight],
                        ),
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
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.touch_app,
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