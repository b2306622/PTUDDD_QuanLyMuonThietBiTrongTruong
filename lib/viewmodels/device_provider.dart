import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/database_helper.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> _devices = [];
  bool _isLoading = false;

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;

  List<Device> get newDevices => _devices.where((d) => d.isNew).toList();

  Future<void> fetchDevices() async {
    _isLoading = true;
    notifyListeners();

    _devices = await DatabaseHelper.instance.getAllDevices();

    _isLoading = false;
    notifyListeners();
  }

  Device? getDeviceById(String id) {
    try {
      return _devices.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDeviceStatus(String id, String status) async {
    await DatabaseHelper.instance.updateDeviceStatus(id, status);
    await fetchDevices();
  }

  Future<void> addDevice(Device device) async {
    await DatabaseHelper.instance.createDevice(device);
    await fetchDevices();
  }

  Future<void> updateDevice(Device device) async {
    await DatabaseHelper.instance.updateDevice(device);
    await fetchDevices();
  }

  Future<void> deleteDevice(String id) async {
    await DatabaseHelper.instance.deleteDevice(id);
    await fetchDevices();
  }
}
