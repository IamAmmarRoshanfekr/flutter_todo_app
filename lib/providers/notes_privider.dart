import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../data/notes_database.dart';

class NotesNotifier extends Notifier<List<Note>> {
  late NotesDatabase _db;

  @override
  List<Note> build() {
    _db = NotesDatabase();
    return _db.loadNotes();
  }

  void addNote(String title, String body) {
    final now = DateTime.now().toIso8601String();
    final newNote = Note(
      title: title,
      body: body,
      createdAt: now,
      updatedAt: now,
    );
    state = [...state, newNote];
    _db.saveNotes(state);
  }

  void updateNote(int index, String title, String body) {
    if (index >= 0 && index < state.length) {
      final updatedNote = Note(
        title: title,
        body: body,
        createdAt: state[index].createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );
      state = [
        ...state.sublist(0, index),
        updatedNote,
        ...state.sublist(index + 1),
      ];
      _db.saveNotes(state);
    }
  }

  void deleteNote(int index) {
    if (index >= 0 && index < state.length) {
      state = [
        ...state.sublist(0, index),
        ...state.sublist(index + 1),
      ];
      _db.saveNotes(state);
    }
  }

  String getFormattedTime(String isoString) {
    return _db.getFormattedTime(isoString);
  }
}

final notesProvider = NotifierProvider<NotesNotifier, List<Note>>(() {
  return NotesNotifier();
});