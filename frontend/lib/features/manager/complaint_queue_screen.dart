import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/category_chip.dart';
import 'package:quentiq/core/widgets/priority_badge.dart';
import 'package:quentiq/data/mock_data.dart';
import 'package:quentiq/models/complaint_models.dart';

class ComplaintQueueScreen extends StatefulWidget {
  const ComplaintQueueScreen({super.key});

  @override
  State<ComplaintQueueScreen> createState() => _ComplaintQueueScreenState();
}

class _ComplaintQueueScreenState extends State<ComplaintQueueScreen> {
  ComplaintCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final items = _filter == null
        ? MockData.queueComplaints
        : MockData.queueComplaints.where((c) => c.category == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint queue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _CategoryFilterChip(
                  label: 'All',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                ...ComplaintCategory.values.map(
                  (c) => _CategoryFilterChip(
                    label: c.label,
                    selected: _filter == c,
                    color: c.color,
                    onTap: () => setState(() => _filter = c),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: items.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _QueueCard(complaint: items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: (color ?? AppColors.purple).withValues(alpha: 0.15),
        labelStyle: TextStyle(
          color: selected ? (color ?? AppColors.purple) : context.textMuted,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({required this.complaint});

  final ComplaintItem complaint;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(complaint.id, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              PriorityBadge(priority: complaint.priority),
            ],
          ),
          const SizedBox(height: 10),
          Text(complaint.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          CategoryChip(category: complaint.category, compact: true),
          const SizedBox(height: 14),
          Divider(color: context.borderColor),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.deepBlue.withValues(alpha: 0.1),
                child: Text(
                  (complaint.residentName ?? '?')[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.residentName ?? '—',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(complaint.unit ?? '', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(complaint.updatedAt, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAssignSheet(context),
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Assign'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Details'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAssignSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Assign technician', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...['Ravi Kumar · Plumbing', 'Suresh Patel · Electrical', 'Meena Devi · Cleaning']
                .map(
                  (w) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(w),
                    onTap: () => Navigator.pop(ctx),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
