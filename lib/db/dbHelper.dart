import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:todo/models/item.dart';

class DbHelper {
  String tblProduc = "Todo";
  String colId = "id";
  String colName = "name";
  String colDescription = "description";
  String colimportance = "importance";
  String colDate = "date";

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initalizeDb();
    }

    return _db;
  }

  Future<Database> initalizeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "todo.db";

    var dbData = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbData;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "Create Table $tblProduc($colId integer primary key, $colName text, $colDescription text, $colimportance text, $colDate text)");
  }

  Future<int> insert(Item item) async {
    Database db = await this.db;
    var result = await db.insert(tblProduc, item.toMap());
    return result;
  }

  Future<int> update(Item item) async {
    Database db = await this.db;
    var result = await db.update(tblProduc, item.toMap(),
        where: "$colId = ?", whereArgs: [item.id]);
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = db.rawDelete("Delete from $tblProduc where $colId = $id");
    return result;
  }

  Future<List> select() async {
    Database db = await this.db;
    var result = await db.rawQuery(
        "Select * from $tblProduc order by $colimportance ASC, $colDate DESC");
    return result;
  }
}
