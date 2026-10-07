import 'package:flutter/material.dart';
import '../models/borrow_record.dart';
import '../services/database_helper.dart';

class BorrowProvider with ChangeNotifier {
  List<BorrowRecord> _records = [];
  bool _isLoading = false;

  List<BorrowRecord> get records => _records;
  bool get isLoading => _isLoading;

  Future<void> fetchUserRecords(String userId) async {
    _isLoading = true;
    notifyListeners();

    _records = await DatabaseHelper.instance.getBorrowRecordsByUser(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBorrowRecord(BorrowRecord record) async {
    await DatabaseHelper.instance.createBorrowRecord(record);
    // Refresh records if the new record belongs to the current user, or just fetch again
    await fetchUserRecords(record.userId);
  }

  Future<void> deleteRecord(String recordId, String userId) async {
    await DatabaseHelper.instance.deleteBorrowRecord(recordId);
    await fetchUserRecords(userId);
  }
}
