import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../hive_helper.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());
  void initState() {
    NoteHiveHelper.getNotes();
  }

  void deletenote (int index , BuildContext Context){
  NoteHiveHelper.removeNote(index);
  Navigator.pop(Context);
  emit(removeNoteState());

/*
  setState(() {});
*/
  }

 void addNote(TextEditingController _textFieldController,BuildContext Context ){
  final noteText = _textFieldController.text ?? " ";
  if (_textFieldController.text.isNotEmpty) {
  NoteHiveHelper.addNote(noteText);}
  else {
  _textFieldController.text="";
  }
  Navigator.pop(Context);
  emit(AddNoteState());


 }
  void saveText (TextEditingController _textFieldController,String item){
    NoteHiveHelper.saveText( _textFieldController, item);
    emit(updateNoteState());
  }
  void RemoveText (TextEditingController _textFieldController,String item){
    NoteHiveHelper.RemoveText( _textFieldController, item);
    emit(updateNoteState());
  }
 void updateNote(TextEditingController _textFieldController,BuildContext Context,int index){
  if (_textFieldController.text.isNotEmpty) {
    NoteHiveHelper.updateNote(index: index, text: _textFieldController.text);
  }
  else {
    _textFieldController.text="";
  }
  Navigator.pop(Context);
  emit(updateNoteState());
}

 void deleteallNotes(){
    NoteHiveHelper.removeAllNote();
    emit(removeAllNoteState());
}
void getNotes ()async{
    emit(LoadingState());

    await Future.delayed(Duration(seconds: 1));
   try{
     NoteHiveHelper.getNotes();
     Get.snackbar(
       "GeeksforGeeks",
       "Hello everyone",
       icon: Icon(Icons.person, color: Colors.white),
       snackPosition: SnackPosition.BOTTOM,
     );
     emit(SuccsessState());
   }
   catch(e){
     Get.snackbar("Error", "Please Check Your Network ");
     emit(FaliuerState(e.toString()));
      }
}
Future<void> getTexts ()async{
    emit(LoadingState());

   try{
     NoteHiveHelper.gettext();
     Get.snackbar(
       "GeeksforGeeks",
       "Hello everyone",
       icon: Icon(Icons.person, color: Colors.white),
       snackPosition: SnackPosition.BOTTOM,
     );
     emit(SuccsessState());
   }
   catch(e){
     Get.snackbar("Error", "Please Check Your Network ");
     emit(FaliuerState(e.toString()));
      }
}



}
