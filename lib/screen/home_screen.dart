import 'package:flutter/material.dart';

import '../widgets/add_task_dialog.dart';
class StudyFlowHome extends StatefulWidget {
  const StudyFlowHome({super.key});

  @override
  State<StudyFlowHome> createState() => _StudyFlowHomeState();
}

class _StudyFlowHomeState extends State<StudyFlowHome> {
  List<Map<String, dynamic>> tasks = [];

  void addTask(Map<String, dynamic> taskData) {
    setState(() {
      tasks.add({
        "title": taskData["title"],
        "date": taskData["date"],
        "done": false,
      });
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]["done"] = !tasks[index]["done"];
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    int doneCount = tasks
        .where((t) => t["done"] == true)
        .length;
    return doneCount / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text("StudyFlow" , style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );

          if (result != null) {
            addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "My Tasks",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                tasks.isEmpty
                    ? "No tasks for today"
                    : "You have ${tasks.length} tasks to crush today.",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff4F8CFF),
                      Color(0xff6EA8FE),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TASK PROGRESS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% Complete",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Column(
                children: tasks
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  var task = entry.value;

                  bool isDone = task["done"];

                  return GestureDetector(
                    onTap: () => toggleTask(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isDone
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isDone ? Colors.green : Colors.grey,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isDone
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Due: ${task["date"]}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}