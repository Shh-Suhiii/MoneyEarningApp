import 'package:flutter/material.dart';
import 'package:earnmoney/theme/app_colors.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Map<String, dynamic>> tasks = [
    {"title": "Complete Survey", "points": 50, "completed": false},
    {"title": "Watch Video", "points": 20, "completed": false},
    {"title": "Install App", "points": 100, "completed": false},
    {"title": "Sign Up", "points": 75, "completed": false},
  ];

  int get completedTasksCount => tasks.where((task) => task['completed']).length;
  int get totalPoints => tasks.map((task) => task['points'] as int).reduce((a, b) => a + b);
  int get earnedPoints => tasks.where((task) => task['completed'])
      .map((task) => task['points'] as int)
      .fold(0, (a, b) => a + b);

  void completeTask(int index) {
    setState(() {
      tasks[index]['completed'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Tasks", 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Total Points: $totalPoints',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Task Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: completedTasksCount / tasks.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: 10),
                Text(
                  '$completedTasksCount/${tasks.length} Tasks Completed',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Earned Points: $earnedPoints',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8
                    ),
                    title: Text(
                      tasks[index]['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tasks[index]['completed'] 
                          ? Colors.grey 
                          : Colors.black87
                      ),
                    ),
                    subtitle: Text(
                      "${tasks[index]['points']} Points",
                      style: TextStyle(
                        color: tasks[index]['completed'] 
                          ? Colors.grey 
                          : AppColors.secondary
                      ),
                    ),
                    trailing: tasks[index]['completed']
                      ? Icon(
                          Icons.check_circle, 
                          color: Colors.green, 
                          size: 30
                        )
                      : ElevatedButton(
                          onPressed: () => completeTask(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 8
                            )
                          ),
                          child: Text(
                            "Complete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}