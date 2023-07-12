import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CircularChart extends StatelessWidget {
  final double percentage;
  final Color backgroundColor = Palette.darkGrey;
  final Color progressColor = Palette.tertiaryColor;
  final String title;

  CircularChart({Key? key, required this.percentage, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: Border.all(color: Palette.black)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          showTitle: false,
                          radius: 14,
                          value: percentage,
                          color: progressColor,
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          radius: 14,
                          value: 100 - percentage,
                          color: backgroundColor,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Palette.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
