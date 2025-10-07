import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class NotesDatabase {
  late Box _box;

  NotesDatabase() {
    _box = Hive.box("NOTES");
  }

  List<Note> loadNotes() {
    final data = _box.get('NOTES');
    if (data == null) {
      final initialNote = Note(
        title: "Welcome to Notes ⭐",
        body: "Welcome to Notes! Start creating your notes here.",
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      saveNotes([initialNote]);
      return [initialNote];
    } else {
      return (data as List)
          .map((item) => Note.fromList(item as List<dynamic>))
          .toList();
    }
  }

  void saveNotes(List<Note> notes) {
    _box.put('NOTES', notes.map((note) => note.toList()).toList());
  }

  String getFormattedTime(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
