class BorrowRecord {
  final String id;
  final String userId;
  final String deviceId;
  final String borrowDate;
  final String returnDate;
  final String status; // 'pending', 'approved', 'returned', 'rejected'

  BorrowRecord({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.borrowDate,
    required this.returnDate,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'borrowDate': borrowDate,
      'returnDate': returnDate,
      'status': status,
    };
  }

  factory BorrowRecord.fromMap(Map<String, dynamic> map) {
    return BorrowRecord(
      id: map['id'],
      userId: map['userId'],
      deviceId: map['deviceId'],
      borrowDate: map['borrowDate'],
      returnDate: map['returnDate'],
      status: map['status'],
    );
  }
}
