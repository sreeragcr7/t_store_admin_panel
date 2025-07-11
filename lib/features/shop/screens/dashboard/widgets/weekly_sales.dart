import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';

class TWeeklySalesGraph extends StatelessWidget {
  const TWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          Text('Wekly Sales', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwSections / 2),

          //Graph
          SizedBox(
            height: 300,
            child: Obx(
              () => BarChart(
                BarChartData(
                  titlesData: buildFlTitlesData(),
                  borderData: FlBorderData(show: true, border: Border(top: BorderSide.none, right: BorderSide.none)),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 200,
                  ),
                  barGroups:
                      controller.weeklySales
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  width: 30,
                                  color: TColors.primary,
                                  borderRadius: BorderRadius.circular(TSizes.sm),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                  groupsSpace: TSizes.spaceBtwItems,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => TColors.secondary),
                    touchCallback: TDeviceUtils.isDesktopScreen(context) ? (barTouchEvent, barTouchResponse) {} : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData buildFlTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            //Map index to the desired day of the week
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

            //Calculate the index & ensure it wraps around for the correct day
            final index = value.toInt() % days.length;

            //Get the day corresponding to the calculatde index
            final day = days[index];

            return SideTitleWidget(meta: meta, space: 0, child: Text(day));
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 200, reservedSize: 50)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
