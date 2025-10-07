import 'package:flutter/material.dart';
import 'package:mytodo/constants/quotes.dart';
import 'package:mytodo/data/todo_database.dart';
import 'package:mytodo/widgets/analytics_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mytodo/widgets/quote_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box("TODO");

  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    if (box.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final randomQuote = getRandomQuote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<int> uncompletedIndices = [];
    List<int> completedIndices = [];

    for (int i = 0; i < db.todoList.length; i++) {
      if (db.todoList[i][1] == true) {
        completedIndices.add(i);
      } else {
        uncompletedIndices.add(i);
      }
    }

    // Calculate analytics
    int completedTasks = completedIndices.length;

    return ListView(
      children: [
        QuoteWidget(),
        AnalyticsWidget(
          completedTasks: completedTasks,
          streak: _getCurrentStreak(),
          getTasksCompletedOnDate: _getTasksCompletedOnDate,
        ),
      ],
    );
  }

  int _getTasksCompletedOnDate(DateTime date) {
    int count = 0;
    for (var task in db.todoList) {
      if (task.length >= 4 && task[1] == true && task[3] != null) {
        try {
          DateTime completionDate = DateTime.parse(task[3]);
          if (completionDate.year == date.year &&
              completionDate.month == date.month &&
              completionDate.day == date.day) {
            count++;
          }
        } catch (e) {
          // Skip if date parsing fails
        }
      }
    }
    return count;
  }

  int _getCurrentStreak() {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      int tasksCompleted = _getTasksCompletedOnDate(date);

      if (tasksCompleted > 0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
