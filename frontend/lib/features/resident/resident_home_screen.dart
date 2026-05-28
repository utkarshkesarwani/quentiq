import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/category_chip.dart';
import 'package:quentiq/core/widgets/section_header.dart';
import 'package:quentiq/data/mock_data.dart';
import 'package:quentiq/models/complaint_models.dart';
import 'package:quentiq/routes/app_routes.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildQuickActions(context),
                  const SizedBox(height: 28),
                  const SectionHeader(
                    title: 'Active complaints',
                    action: 'See all',
                  ),
                  ...MockData.activeComplaints.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ComplaintTile(
                        complaint: c,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.complaintTracking,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Recent updates'),
                  ...MockData.recentUpdates.map(
                    (u) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _UpdateRow(text: u.$1, time: u.$2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AiAssistantCard(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.raiseComplaint),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _HomeNavBar(
        currentIndex: 0,
        onNotifications: () =>
            Navigator.pushNamed(context, AppRoutes.notifications),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good afternoon',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Amit Verma',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 26,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Room 112 · Green Valley PG',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            style: IconButton.styleFrom(
              backgroundColor: context.surfaceColor,
              side: BorderSide(color: context.borderColor),
            ),
            icon: Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded, color: context.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            gradient: AppColors.gradientPrimary,
            icon: Icons.add_circle_outline_rounded,
            label: 'Raise Issue',
            subtitle: 'Text, photo, video',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.raiseComplaint),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            gradient: AppColors.gradientGlow,
            icon: Icons.mic_rounded,
            label: 'Voice',
            subtitle: 'Speak your issue',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.raiseComplaint,
              arguments: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.gradient,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final Gradient gradient;
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComplaintTile extends StatelessWidget {
  const _ComplaintTile({required this.complaint, required this.onTap});

  final ComplaintItem complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: complaint.category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              complaint.category.icon,
              color: complaint.category.color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(complaint.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CategoryChip(category: complaint.category, compact: true),
                    const SizedBox(width: 8),
                    Text(
                      complaint.id,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusDot(status: complaint.status),
              const SizedBox(height: 4),
              Text(
                complaint.updatedAt,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final ComplaintStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ComplaintStatus.submitted => ('New', AppColors.info),
      ComplaintStatus.assigned => ('Assigned', AppColors.warning),
      ComplaintStatus.inProgress => ('In progress', AppColors.purple),
      ComplaintStatus.resolved => ('Resolved', AppColors.success),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _UpdateRow extends StatelessWidget {
  const _UpdateRow({required this.text, required this.time});

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
              Text(time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiAssistantCard extends StatelessWidget {
  const _AiAssistantCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradientBorder: true,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.gradientGlow,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quentiq AI Assistant',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask about your complaints or get instant help',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.textMuted),
        ],
      ),
    );
  }
}

class _HomeNavBar extends StatelessWidget {
  const _HomeNavBar({
    required this.currentIndex,
    required this.onNotifications,
  });

  final int currentIndex;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(top: BorderSide(color: context.borderColor)),
        boxShadow: context.cardShadow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', selected: currentIndex == 0),
              _NavItem(
                icon: Icons.notifications_none_rounded,
                label: 'Alerts',
                selected: false,
                onTap: onNotifications,
              ),
              _NavItem(icon: Icons.history_rounded, label: 'History', selected: false),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purple : context.textMuted;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
