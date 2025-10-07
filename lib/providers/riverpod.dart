import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeMode = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

final selectedIndex = StateProvider<int>((ref) => 0);
final textBody = StateProvider<String>((ref) => "");
