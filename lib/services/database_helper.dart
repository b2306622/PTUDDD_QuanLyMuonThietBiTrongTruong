import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/device.dart';
import '../models/borrow_record.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final _uuid = const Uuid();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE devices (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        status TEXT NOT NULL,
        isNew INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE borrow_records (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        deviceId TEXT NOT NULL,
        borrowDate TEXT NOT NULL,
        returnDate TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (deviceId) REFERENCES devices (id)
      )
    ''');

    // Seed data
    await _seedData(db);
  }

  Future _seedData(Database db) async {
    // Seed users
    await db.insert('users', {
      'id': 'u1',
      'name': 'Sinh viên A',
      'email': 'sv@gmail.com',
      'password': '123',
      'role': 'student',
    });

    // Seed devices
    final devices = [
      {
        'id': 'd1',
        'name': 'Máy chiếu Panasonic PT-LB303',
        'description': 'Máy chiếu độ phân giải cao, phù hợp phòng học.',
        'category': 'Máy chiếu',
        'imageUrl': 'https://via.placeholder.com/150/0000FF/808080?text=May+chieu',
        'status': 'available',
        'isNew': 1,
      },
      {
        'id': 'd2',
        'name': 'Micro Không Dây Shure',
        'description': 'Micro thu âm tốt, chống ồn hiệu quả.',
        'category': 'Âm thanh',
        'imageUrl': 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Micro',
        'status': 'available',
        'isNew': 1,
      },
      {
        'id': 'd3',
        'name': 'Loa Kéo Karaoke',
        'description': 'Loa di động, công suất lớn.',
        'category': 'Âm thanh',
        'imageUrl': 'https://via.placeholder.com/150/00FF00/000000?text=Loa',
        'status': 'available',
        'isNew': 0,
      },
      {
        'id': 'd4',
        'name': 'Cáp HDMI 5m',
        'description': 'Cáp nối máy tính với máy chiếu.',
        'category': 'Phụ kiện',
        'imageUrl': 'https://via.placeholder.com/150/FFFF00/000000?text=Cap+HDMI',
        'status': 'available',
        'isNew': 0,
      },
      {
        'id': 'd5',
        'name': 'Laptop Dell Latitude',
        'description': 'Laptop dự phòng cho giảng viên.',
        'category': 'Máy tính',
        'imageUrl': 'https://via.placeholder.com/150/00FFFF/000000?text=Laptop',
        'status': 'unavailable',
        'isNew': 0,
      },
      {
        'id': 'd6',
        'name': 'Bảng Vẽ Điện Tử Wacom',
        'description': 'Hỗ trợ dạy học online.',
        'category': 'Phụ kiện',
        'imageUrl': 'https://via.placeholder.com/150/FF00FF/FFFFFF?text=Wacom',
        'status': 'available',
        'isNew': 1,
      },
    ];

    for (var device in devices) {
      await db.insert('devices', device);
    }
  }

  // User CRUD
  Future<User?> authenticate(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Device CRUD
  Future<List<Device>> getAllDevices() async {
    final db = await instance.database;
    final result = await db.query('devices');
    return result.map((json) => Device.fromMap(json)).toList();
  }

  Future<Device?> getDeviceById(String id) async {
    final db = await instance.database;
    final maps = await db.query('devices', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Device.fromMap(maps.first);
    }
    return null;
  }
  
  Future<int> updateDeviceStatus(String id, String status) async {
    final db = await instance.database;
    return await db.update(
      'devices',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> createDevice(Device device) async {
    final db = await instance.database;
    final data = device.toMap();
    if (data['id'] == null || data['id'].toString().isEmpty) {
      data['id'] = _uuid.v4();
    }
    return await db.insert('devices', data);
  }

  Future<int> updateDevice(Device device) async {
    final db = await instance.database;
    return await db.update(
      'devices',
      device.toMap(),
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }

  Future<int> deleteDevice(String id) async {
    final db = await instance.database;
    return await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Borrow Record CRUD
  Future<BorrowRecord> createBorrowRecord(BorrowRecord record) async {
    final db = await instance.database;
    final data = record.toMap();
    if (data['id'] == null || data['id'].toString().isEmpty) {
      data['id'] = _uuid.v4();
    }
    await db.insert('borrow_records', data);
    return BorrowRecord.fromMap(data);
  }

  Future<List<BorrowRecord>> getBorrowRecordsByUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'borrow_records',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'borrowDate DESC',
    );
    return result.map((json) => BorrowRecord.fromMap(json)).toList();
  }

  Future<int> updateBorrowRecordStatus(String id, String status) async {
    final db = await instance.database;
    return await db.update(
      'borrow_records',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> deleteBorrowRecord(String id) async {
    final db = await instance.database;
    return await db.delete(
      'borrow_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
