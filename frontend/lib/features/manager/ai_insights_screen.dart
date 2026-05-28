import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/section_header.dart';
import 'package:quentiq/data/mock_data.dart';
import 'package:quentiq/models/complaint_models.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              gradientBorder: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientGlow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Operational intelligence',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI analyzed 1,240 complaints across your properties',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: MockData.insights
                  .map(
                    (m) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _MetricTile(metric: m),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: MockData.insights
                  .skip(2)
                  .map(
                    (m) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _MetricTile(metric: m),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Complaint trends'),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last 7 days', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(MockData.weeklyTrend.length, (i) {
                        final v = MockData.weeklyTrend[i];
                        final max = MockData.weeklyTrend.reduce((a, b) => a > b ? a : b);
                        final h = (v / max) * 100;
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 28,
                              height: h,
                              decoration: BoxDecoration(
                                gradient: i == 3 ? AppColors.gradientGlow : null,
                                color: i == 3 ? null : AppColors.purple.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(days[i], style: Theme.of(context).textTheme.bodySmall),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Issue heatmap'),
            AppCard(
              child: Column(
                children: [
                  _HeatmapRow(block: 'Block A', intensity: 0.85),
                  _HeatmapRow(block: 'Block B', intensity: 0.95),
                  _HeatmapRow(block: 'Tower 1', intensity: 0.55),
                  _HeatmapRow(block: 'Tower 2', intensity: 0.72),
                  _HeatmapRow(block: 'Common areas', intensity: 0.68),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Recurring issues'),
            ...MockData.recurringIssues.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.$1, style: Theme.of(context).textTheme.titleMedium),
                            Text('${r.$2} · ${r.$3} reports this month',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${r.$3}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: AppColors.purple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI recommends preventive water pressure check in Block B every 2 weeks.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final InsightMetric metric;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.value, style: Theme.of(context).textTheme.titleLarge),
          Text(metric.label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            metric.trend,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: metric.isUp ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  const _HeatmapRow({required this.block, required this.intensity});

  final String block;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(block, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: intensity,
                minHeight: 12,
                backgroundColor: context.borderColor,
                color: Color.lerp(AppColors.purpleSoft, AppColors.error, intensity),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(intensity * 100).round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
