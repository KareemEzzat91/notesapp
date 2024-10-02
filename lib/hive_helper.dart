import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class NoteHiveHelper {
  static const String noteBox = "NOTE_BOX";
  static const String textBox = "TEXT_BOX"; // Fixed naming convention
  static List<String> myNotes = [];
  static Map<dynamic, dynamic> mytexts = {};

  // Add Note
  static void addNote(String text) {
    myNotes.add(text);
    mytexts[text] = ''; // Initialize with an empty string for the note
    Hive.box(noteBox).put(noteBox, myNotes);
    Hive.box(textBox).put(textBox, mytexts);
  }

  // Save text to the Map and Hive box
  static Future<void> saveText(TextEditingController controller, String item) async {
    mytexts[item] = controller.text;
    Hive.box(textBox).put(textBox, mytexts);
  }
  static Future<void> RemoveText(TextEditingController controller, String item) async {
    mytexts[item] = "";
    Hive.box(textBox).put(textBox, mytexts);
  }

  // Fetch notes from Hive
  static Future<void> getNotes() async {
    myNotes = await Hive.box(noteBox).get(noteBox, defaultValue: []);
  }

  // Fetch text entries from Hive
  static Future<void> gettext() async {
    mytexts = await Hive.box(textBox).get(textBox, defaultValue: {});
  }

  // Remove a note by index
  static void removeNote(int index) {
    myNotes.removeAt(index);
    Hive.box(noteBox).put(noteBox, myNotes);
  }

  // Remove all notes
  static void removeAllNote() {
    myNotes.clear();
    mytexts.clear(); // Also clear the text entries
    Hive.box(noteBox).put(noteBox, myNotes);
    Hive.box(textBox).put(textBox, mytexts);
  }

  // Update a note by index
  static void updateNote({
    required int index,
    required String text,
  }) {
    myNotes[index] = text;
    Hive.box(noteBox).put(noteBox, myNotes);
  }
}
