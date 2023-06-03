import 'package:flutter/material.dart';

class Activity {
  String name;
  num duration;
  num? steps;
  num? distance;
  num finalDistance = -1;

  Activity({required this.name, required this.duration, steps, distance}) {
    if (distance != null) {
      finalDistance = distance!;
    } else if (distance == null && steps != null) {
      finalDistance = (steps! * 0.8 / 1000);
    } else {
      finalDistance = -1;
    }
  }

  @override
  String toString() {
    String string =
        'Activity: $name - Duration: ${(duration / 60000).round()} minutes - Distance: ${finalDistance.toStringAsFixed(2)} km\n';
    return string;
  }
}
