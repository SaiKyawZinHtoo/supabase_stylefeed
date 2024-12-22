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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
            onPressed: () async {
              //create a new note
              final newNote = Note(
                content: textController.text,
              );
              //save in db
              await notesDatabase.createNote(newNote);
              Navigator.pop(context);
              textController.clear();
              setState(() {}); // Update the UI
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // user wants to update a note
  void updateNote(Note note) {
    textController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Updated Notes"),
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
            onPressed: () async {
              await notesDatabase.updateNote(note, textController.text);
              Navigator.pop(context);
              textController.clear();
              setState(() {}); // Update the UI
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // user wants to delete a note
  void deleteNote(Note note) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Notes"),
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
            onPressed: () async {
              await notesDatabase.delete(note);
              Navigator.pop(context);
              textController.clear();
              setState(() {}); // Update the UI
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  //Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: Text("Notes"),
      ),
      //body -> StreamBuilder
      body: StreamBuilder<List<Note>>(
          stream: notesDatabase.stream,
          builder: (context, snapshot) {
            //loading..
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //loading!
            final notes = snapshot.data!;

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
                          onPressed: () => deleteNote(note),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      //button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
