import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Model for the SavedCalculation table
class SavedCalculation {
  final int? id; // S no. (Primary Key)
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

  // Convert a SavedCalculation into a Map. The keys must match the column names
  Map<String, dynamic> toMap() {
    return {
      'S_no': id,
      'fixed_value': fixedValue,
      'user_input': userInput,
      'result': result,
      'total_calculation': totalCalculation,
    };
  }

  // Convert a Map into a SavedCalculation
  factory SavedCalculation.fromMap(Map<String, dynamic> map) {
    return SavedCalculation(
      id: map['S_no'],
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
        S_no INTEGER PRIMARY KEY AUTOINCREMENT,
        fixed_value INTEGER,
        user_input INTEGER,
        result INTEGER,
        total_calculation INTEGER
      )
    ''');
  }

  // Insert a SavedCalculation into the database
  Future<int> insertSavedCalculation(SavedCalculation savedCalculation) async {
    final db = await instance.database;
    return await db.insert('SavedCalculation', savedCalculation.toMap());
  }

  // Get all SavedCalculations from the database
  Future<List<SavedCalculation>> getAllSavedCalculations() async {
    final db = await instance.database;
    final result = await db.query('SavedCalculation');
    return result.map((map) => SavedCalculation.fromMap(map)).toList();
  }

  // Get a single SavedCalculation by its id
  Future<SavedCalculation?> getSavedCalculationById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'SavedCalculation',
      where: 'S_no = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return SavedCalculation.fromMap(result.first);
    }
    return null;
  }

  // Update a SavedCalculation
  Future<int> updateSavedCalculation(SavedCalculation savedCalculation) async {
    final db = await instance.database;
    return await db.update(
      'SavedCalculation',
      savedCalculation.toMap(),
      where: 'S_no = ?',
      whereArgs: [savedCalculation.id],
    );
  }

  // Delete a SavedCalculation
  Future<int> deleteSavedCalculation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'SavedCalculation',
      where: 'S_no = ?',
      whereArgs: [id],
    );
  }
}
