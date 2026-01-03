import 'package:flutter/material.dart';
import '../components/task_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': 'Recycle a bottle',
        'points': 80,
        'description': 'Find a recycle bin and check in to earn a big bonus.'
      },
      {
        'title': 'General waste patrol',
        'points': 50,
        'description': 'Dispose general waste and keep the city clean.'
      },
      {
        'title': 'Visit a green spot',
        'points': 30,
        'description': 'Walk to a trash-monster marker and check in.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Tasks'),
        backgroundColor: const Color(0xFF28C76F),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            title: task['title'] as String,
            description: task['description'] as String,
            points: task['points'] as int,
          );
        },
      ),
    );
  }
}
