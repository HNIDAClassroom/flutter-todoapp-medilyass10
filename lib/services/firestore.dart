import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot> getTasks() {
    final taskStream = tasks.snapshots();
    return taskStream;
  }

  Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskTitle': task.title.toString(),
        'taskDesc': task.description.toString(),
        'taskCategory': task.category.toString(),
        'taskDate': task.date.toIso8601String(),
      },
    );
  }

  Future<void> deleteTask(Task task) {
    final taskQuery = tasks
        .where('taskTitle', isEqualTo: task.title)
        .where('taskDesc', isEqualTo: task.description);
    return taskQuery.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
