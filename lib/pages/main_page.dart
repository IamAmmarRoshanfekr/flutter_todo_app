import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodo/pages/home_page.dart';
import 'package:mytodo/pages/notes_page.dart';
import 'package:mytodo/pages/tasks_page.dart';
import 'package:mytodo/providers/riverpod.dart';
import 'package:mytodo/widgets/app_drawer.dart';

List<String> pageLabels = ["Home", "Tasks", "Notes"];

List<Widget> pages = [HomePage(), TasksPage(), NotesPage()];

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController _pageController = PageController();

    final theme = Theme.of(context);

    void onTap(index) {
      ref.read(selectedIndex.notifier).state = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300), // animation speed
        curve: Curves.easeInOut, // animation curve
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageLabels[ref.watch(selectedIndex)]),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(selectedIndex),
        onTap: (index) => onTap(index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: pageLabels[0]),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: pageLabels[1]),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: pageLabels[2],
            backgroundColor: theme.colorScheme.error,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (value) =>
            ref.read(selectedIndex.notifier).state = value,
      ),
    );
  }
}
