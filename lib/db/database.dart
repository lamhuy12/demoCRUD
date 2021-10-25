import 'dart:io';

import 'package:path_provider/path_provider.dart';//getApplicationDocumentsDirectory
import 'package:sqflite/sqflite.dart';
import 'package:sqliteflutter/model/category.dart';
import 'package:path/path.dart'; //join

class DatabaseHelper{

  //tạo constructor dạng singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  //phương thức get instance databasae
  //nếu _database rỗng chưa có thì tạo database gọi hàm init
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async
  {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'groceries.db');
    print("path: ${documentDirectory.path}");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }


  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE groceries(
       id INTEGER PRIMARY KEY,
       name TEXT
       )
    ''');
  }

  //get list grocery
  Future<List<Grocery>> getGoceries() async
  {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = groceries.isNotEmpty ? groceries.map((e) => Grocery.fromMap(e)).toList() : [];
    return groceryList;
  }


  //Insert
  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  //Delete
  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?',whereArgs: [id] );
  }

  //Update
  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(), where: 'id = ?', whereArgs: [grocery.id]);
  }

}