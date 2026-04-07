import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/notes_service.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  final NotesService notesService;

  const AddEditNoteScreen({
    super.key,
    this.note,
    required this.notesService,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    if (isEditing) {
      final updatedNote = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        isPinned: widget.note!.isPinned,
        lastEdited: DateTime.now(),
      );
      await widget.notesService.updateNote(updatedNote);
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        lastEdited: DateTime.now(),
      );
      await widget.notesService.addNote(newNote);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Note title',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Write your secure note here...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Note'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}