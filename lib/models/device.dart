import 'package:flutter/material.dart';

class Device {
  final String id;
  final String name;
  final IconData icon;
  bool isOn;
  double value;
  final String unit;
  final double maxValue;

  Device({
    required this.id,
    required this.name,
    required this.icon,
    this.isOn = false,
    this.value = 0,
    required this.unit,
    this.maxValue = 100,
  });
}

class DeviceSetting {
  final bool isOn;
  final double value;
  const DeviceSetting({required this.isOn, required this.value});
}