import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notesapp/MainScreen/MainScreen.dart';
import 'package:notesapp/hive_helper.dart';

import 'Notecubit/note_cubit.dart';

void main() async{
  await Hive.initFlutter();
   var Box = await Hive.openBox(NoteHiveHelper.noteBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context)  => NoteCubit()..getNotes(),
      child: MaterialApp(
        color: Colors.white,
        home: Mainscreen(),
      ),
    );
  }

}