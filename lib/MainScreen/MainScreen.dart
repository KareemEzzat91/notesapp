import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:notesapp/hive_helper.dart';
import 'package:notesapp/textpage/Textpage.dart';

import '../Notecubit/note_cubit.dart';

class Mainscreen extends StatelessWidget {
  final _textFieldController = TextEditingController();
  int count = 0;
  List<Color> mycolors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
  ];

/*  @override
  void initState() {
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteCubit>();
    print(1);
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return  BlocBuilder<NoteCubit, NoteState>(
      builder: (BuildContext context, NoteState state) {
        if (state is LoadingState) {
          print("LoadingState");
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
            backgroundColor: Colors.white,
          ));
        }
        if (state is FaliuerState) {
          print("FaliuerState");
          return const Center(
              child: Text(
            "Error ",
            style: TextStyle(
                color: Colors.red, fontSize: 50, fontWeight: FontWeight.bold),
          ));
        } else {
          print(2);
          return Scaffold(
            appBar: buildAppBar(context),
            floatingActionButton: buildFloatingActionButton(context),
            body: ListView.builder(
              itemCount: NoteHiveHelper.myNotes.length,
              itemBuilder: (context, index) => Stack(children: [
                BuildBox(index, context),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("you want to delete " +
                                NoteHiveHelper.myNotes[index] +
                                "?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text('CANCEL'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  bloc.deletenote(index, context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                Positioned(right: 5, child: IconButton(onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("you want to update " +
                              NoteHiveHelper.myNotes[index] +
                              "?"),
                          content: TextField(
                            controller: _textFieldController,
                            decoration: InputDecoration(hintText: "Your New Note Name"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                bloc.updateNote (_textFieldController,context,index);
                              },
                            ),
                          ],
                        );
                      });
                }, icon: Icon(Icons.change_circle_outlined,color: Colors.white,size: 40,)))
              ]),
            ),
          );
        }//بتاع ال else
      },//بتاع الbuilder
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    final bloc = context.read<NoteCubit>();
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add new Note '),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Your Note Name"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    bloc.addNote(_textFieldController, context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Padding BuildBox(int index, BuildContext context) {
    final bloc = context.read<NoteCubit>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Textpage(item: NoteHiveHelper.myNotes[index] ?? "",),
            ),
          );
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: mycolors[index % 5],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: Text(
            NoteHiveHelper.myNotes[index] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final bloc = context.read<NoteCubit>();
    return AppBar(
      backgroundColor: Colors.orange,
      title: const Text(
        "MyNotes",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.red,
              blurRadius: 10.0,
              // You can adjust this value to change the shadow blur
              offset: Offset(2.0, 2.0), // Adjust this to position the shadow
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title:const Text("Do You Want to delete All Notes ?") ,
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
                      bloc.deleteallNotes ();
                      Navigator.pop(context);


                    },
                  ),
                ],
              );

            bloc.deleteallNotes();
            });
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            // Ensure the Column only takes up as much space as needed
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
}
// add Note
//remove Note
// update Note
// Delete ALl Notes
//
