import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Model for SavedCalculation
class SavedCalculation {
  final int? id; // Primary Key
  final int fixedValue;
  final int userInput;
  final int result;
  final int totalCalculation;

  SavedCalculation({
    this.id,
    required this.fixedValue,
    required this.userInput,
    required this.result,
    required this.totalCalculation,
  });

  // Convert SavedCalculation into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // Changed 'S_no' to 'id'
      'fixed_value': fixedValue,
      'user_input': userInput,
      'result': result,
      'total_calculation': totalCalculation,
    };
  }

  // Convert a Map into SavedCalculation
  factory SavedCalculation.fromMap(Map<String, dynamic> map) {
    return SavedCalculation(
      id: map['id'],
      fixedValue: map['fixed_value'],
      userInput: map['user_input'],
      result: map['result'],
      totalCalculation: map['total_calculation'],
    );
  }
}

// Database helper class for CRUD operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database if it's not already initialized
    _database = await _initDB('calculations.db');
    return _database!;
  }

  // Open the database
  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the table in the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE SavedCalculation(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fixed_value INTEGER,
        user_input INTEGER,
        result INTEGER,
        total_calculation INTEGER
      )
    ''');
    // Optional: Adding indexes for better query performance on columns
    await db.execute('CREATE INDEX IF NOT EXISTS idx_fixed_value ON SavedCalculation(fixed_value)');
  }

  // Insert or update a SavedCalculation (upsert functionality)
  Future<int> insertOrUpdateSavedCalculation(SavedCalculation savedCalculation) async {
    final db = await instance.database;
    // Check if record exists by id
    if (savedCalculation.id == null) {
      // Insert if new record
      return await db.insert('SavedCalculation', savedCalculation.toMap());
    } else {
      // Update existing record
      return await db.update(
        'SavedCalculation',
        savedCalculation.toMap(),
        where: 'id = ?',
        whereArgs: [savedCalculation.id],
      );
    }
  }

  // Get all SavedCalculations from the database
  Future<List<SavedCalculation>> getAllSavedCalculations() async {
    final db = await instance.database;
    final result = await db.query('SavedCalculation');
    return result.map((map) => SavedCalculation.fromMap(map)).toList();
  }

  // Get SavedCalculations by fixed value
  Future<List<SavedCalculation>> getSavedCalculationsByFixedValue(int fixedValue) async {
    final db = await instance.database;
    final result = await db.query(
      'SavedCalculation',
      where: 'fixed_value = ?',
      whereArgs: [fixedValue],
    );
    return result.map((map) => SavedCalculation.fromMap(map)).toList();
  }

  // Get a single SavedCalculation by its id
  Future<SavedCalculation?> getSavedCalculationById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'SavedCalculation',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return SavedCalculation.fromMap(result.first);
    }
    return null;
  }

  // Delete a SavedCalculation
  Future<int> deleteSavedCalculation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'SavedCalculation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all SavedCalculations (optional)
  Future<int> deleteAllSavedCalculations() async {
    final db = await instance.database;
    return await db.delete('SavedCalculation');
  }

  // Batch insert multiple calculations (for better performance)
  Future<void> insertMultipleSavedCalculations(List<SavedCalculation> calculations) async {
    final db = await instance.database;
    Batch batch = db.batch();

    for (var calc in calculations) {
      batch.insert('SavedCalculation', calc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  // Batch update multiple calculations (optional)
  Future<void> updateMultipleSavedCalculations(List<SavedCalculation> calculations) async {
    final db = await instance.database;
    Batch batch = db.batch();

    for (var calc in calculations) {
      batch.update(
        'SavedCalculation',
        calc.toMap(),
        where: 'id = ?',
        whereArgs: [calc.id],
      );
    }
    await batch.commit();
  }
}
