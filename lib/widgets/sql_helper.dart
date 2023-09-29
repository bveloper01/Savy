import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      amount REAL,
      chosenDate TEXT)""");
  }

  static Future<sql.Database> openDatabase() async {
    return sql.openDatabase(
      'savetx.savy',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createTransaction(
      double amount, DateTime chosenDate, String? title) async {
    final savy = await openDatabase();

    final txs = {
      'amount': amount,
      'title': title,
      'chosenDate': chosenDate.toIso8601String(),
    };
    final id = await savy.insert('transactions', txs,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final savy = await openDatabase();
    return savy.query('transactions', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTransaction(int id) async {
    final savy = await openDatabase();
    return savy.query('transactions',
        where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> edittx(
      int id, double amount, DateTime chosenDate, String? title) async {
    final savy = await openDatabase();
    final txs = {
      'amount': amount,
      'title': title,
      'chosenDate': chosenDate.toIso8601String(),
    };
    final result = await savy
        .update('transactions', txs, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deletetx(int id) async {
    final savy = await openDatabase();
    try {
      await savy.delete("transactions", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
