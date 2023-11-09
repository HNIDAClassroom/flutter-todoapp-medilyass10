import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore.dart';
import 'task_item.dart';

class TasksList extends StatelessWidget {
  TasksList({super.key, required List<Task> tasks});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        final taskLists = snapshot.data!.docs;
        List<Task> taskItems = [];
        for (int index = 0; index < taskLists.length; index++) {
          DocumentSnapshot document = taskLists[index];
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String title = data['taskTitle'];
          String description = data['taskDesc'];
          DateTime date = DateTime.parse(data['taskDate']);
          String categoryString = data['taskCategory'];
          Category category;
          switch (categoryString) {
            case 'Category.personal':
              category = Category.personal;
              break;

            case 'Category.work':
              category = Category.work;
              break;
            case 'Category.shopping':
              category = Category.shopping;
              break;
            default:
              category = Category.others;
          }
          Task task = Task(
            title: title,
            description: description,
            date: date,
            category: category,
          );
          taskItems.add(task);
        }
        return ListView.builder(
          itemCount: taskItems.length,
          itemBuilder: (ctx, index) {
            return TaskItem(taskItems[index]);
          },
        );
      },
    );
  }
}
