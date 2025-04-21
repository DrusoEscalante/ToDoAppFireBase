import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String id;
  final TextEditingController controller;

  Task({required this.id, required this.controller});
}

class secondPage extends StatefulWidget {
  const secondPage({super.key, required this.title});

  final String title;

  @override
  State<secondPage> createState() => _secondPage();
}

class _secondPage extends State<secondPage> {
  final List<Task> _tasks = [];
  final Uuid uuid = Uuid();


  // Method to save tasks to shared preferences
  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = _tasks.map((task) => task.controller.text).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void _createCard() {
    setState(() {
      String taskId = uuid.v4();
      TextEditingController controller = TextEditingController();

      _tasks.add(Task(id: taskId, controller: controller));
    });
  }

  void _saveToFirestore(String text) async {
    if (text.isEmpty) return;

    await FirebaseFirestore.instance.collection('task').add({
      'task': text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _createCard();
            },
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.black87,
        title: Text("Todo List", style: TextStyle(color: Colors.white)),
      ),
      body: _tasks.isEmpty
          ? Center(child: Text("No current tasks!"))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final item = _tasks[index];
          return Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              setState(() {
                _tasks.removeAt(index);
                _saveTasks();  // Save after task is removed
              });
            },
            child: Card(
              color: Colors.red,
              elevation: 10,
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: item.controller,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black87),
                        hintText: "Enter Task",
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _saveToFirestore(item.controller.text);
                        _saveTasks();  // Save after each task is saved
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
