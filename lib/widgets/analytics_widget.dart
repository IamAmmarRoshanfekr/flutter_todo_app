import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';

typedef TasksCompletedOnDate = int Function(DateTime);

class AnalyticsWidget extends StatelessWidget {
  final int completedTasks;
  final int streak;
  final TasksCompletedOnDate getTasksCompletedOnDate;

  const AnalyticsWidget({
    super.key,
    required this.completedTasks,
    required this.streak,
    required this.getTasksCompletedOnDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Activity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$completedTasks tasks completed',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    AnimatedEmoji(AnimatedEmojis.fire),
                    SizedBox(width: 4),
                    Text(
                      '$streak day streak',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          _buildMonthlyCalendar(context),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendar(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getMonthName(currentMonth.month),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 6),
            Text(
              '${currentMonth.year}',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 6),

        // Calendar grid
        _buildCalendarGrid(currentMonth, context),

        SizedBox(height: 10),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Less',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
            SizedBox(width: 6),
            _buildLegendBox(
              theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey[200]!,
            ),
            SizedBox(width: 3),
            _buildLegendBox(theme.colorScheme.primary.withOpacity(0.3)),
            SizedBox(width: 3),
            _buildLegendBox(theme.colorScheme.primary.withOpacity(0.6)),
            SizedBox(width: 3),
            _buildLegendBox(theme.colorScheme.primary),
            SizedBox(width: 6),
            Text(
              'More',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(DateTime month, BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    List<Widget> weeks = [];
    List<Widget> currentWeek = [];

    // Empty cells for offset
    for (int i = 0; i < startWeekday; i++) {
      currentWeek.add(Expanded(child: SizedBox(height: 32)));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final isToday =
          date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      final isFuture = date.isAfter(DateTime.now());
      final tasksCompleted = getTasksCompletedOnDate(date);

      currentWeek.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!isFuture) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${date.day}/${date.month}/${date.year}: $tasksCompleted ${tasksCompleted == 1 ? 'task' : 'tasks'}',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Container(
              height: 32,
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isFuture
                    ? Colors.transparent
                    : _getActivityColor(tasksCompleted, theme),
                borderRadius: BorderRadius.circular(6),
                border: isToday
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : Border.all(color: theme.focusColor, width: 1),
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isFuture
                        ? theme.textTheme.bodySmall?.color?.withOpacity(0.3)
                        : tasksCompleted > 0
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if ((startWeekday + day) % 7 == 0 || day == daysInMonth) {
        if (day == daysInMonth) {
          while (currentWeek.length < 7) {
            currentWeek.add(Expanded(child: SizedBox(height: 32)));
          }
        }
        weeks.add(Row(children: currentWeek));
        currentWeek = [];
      }
    }

    return Column(children: weeks);
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Color _getActivityColor(int count, ThemeData theme) {
    if (count == 0) {
      return theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(0.1)
          : Colors.grey[200]!;
    } else if (count <= 2) {
      return theme.colorScheme.primary.withOpacity(0.3);
    } else if (count <= 4) {
      return theme.colorScheme.primary.withOpacity(0.6);
    } else {
      return theme.colorScheme.primary;
    }
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
