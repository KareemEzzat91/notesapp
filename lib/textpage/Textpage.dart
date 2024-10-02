import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../MainScreen/MainScreen.dart';
import '../Notecubit/note_cubit.dart';
import '../hive_helper.dart';

class Textpage extends StatefulWidget {
  final String item;

  const Textpage({Key? key, required this.item}) : super(key: key);

  @override
  _TextpageState createState() => _TextpageState();
}

class _TextpageState extends State<Textpage> {
  late Future<void> _initFuture;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFuture = context.read<NoteCubit>().getTexts();
    _initFuture.then((_) {
      setState(() {
        _controller.text = NoteHiveHelper.mytexts[widget.item]?.toString() ?? "dddddddddddd";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (BuildContext context, NoteState state) {
        final bloc = context.read<NoteCubit>();
        if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              backgroundColor: Colors.white,
            ),
          );
        }
        if (state is FaliuerState) {
          return const Center(
            child: Text(
              "Error ",
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }

              final bool shouldPop = await _showdialog() ?? false;
              if (context.mounted && shouldPop) {
                bloc.saveText(_controller, widget.item);
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              appBar: buildAppBar(context),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Start typing your note...',
                  ),
                ),
              ),
              floatingActionButton: myButton(context),
            ),
          );
        }
      },
    );
  }

  bool _showdialog() {
    return true ;
  }

  AppBar buildAppBar(BuildContext context) {
    final bloc = context.read<NoteCubit>();

    return AppBar(
      backgroundColor: Colors.orange,
      title: Text(
        widget.item,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.red,
              blurRadius: 10.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Do You Want to delete All Text?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        bloc.RemoveText(_controller, widget.item);
                        Navigator.pop(context);
                        _controller.text = "";
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete All",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 29,
              ),
            ],
          ),
        )
      ],
    );
  }

  FloatingActionButton myButton(BuildContext context) {
    final bloc = context.read<NoteCubit>();

    return FloatingActionButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Saved',
              style: TextStyle(color: Colors.orange[400]),
            ),
          ),
        );
        final text = _controller.text;
        if (text.isNotEmpty) {
          bloc.saveText(_controller, widget.item); // Add logic to save the note
        }
      },
      child: const Icon(Icons.save, size: 35, color: Colors.white),
      backgroundColor: Colors.orange,
    );
  }
}
