import 'package:hive/hive.dart';

class TodoDatabase {
  List todoList = [];

  final myBox = Hive.box("TODO");

  void createInitialData() {
    todoList = [
      [
        "Welcome to My Todo App ⭐",
        false,
        DateTime.now().toIso8601String(),
        null, // completion date
      ],
    ];
  }

  void loadData() {
    todoList = myBox.get('TODOLIST');

    // Handle old formats
    for (int i = 0; i < todoList.length; i++) {
      if (todoList[i].length == 2) {
        // Old format: add created date and completion date
        todoList[i].add(DateTime.now().toIso8601String());
        todoList[i].add(null);
      } else if (todoList[i].length == 3) {
        // Missing completion date
        todoList[i].add(null);
      }
    }
  }

  void updateData() {
    myBox.put("TODOLIST", todoList);
  }

  // Mark task as completed with timestamp
  void completeTask(int index) {
    if (index < todoList.length) {
      todoList[index][1] = true;
      todoList[index][3] = DateTime.now().toIso8601String();
      updateData();
    }
  }

  // Mark task as uncompleted
  void uncompleteTask(int index) {
    if (index < todoList.length) {
      todoList[index][1] = false;
      todoList[index][3] = null;
      updateData();
    }
  }

  // Helper method to get formatted time
  String getFormattedTime(int index) {
    if (index < todoList.length && todoList[index].length >= 3) {
      DateTime dateTime = DateTime.parse(todoList[index][2]);
      return _formatDateTime(dateTime);
    }
    return '';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Format as date
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
