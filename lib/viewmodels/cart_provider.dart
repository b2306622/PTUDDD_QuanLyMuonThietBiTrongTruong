import 'package:flutter/material.dart';
import '../models/device.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Device> _items = {};

  Map<String, Device> get items => _items;

  int get itemCount => _items.length;

  void addItem(Device device) {
    if (!_items.containsKey(device.id)) {
      _items[device.id] = device;
      notifyListeners();
    }
  }

  void removeItem(String deviceId) {
    _items.remove(deviceId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
