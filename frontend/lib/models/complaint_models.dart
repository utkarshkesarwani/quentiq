import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';

enum ComplaintCategory {
  plumbing,
  electrical,
  cleaning,
  water,
  maintenance,
}

enum ComplaintPriority { low, medium, high, urgent }

enum ComplaintStatus { submitted, assigned, inProgress, resolved }

extension ComplaintCategoryX on ComplaintCategory {
  String get label {
    switch (this) {
      case ComplaintCategory.plumbing:
        return 'Plumbing';
      case ComplaintCategory.electrical:
        return 'Electrical';
      case ComplaintCategory.cleaning:
        return 'Cleaning';
      case ComplaintCategory.water:
        return 'Water';
      case ComplaintCategory.maintenance:
        return 'Maintenance';
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintCategory.plumbing:
        return Icons.plumbing_rounded;
      case ComplaintCategory.electrical:
        return Icons.bolt_rounded;
      case ComplaintCategory.cleaning:
        return Icons.cleaning_services_rounded;
      case ComplaintCategory.water:
        return Icons.water_drop_rounded;
      case ComplaintCategory.maintenance:
        return Icons.handyman_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ComplaintCategory.plumbing:
        return AppColors.categoryPlumbing;
      case ComplaintCategory.electrical:
        return AppColors.categoryElectrical;
      case ComplaintCategory.cleaning:
        return AppColors.categoryCleaning;
      case ComplaintCategory.water:
        return AppColors.categoryWater;
      case ComplaintCategory.maintenance:
        return AppColors.categoryMaintenance;
    }
  }
}

class ComplaintItem {
  const ComplaintItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.updatedAt,
    this.priority = ComplaintPriority.medium,
    this.residentName,
    this.unit,
    this.workerName,
    this.eta,
  });

  final String id;
  final String title;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final String updatedAt;
  final String? residentName;
  final String? unit;
  final String? workerName;
  final String? eta;
}

class TimelineEvent {
  const TimelineEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isActive = false,
    this.isCompleted = false,
  });

  final String title;
  final String subtitle;
  final String time;
  final bool isActive;
  final bool isCompleted;
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isAi = false,
  });

  final String title;
  final String body;
  final String time;
  final String type;
  final bool isAi;
}

class InsightMetric {
  const InsightMetric({
    required this.label,
    required this.value,
    required this.trend,
    required this.isUp,
  });

  final String label;
  final String value;
  final String trend;
  final bool isUp;
}
