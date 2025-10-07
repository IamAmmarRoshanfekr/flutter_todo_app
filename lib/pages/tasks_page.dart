import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mytodo/data/todo_database.dart';
import 'package:mytodo/widgets/task_stat_card.dart';

void _showDialog(
  BuildContext context,
  TextEditingController controller,
  VoidCallback onSave,
  VoidCallback onCancel,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Add Task"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hint: Text("Task Title")),
        ),
        actions: [
          TextButton(onPressed: onCancel, child: Text("Close")),
          FilledButton(onPressed: onSave, child: Text("Save")),
        ],
      );
    },
  );
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController controller = TextEditingController();

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onCheck(bool? value, int index) {
    setState(() {
      if (value == true) {
        db.completeTask(index);
      } else {
        db.uncompleteTask(index);
      }
    });
  }

  void onSave() {
    setState(() {
      if (controller.text == '') {
        db.todoList.add([
          'Undefined Task',
          false,
          DateTime.now().toIso8601String(),
          null,
        ]);
      } else {
        db.todoList.add([
          controller.text,
          false,
          DateTime.now().toIso8601String(),
          null,
        ]);
      }
      db.updateData();
      controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onCancel() {
    controller.clear();
    Navigator.of(context).pop();
  }

  void onDelete(int index) {
    setState(() {
      db.todoList.removeAt(index);
      db.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Separate tasks into completed and uncompleted
    List<int> uncompletedIndices = [];
    List<int> completedIndices = [];

    for (int i = 0; i < db.todoList.length; i++) {
      if (db.todoList[i][1] == true) {
        completedIndices.add(i);
      } else {
        uncompletedIndices.add(i);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context, controller, onSave, onCancel),
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // Activity Calendar Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Completed
                    Expanded(
                      child: TaskStatCard(
                        label: 'Done',
                        count: completedIndices.length,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),

                    SizedBox(width: 10),

                    // Active
                    Expanded(
                      child: TaskStatCard(
                        label: 'Active',
                        count: uncompletedIndices.length,
                        color: Colors.orange,
                        icon: Icons.pending_actions,
                      ),
                    ),

                    SizedBox(width: 10),

                    // Total
                    Expanded(
                      child: TaskStatCard(
                        label: 'Total',
                        count: db.todoList.length,
                        color: Colors.blue,
                        icon: Icons.list_alt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Active Tasks Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Active Tasks (${uncompletedIndices.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          // Active Tasks List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              int taskIndex = uncompletedIndices[index];
              return _buildTaskTile(context, theme, taskIndex);
            }, childCount: uncompletedIndices.length),
          ),
          // Completed Tasks Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Completed Tasks (${completedIndices.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          // Completed Tasks List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                int taskIndex =
                    completedIndices[completedIndices.length - 1 - index];
                return _buildTaskTile(context, theme, taskIndex);
              },
              childCount: completedIndices.length > 10
                  ? 10
                  : completedIndices.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, ThemeData theme, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.primaryColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Checkbox(
              value: db.todoList[index][1],
              onChanged: (value) => onCheck(value, index),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${db.todoList[index][0]}",
                    style: TextStyle(
                      decoration: db.todoList[index][1]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    db.getFormattedTime(index),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onDelete(index),
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
