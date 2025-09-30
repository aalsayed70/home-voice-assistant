import 'package:dar/models/device.dart';
import 'package:flutter/material.dart';

class Moment {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Map<String, DeviceSetting> deviceSettings;
  bool isActive;

  Moment({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.deviceSettings,
    this.isActive = false,
  });
}