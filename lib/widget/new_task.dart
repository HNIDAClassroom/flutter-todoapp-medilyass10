import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/services/firestore.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key, required this.onAddTask});
  final void Function(Task task) onAddTask;

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  Category _selectedCategory = Category.personal;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final FirestoreService firestoreService = FirestoreService();

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_titleController.text.isEmpty ||
            _descriptionController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Erreur'),
              content: const Text(
                  'Merci de saisir le titre et ladescription de la tâche à ajouter dans la liste'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else {
          final newTask = Task(
              title: _titleController.text.toString(),
              description: _descriptionController.text.toString(),
              date: _selectedDate,
              category: _selectedCategory);

          setState(() {
            firestoreService.addTask(newTask);
            Navigator.pop(context);
          });
        }
      },
      child: const Text('Enregistrer'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            DropdownButton<Category>(
              value: _selectedCategory,
              items: Category.values
                  .map(
                    (category) => DropdownMenuItem<Category>(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
