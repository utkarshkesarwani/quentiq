import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/data/mock_data.dart';
import 'package:quentiq/models/complaint_models.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Mark all read')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FilterChips(),
          const SizedBox(height: 20),
          ...MockData.notifications.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NotificationCard(item: n),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selected = 0;
  static const _filters = ['All', 'AI', 'Alerts', 'Progress'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (i) {
          final selected = _selected == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_filters[i]),
              selected: selected,
              onSelected: (_) => setState(() => _selected = i),
              selectedColor: AppColors.purple.withValues(alpha: 0.15),
              checkmarkColor: AppColors.purple,
              labelStyle: TextStyle(
                color: selected ? AppColors.purple : context.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (item.type) {
      'ai' => (Icons.auto_awesome_rounded, AppColors.purple),
      'alert' => (Icons.warning_amber_rounded, AppColors.warning),
      'progress' => (Icons.build_circle_outlined, AppColors.info),
      'resolved' => (Icons.check_circle_outline_rounded, AppColors.success),
      _ => (Icons.notifications_none_rounded, context.textMuted),
    };

    return AppCard(
      gradientBorder: item.isAi,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(item.time, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item.body, style: Theme.of(context).textTheme.bodyMedium),
                if (item.isAi) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientGlow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'AI generated',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
