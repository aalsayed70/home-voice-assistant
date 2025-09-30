import 'package:dar/models/device.dart';
import 'package:dar/models/moments.dart';
import 'package:flutter/material.dart';

class SmartHomeState extends ChangeNotifier {
  final List<Device> _devices = [
    Device(
      id: 'ac',
      name: 'Air Conditioner',
      icon: Icons.ac_unit,
      isOn: true,
      value: 18,
      unit: '°C',
      maxValue: 30,
    ),
    Device(
      id: 'theatre',
      name: 'Home Theatre',
      icon: Icons.speaker,
      isOn: true,
      value: 95,
      unit: 'Db',
      maxValue: 100,
    ),
    Device(
      id: 'lamp',
      name: 'Lamp',
      icon: Icons.lightbulb_outline,
      isOn: false,
      value: 40,
      unit: '%',
      maxValue: 100,
    ),
    Device(
      id: 'temperature',
      name: 'Temperature',
      icon: Icons.thermostat,
      isOn: true,
      value: 22,
      unit: '°C',
      maxValue: 30,
    ),
  ];

  final List<Moment> _moments = [
    Moment(
      id: 'guest',
      name: 'Guest\nMode',
      icon: Icons.people_outline,
      color: const Color(0xFF2A2A2A), // Green for guest mode
      deviceSettings: const {
        'lamp': DeviceSetting(isOn: true, value: 40.0),
        'ac': DeviceSetting(isOn: true, value: 22.0),
        'theatre': DeviceSetting(isOn: false, value: 0.0),
      },
    ),
    Moment(
      id: 'reading',
      name: 'Reading',
      icon: Icons.menu_book,
      color: const Color(0xFF2A2A2A), // Dark for reading
      deviceSettings: const {
        'lamp': DeviceSetting(isOn: true, value: 80.0),
        'ac': DeviceSetting(isOn: true, value: 20.0),
        'theatre': DeviceSetting(isOn: false, value: 0.0),
      },
    ),
    Moment(
      id: 'movie',
      name: 'Movie\nTime',
      icon: Icons.movie,
      color: const Color(0xFF2A2A2A), // Dark for movie
      deviceSettings: const {
        'lamp': DeviceSetting(isOn: true, value: 10.0),
        'theatre': DeviceSetting(isOn: true, value: 85.0),
        'ac': DeviceSetting(isOn: true, value: 19.0),
      },
    ),
    Moment(
      id: 'sleep',
      name: 'Sleep',
      icon: Icons.bedtime,
      color: const Color(0xFF2A2A2A), // Dark for sleep
      deviceSettings: const {
        'lamp': DeviceSetting(isOn: true, value: 5.0),
        'ac': DeviceSetting(isOn: true, value: 21.0),
        'theatre': DeviceSetting(isOn: false, value: 0.0),
      },
    ),
    Moment(
      id: 'party',
      name: 'Party\nTime',
      icon: Icons.celebration,
      color: const Color(0xFF2A2A2A), // Dark for party
      deviceSettings: const {
        'lamp': DeviceSetting(isOn: true, value: 100.0),
        'theatre': DeviceSetting(isOn: true, value: 95.0),
        'ac': DeviceSetting(isOn: true, value: 18.0),
      },
    ),
  ];

  String _currentMode = 'none';

  List<Device> get devices => _devices;
  List<Moment> get moments => _moments;
  String get currentMode => _currentMode;
  int get activeDevicesCount => _devices.where((d) => d.isOn).length;

  void applyMoment(Moment moment) {
    _currentMode = moment.id;

    moment.deviceSettings.forEach((deviceId, setting) {
      final idx = _devices.indexWhere((d) => d.id == deviceId);
      if (idx != -1) {
        _devices[idx].isOn = setting.isOn;
        _devices[idx].value = setting.value;
      }
    });

    for (var m in _moments) {
      m.isActive = m.id == moment.id;
    }
    notifyListeners();
  }

  void updateDevice(String deviceId, {bool? isOn, double? value}) {
    final idx = _devices.indexWhere((d) => d.id == deviceId);
    if (idx == -1) return;
    if (isOn != null) _devices[idx].isOn = isOn;
    if (value != null) {
      _devices[idx].value = value.clamp(0, _devices[idx].maxValue);
    }
    notifyListeners();
  }

  // Add a new moment to the list
  void addMoment(Moment newMoment) {
    _moments.add(newMoment);
    notifyListeners();
  }

  // Helper method to get moment display name
  String getMomentDisplayName(String momentId) {
    switch (momentId) {
      case 'guest':
        return 'Guest Mode';
      case 'reading':
        return 'Reading';
      case 'movie':
        return 'Movie Time';
      case 'sleep':
        return 'Sleep Mode';
      case 'party':
        return 'Party Time';
      default:
        return momentId.capitalized;
    }
  }

  // Get current moment color
  Color getCurrentMomentColor() {
    final moment = _moments.firstWhere(
      (m) => m.id == _currentMode,
      orElse: () => _moments.first,
    );
    return moment.color;
  }
}

// Extension for string capitalization
extension StringCasingX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
