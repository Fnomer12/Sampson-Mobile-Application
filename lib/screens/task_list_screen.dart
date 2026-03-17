import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    titleController.dispose();
    courseCodeController.dispose();
    super.dispose();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedTasks = prefs.getStringList('tasks');

    if (savedTasks != null && savedTasks.isNotEmpty) {
      setState(() {
        tasks = savedTasks.map((taskString) {
          final Map<String, dynamic> taskMap = jsonDecode(taskString);
          return Task(
            title: taskMap['title'],
            courseCode: taskMap['courseCode'],
            dueDate: DateTime.parse(taskMap['dueDate']),
            isComplete: taskMap['isComplete'],
          );
        }).toList();
      });
    } else {
      setState(() {
        tasks = [
          Task(
            title: 'Study Flutter Widgets',
            courseCode: 'DCIT 318',
            dueDate: DateTime(2026, 3, 20),
          ),
          Task(
            title: 'Submit Midsem Project',
            courseCode: 'DCIT 308',
            dueDate: DateTime(2026, 3, 25),
          ),
          Task(
            title: 'Read About Firebase',
            courseCode: 'DCIT 315',
            dueDate: DateTime(2026, 3, 28),
          ),
        ];
      });
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskStrings = tasks.map((task) {
      return jsonEncode({
        'title': task.title,
        'courseCode': task.courseCode,
        'dueDate': task.dueDate.toIso8601String(),
        'isComplete': task.isComplete,
      });
    }).toList();

    await prefs.setStringList('tasks', taskStrings);
  }

  Future<void> pickDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void showAddTaskDialog() {
    titleController.clear();
    courseCodeController.clear();
    selectedDate = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                    ),
                    TextField(
                      controller: courseCodeController,
                      decoration: const InputDecoration(labelText: 'Course Code'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime now = DateTime.now();
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('Pick Due Date'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDate == null
                          ? 'No date selected'
                          : 'Selected: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    courseCodeController.text.isNotEmpty &&
                    selectedDate != null) {
                  setState(() {
                    tasks.add(
                      Task(
                        title: titleController.text,
                        courseCode: courseCodeController.text,
                        dueDate: selectedDate!,
                      ),
                    );
                  });

                  await saveTasks();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void toggleTask(int index, bool? value) async {
    setState(() {
      tasks[index].isComplete = value ?? false;
    });
    await saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(task.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Course Code: ${task.courseCode}'),
                  Text(
                    'Due Date: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                  ),
                ],
              ),
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: (value) => toggleTask(index, value),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}