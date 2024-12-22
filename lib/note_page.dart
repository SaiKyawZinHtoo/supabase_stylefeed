import 'package:flutter/material.dart';
import 'package:superbase_project/note.dart';
import 'package:superbase_project/note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //notes db
  final notesDatabase = NoteDatabase();

  //text controller
  final textController = TextEditingController();

  // user wants to create a new note
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Notes"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
          //save button
          TextButton(
            onPressed: () {
              //create a new note
              final newNote = Note(
                content: textController.text,
              );
              //save in db
              notesDatabase.createNote(newNote);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // user wants to update a note

  // user wants to delete a note

  //Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: Text("Notes"),
      ),
      //button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
