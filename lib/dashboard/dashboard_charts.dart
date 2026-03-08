import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'package:shopease_admin/dashboard_provider.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _SalesChart()),
        SizedBox(width: 20),
        Expanded(child: _CategoriesChart()),
      ],
    );
  }
}

/* ================= SALES TREND CHART ================= */

class _SalesChart extends StatelessWidget {
  const _SalesChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final dashboard = context.watch<DashboardProvider>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.salesTrends, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(t.revenueGrowthOverTime, style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),

          if (dashboard.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: CircularProgressIndicator(),
              ),
            )
          else if (dashboard.salesTrend.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No sales data available',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: dashboard.salesTrend.length.toDouble() - 1,
                  minY: 0,
                  maxY: dashboard.salesTrend.reduce(
                        (a, b) => a > b ? a : b,
                  ) +
                      5,
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.green,
                      spots: List.generate(
                        dashboard.salesTrend.length,
                            (i) => FlSpot(
                          i.toDouble(),
                          dashboard.salesTrend[i],
                        ),
                      ),
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ================= CATEGORY DISTRIBUTION CHART ================= */

class _CategoriesChart extends StatelessWidget {
  const _CategoriesChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final dashboard = context.watch<DashboardProvider>();
    final data = dashboard.categoryStats;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.topCategories, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(t.salesDistributionByCategory, style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),

          if (dashboard.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: CircularProgressIndicator(),
              ),
            )
          else if (data.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  children: [
                    Icon(
                      Icons.category,
                      size: 48,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No categories available',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add categories to see distribution',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Builder(builder: (context) {
              // Actual data ki max value nikalo + 35% padding
              final maxVal = data
                  .map((e) => (e['value'] as num).toDouble())
                  .reduce((a, b) => a > b ? a : b);
              // Nearest 5 pe round up (e.g. 8% → 15, 12% → 20)
              final maxY = ((maxVal * 1.35) / 5).ceil() * 5.0;
              final interval = (maxY / 4).ceilToDouble();

              return SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,                          // ✅ Dynamic
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                          '${data[gi]['label']}\n${rod.toY.toStringAsFixed(1)}%',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                      // Bottom: 2-line labels
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= data.length) return const SizedBox();
                            final words = (data[i]['label'] as String).split(' ');
                            final line1 = words.take(2).join(' ');
                            final line2 = words.length > 2 ? words.skip(2).join(' ') : '';
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(line1,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: theme.colorScheme.onSurface.withOpacity(0.65)),
                                      textAlign: TextAlign.center),
                                  if (line2.isNotEmpty)
                                    Text(line2,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: theme.colorScheme.onSurface.withOpacity(0.65)),
                                        textAlign: TextAlign.center),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Left Y-axis — clean % labels
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 38,
                          interval: interval,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox();
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withOpacity(0.55),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    barGroups: List.generate(data.length, (i) {
                      final color = data[i]['color'] as Color;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (data[i]['value'] as num).toDouble(),
                            width: data.length <= 4 ? 32 : data.length <= 6 ? 24 : 18,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [color.withOpacity(0.75), color],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}