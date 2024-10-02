import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notesapp/MainScreen/MainScreen.dart';
import 'package:notesapp/hive_helper.dart';

import 'Notecubit/note_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  print(0);
  await Hive.initFlutter(); // Initialize Hive
  print(0.1);
  await Hive.openBox(NoteHiveHelper.noteBox); // Open note box
  print(0.2);
  await Hive.openBox(NoteHiveHelper.textBox); // Open text box
  print(0.3);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context)  => NoteCubit()..getTexts()..getNotes(),
      child: MaterialApp(
        color: Colors.white,
        home: Mainscreen(),
      ),
    );
  }

}