part of 'note_cubit.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}
final class AddNoteState extends NoteState {}
final class removeNoteState extends NoteState {}
final class updateNoteState extends NoteState {}
final class removeAllNoteState extends NoteState {}
final class LoadingState extends NoteState {


}
final class SuccsessState extends NoteState {}
final class FaliuerState extends NoteState {
  final String error ;
  FaliuerState(this.error);
}
