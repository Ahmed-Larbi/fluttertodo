import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/task.dart';
import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'todo.db'),
        onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
      );
      await db.execute(
        'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER ,title TEXT, isDone INTEGER)',
      );
      return Future.value();
    }, version: 1);
  }

  Future<void> updateTaskDesc(int id, String newTitle) async {
    Database _db = await database();

    await _db
        .rawUpdate("UPDATE tasks SET description = '$newTitle' WHERE id = $id");
  }

  Future<void> updateTaskisDone(int id, int isDone) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = $id");
  }

  Future<void> updateTaskTitle(int id, String newTitle) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE tasks SET title = '$newTitle' WHERE id = $id");
  }

  Future<void> deleteTask(
    int id,
  ) async {
    Database _db = await database();

    await _db.rawDelete("DELETE FROM tasks WHERE id = $id");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = $id");
    print("Delete task");
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;

    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => taskId = value);
    return taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
          isDone: todoMap[index]['isDone']);
    });
  }
}