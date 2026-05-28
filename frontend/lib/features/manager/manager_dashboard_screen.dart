import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/section_header.dart';
import 'package:quentiq/data/mock_data.dart';
import 'package:quentiq/models/complaint_models.dart';
import 'package:quentiq/routes/app_routes.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

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
                  _buildOverviewCards(context),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Issue categories', style: Theme.of(context).textTheme.titleMedium),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.complaintQueue),
                        child: const Text('View queue'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CategoryGrid(),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Urgent issues'),
                  ...MockData.queueComplaints
                      .where((c) =>
                          c.priority == ComplaintPriority.urgent ||
                          c.priority == ComplaintPriority.high)
                      .take(2)
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _UrgentCard(complaint: c),
                        ),
                      ),
                  const SizedBox(height: 20),
                  SectionHeader(
                    title: 'Analytics',
                    action: 'Insights',
                    onActionTap: () =>
                        Navigator.pushNamed(context, AppRoutes.aiInsights),
                  ),
                  _AnalyticsRow(),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Pending tasks'),
                  ...['Assign QT-2851 to water team', 'Review recurring Block B issues', 'Approve vendor for lift repair']
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _TaskRow(title: t),
                        ),
                      ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _ManagerNavBar(
        onQueue: () => Navigator.pushNamed(context, AppRoutes.complaintQueue),
        onInsights: () => Navigator.pushNamed(context, AppRoutes.aiInsights),
        onHome: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manager dashboard', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Green Valley PG · 3 properties', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: Icon(Icons.notifications_none_rounded, color: context.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: context.surfaceColor,
              side: BorderSide(color: context.borderColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Open',
            value: '47',
            icon: Icons.inbox_rounded,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Urgent',
            value: '6',
            icon: Icons.priority_high_rounded,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Resolved today',
            value: '18',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: MockData.categoryCounts.entries.map((e) {
        return AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(e.key.icon, color: e.key.color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.key.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text('${e.value} open', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _UrgentCard extends StatelessWidget {
  const _UrgentCard({required this.complaint});

  final ComplaintItem complaint;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.complaintQueue),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(complaint.title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${complaint.unit} · ${complaint.updatedAt}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.error),
        ],
      ),
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.aiInsights),
      child: Row(
        children: [
          Expanded(
            child: _MiniMetric(label: 'Avg resolution', value: '4.2h', trend: '-18%'),
          ),
          Container(width: 1, height: 40, color: context.borderColor),
          Expanded(
            child: _MiniMetric(label: 'AI accuracy', value: '94%', trend: '+2%'),
          ),
          Container(width: 1, height: 40, color: context.borderColor),
          Expanded(
            child: _MiniMetric(label: 'Satisfaction', value: '4.6★', trend: '+0.3'),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.trend,
  });

  final String label;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          trend,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked_rounded, color: context.textMuted, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium)),
          Icon(Icons.chevron_right_rounded, color: context.textMuted),
        ],
      ),
    );
  }
}

class _ManagerNavBar extends StatelessWidget {
  const _ManagerNavBar({
    required this.onQueue,
    required this.onInsights,
    required this.onHome,
  });

  final VoidCallback onQueue;
  final VoidCallback onInsights;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(top: BorderSide(color: context.borderColor)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBtn(icon: Icons.dashboard_rounded, label: 'Dashboard', selected: true, onTap: () {}),
              _NavBtn(icon: Icons.list_alt_rounded, label: 'Queue', selected: false, onTap: onQueue),
              _NavBtn(icon: Icons.insights_rounded, label: 'Insights', selected: false, onTap: onInsights),
              _NavBtn(icon: Icons.home_outlined, label: 'Resident', selected: false, onTap: onHome),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purple : context.textMuted;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}
