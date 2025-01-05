import 'package:muday/src/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _databaseName = "expense_tracker.db";
  static const _databaseVersion = 1;
  static Database? _database;

  // Singleton pattern
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print('Initializing database');
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // User table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Transaction table
    await db.execute(transactionDbCreateQuery);

    // checkpoint table with automatic date and time
    await db.execute('''
      CREATE TABLE checkpoints (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    print('Database created');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    print('Database upgraded from $oldVersion to $newVersion');
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    Database db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String where,
    List<dynamic> whereArgs,
  ) async {
    Database db = await database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Transaction specific operations
  Future<List<Map<String, dynamic>>> getTransactions({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    Database db = await database;
    List<String> whereConditions = [];
    List<dynamic> whereArgs = [];

    if (userId != null) {
      whereConditions.add('user_id = ?');
      whereArgs.add(userId);
    }
    if (startDate != null) {
      whereConditions.add('date >= ?');
      whereArgs.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      whereConditions.add('date <= ?');
      whereArgs.add(endDate.toIso8601String());
    }
    if (type != null) {
      whereConditions.add('type = ?');
      whereArgs.add(type);
    }

    String? where =
        whereConditions.isEmpty ? null : whereConditions.join(' AND ');

    return await db.query(
      'transactions',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
  }

  // return all tables in the database
  Future<List<Map<String, dynamic>>> getTables() async {
    Database db = await database;
    return await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
  }
}
