import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


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
                _tasks.removeAt(index);// Save after task is removed
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
                         // Save after each task is saved
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
