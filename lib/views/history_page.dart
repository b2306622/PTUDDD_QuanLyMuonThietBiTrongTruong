import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/borrow_provider.dart';
import '../viewmodels/auth_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
      if (user != null) {
        Provider.of<BorrowProvider>(context, listen: false).fetchUserRecords(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final borrowProvider = Provider.of<BorrowProvider>(context);
    final records = borrowProvider.records;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử mượn trả')),
      body: borrowProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? const Center(
                  child: Text('Bạn chưa có lịch sử mượn thiết bị nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Mã TB: ${record.deviceId}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Chip(
                                  label: Text(record.status),
                                  backgroundColor: record.status == 'borrowed'
                                      ? Colors.orange.shade100
                                      : Colors.green.shade100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Ngày mượn: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(record.borrowDate))}'),
                            if (record.returnDate.isNotEmpty)
                              Text('Ngày trả: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(record.returnDate))}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
