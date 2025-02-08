import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/tasks.dart';

class TasksServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Tasks> _tasks = [];
  List<Tasks> get tasks => _tasks;

  Future<void> loadTasks(String listId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('tasks')
        .where('listId', isEqualTo: listId)
        .orderBy('createdAt', descending: true)
        .get();

    _tasks = snapshot.docs.map((doc) => Tasks.fromJson(doc)).toList();
    notifyListeners();
  }

  Future<void> addTask(String listId, String title) async {
    Tasks newTask = Tasks(
      title: title,
      isCompleted: false,
      listId: listId,
      createdAt: Timestamp.now(),
    );

    DocumentReference docRef =
        await _firestore.collection('tasks').add(newTask.toJson());
    newTask.id = docRef.id;

    _tasks.insert(0, newTask);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });

    int index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index].isCompleted = isCompleted;
    }

    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  List<Tasks> getTasksForList(String listId) {
    return _tasks.where((task) => task.listId == listId).toList();
  }
}
