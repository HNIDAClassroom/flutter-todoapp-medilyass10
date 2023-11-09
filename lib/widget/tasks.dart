import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/widget/new_task.dart';
import 'package:todolist_app/widget/tasks_list.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService = FirestoreService();
  final List<Task> _registeredTasks = [
    // Task(
    //   title: 'Apprendre Flutter',
    //   description: 'Suivre le cours pour apprendre de nouvelles compétences',
    //   date: DateTime.now(),
    //   category: Category.work,
    // ),
    // Task(
    //   title: 'Faire les courses',
    //   description: 'Acheter des provisions pour la semaine',
    //   date: DateTime.now().subtract(Duration(days: 1)),
    //   category: Category.shopping,
    // ),
    // Task(
    //   title: 'Rediger un CR',
    //   description: '',
    //   date: DateTime.now().subtract(Duration(days: 2)),
    //   category: Category.personal,
    // ),
  ];

  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  void _addTask(Task task) async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _registeredTasks.add(task);
    });
    Navigator.pop(context);
  }

  void _deleteTask(Task task) {
    setState(() {
      _registeredTasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ToDoList'),
        actions: [
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: TasksList(tasks: _registeredTasks))],
      ),
    );
  }
}
