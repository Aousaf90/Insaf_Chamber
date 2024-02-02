import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

String taskValue = "";

class _ReminderPageState extends State<ReminderPage> {
  final List<Task> tasks = [
    Task(
      title: 'Document all the Files of Nouman Case',
      dueDate: DateTime.now().add(Duration(days: 1)),
      isCompleted: false,
    ),
    Task(
      title: 'Call the Client',
      dueDate: DateTime.now().add(Duration(days: 2)),
      isCompleted: false,
    ),
    Task(
      title: 'Finish the final Hearing',
      dueDate: DateTime.now().add(Duration(days: 3)),
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              leading: Icon(task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outlined),
              subtitle: Text(task.dueDate.toString()),
              onTap: () {
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add new task
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Task'),
                content: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      taskValue = value;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Enter task title'),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      tasks.add(Task(
                        title: taskValue,
                        dueDate: DateTime.now().add(Duration(days: 1)),
                        isCompleted: false,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class Task {
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.dueDate,
    required this.isCompleted,
  });
}
