import 'package:flutter/material.dart';
import 'package:superbase_project/note.dart';
import 'package:superbase_project/note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // Notes database
  final notesDatabase = NoteDatabase();

  // Text controller
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Add a new note
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("New Note"),
              content: TextField(
                controller: textController,
                autofocus: true,
                onChanged: (value) {
                  // Trigger a rebuild to enable/disable the Save button
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Enter your note here...",
                ),
              ),
              actions: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                ),
                // Save button
                TextButton(
                  onPressed: textController.text.trim().isEmpty
                      ? null
                      : () async {
                          try {
                            final newNote = Note(
                              content: textController.text.trim(),
                            );
                            await notesDatabase.createNote(newNote);
                            Navigator.pop(context);
                            textController.clear();
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Note added successfully!")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to add note: $e")),
                            );
                          }
                        },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Update a note
  void updateNote(Note note) {
    textController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Edit your note...",
          ),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
          // Save button
          TextButton(
            onPressed: textController.text.trim().isEmpty
                ? null
                : () async {
                    try {
                      await notesDatabase.updateNote(
                          note, textController.text.trim());
                      Navigator.pop(context);
                      textController.clear();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Note updated successfully!")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to update note: $e")),
                      );
                    }
                  },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Confirm before deleting a note
  void confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // Delete button
          TextButton(
            onPressed: () async {
              try {
                await notesDatabase.delete(note);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note deleted successfully!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to delete note: $e")),
                );
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: StreamBuilder<List<Note>>(
        stream: notesDatabase.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return const Center(
              child: Text("No notes yet. Tap + to add a new note."),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.content),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => updateNote(note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => confirmDelete(note),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }
}
