import 'dart:convert';
import '../models/note.dart';
import '../utils/encryption_helper.dart';
import 'secure_storage_service.dart';

class NotesService {
  List<Note> _notes = [];

  List<Note> get notes {
    final copied = List<Note>.from(_notes);
    copied.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return b.isPinned ? 1 : -1;
      }
      return b.lastEdited.compareTo(a.lastEdited);
    });
    return copied;
  }

  Future<void> loadNotes() async {
    final encryptedJson = await SecureStorageService.loadNotes();
    if (encryptedJson == null || encryptedJson.isEmpty) {
      _notes = [];
      return;
    }

    final decryptedJson = EncryptionHelper.decrypt(encryptedJson);
    final List<dynamic> decoded = jsonDecode(decryptedJson);
    _notes = decoded.map((item) => Note.fromJson(item)).toList();
  }

  Future<void> _saveNotes() async {
    final jsonString = jsonEncode(_notes.map((n) => n.toJson()).toList());
    final encrypted = EncryptionHelper.encrypt(jsonString);
    await SecureStorageService.saveNotes(encrypted);
  }

  Future<void> addNote(Note note) async {
    _notes.insert(0, note);
    await _saveNotes();
  }

  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      await _saveNotes();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _saveNotes();
  }

  Future<void> togglePin(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].isPinned = !_notes[index].isPinned;
      _notes[index].lastEdited = DateTime.now();
      await _saveNotes();
    }
  }

  List<Note> searchNotes(String query) {
    if (query.trim().isEmpty) return notes;

    final lower = query.toLowerCase();
    return notes.where((note) {
      return note.title.toLowerCase().contains(lower) ||
          note.content.toLowerCase().contains(lower);
    }).toList();
  }
}