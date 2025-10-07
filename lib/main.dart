import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodo/constants/theme.dart';
import 'package:mytodo/pages/main_page.dart';
import 'package:mytodo/providers/notifires.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox("TODO");
  // ignore: unused_local_variable
  var box2 = await Hive.openBox("NOTES");

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      // Dark theme
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: MainPage(),
    );
  }
}
