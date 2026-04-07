import 'dart:async';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import 'add_edit_note_screen.dart';
import 'auth_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final NotesService _notesService = NotesService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  List<Note> _filteredNotes = [];
  Timer? _autoLockTimer;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _startAutoLockTimer();
  }

  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();
    _autoLockTimer = Timer(const Duration(minutes: 5), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    });
  }

  void _resetAutoLockTimer() {
    _startAutoLockTimer();
  }

  Future<void> _loadNotes() async {
    await _notesService.loadNotes();
    _filteredNotes = _notesService.notes;
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _searchNotes(String query) {
    setState(() {
      _filteredNotes = _notesService.searchNotes(query);
    });
  }

  String _preview(String text) {
    if (text.length <= 70) return text;
    return '${text.substring(0, 70)}...';
  }

  String _formatDate(DateTime date) {
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} ${date.hour}:$minute';
  }

  Future<void> _addNote() async {
    _resetAutoLockTimer();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditNoteScreen(notesService: _notesService),
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  Future<void> _editNote(Note note) async {
    _resetAutoLockTimer();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditNoteScreen(
          note: note,
          notesService: _notesService,
        ),
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  Future<void> _deleteNote(String id) async {
    _resetAutoLockTimer();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _notesService.deleteNote(id);
      await _loadNotes();
    }
  }

  Future<void> _togglePin(Note note) async {
    _resetAutoLockTimer();
    await _notesService.togglePin(note.id);
    await _loadNotes();
  }

  Future<void> _logout() async {
    _resetAutoLockTimer();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _autoLockTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetAutoLockTimer,
      onPanDown: (_) => _resetAutoLockTimer(),
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9FE),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Secure Notes',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Your private encrypted notes',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _logout,
                                tooltip: 'Logout',
                                icon: const Icon(Icons.logout_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _searchController,
                            onChanged: _searchNotes,
                            decoration: const InputDecoration(
                              hintText: 'Search notes...',
                              prefixIcon: Icon(Icons.search_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _filteredNotes.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE9FE),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: const Icon(
                                        Icons.note_alt_outlined,
                                        size: 42,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'No notes yet',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Tap the add button to create your first secure note.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 100),
                              itemCount: _filteredNotes.length,
                              itemBuilder: (context, index) {
                                final note = _filteredNotes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(18),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            note.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        if (note.isPinned)
                                          const Icon(
                                            Icons.push_pin_rounded,
                                            size: 18,
                                            color: Color(0xFF4F46E5),
                                          ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _preview(note.content),
                                            style: const TextStyle(
                                              color: Color(0xFF6B7280),
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            _formatDate(note.lastEdited),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => _editNote(note),
                                    onLongPress: () => _deleteNote(note.id),
                                    trailing: IconButton(
                                      onPressed: () => _togglePin(note),
                                      icon: Icon(
                                        note.isPinned
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        color: note.isPinned
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addNote,
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Note'),
        ),
      ),
    );
  }
}