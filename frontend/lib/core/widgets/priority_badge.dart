import 'package:flutter/material.dart';
import 'package:quentiq/models/complaint_models.dart';

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final ComplaintPriority priority;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      ComplaintPriority.urgent => ('Urgent', const Color(0xFFEF4444)),
      ComplaintPriority.high => ('High', const Color(0xFFF59E0B)),
      ComplaintPriority.medium => ('Medium', const Color(0xFF3B82F6)),
      ComplaintPriority.low => ('Low', const Color(0xFF64748B)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
