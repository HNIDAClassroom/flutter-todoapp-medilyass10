import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/models/task.dart';
import 'dart:ui' as ui;

import 'package:todolist_app/services/firestore.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});
  final Task task;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final firestoreService = FirestoreService();
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.task.description,
                  softWrap: true,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(widget.task.category.toString(),
                      textDirection: ui.TextDirection.rtl),
                  Text(DateFormat.yMMMd().format(widget.task.date))
                ],
              ),
            ),
            if (isHovered)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(),
                ),
              ),
            if (isHovered)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _onDeletePressed();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  _onDeletePressed() {
    firestoreService.deleteTask(widget.task);
  }
}
