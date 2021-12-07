

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_save_app/database/database.dart';
import 'package:note_save_app/object/note.dart';
import 'package:note_save_app/screens/addnote.dart';
import 'package:note_save_app/screens/addnote.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Note>> _noteList;
  final DateFormat _dateFormat = DateFormat("MMM, dd, yyyy");
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = databaseHelper.getNoteList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    AddNote(
                      updateNoteList: _updateNoteList,
                    )
            ));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            final int completeNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;
            return ListView.builder(
              itemCount: int.parse(snapshot.data.length.toString()) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Notes", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 10,),
                        Text("${snapshot.data.length} notes"
                          , style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),)
                      ],
                    ),
                  );
                }
                return buildNote(snapshot.data![index - 1]);
              },
            );
          },
        )
    );
  }

  Widget buildNote(Note note) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    AddNote(
                        updateNoteList: _updateNoteList,
                        note: note
                    ),
              ));
            },
            child: ListTile(
              title: Text(note.title!, style: TextStyle(
                  fontSize: 18,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough
              ),),
              subtitle: Text(
                "${_dateFormat.format(note.date!)} - ${note.priority}",
                style: TextStyle(
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough
                ),),
              trailing: GestureDetector(
                  onTap: () {
                    databaseHelper.updateNote(note);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            AddNote(
                              updateNoteList: _updateNoteList,
                            ),
                    ));
                  },

                  child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {

                        });
                      }),

                  // child: Icon(Icons.delete, color: Theme
                  //     .of(context)
                  //     .primaryColor,


                  ),
              ),
              //
            ),

          // Divider(thickness: 1.5,color: Colors.blue,)
        ],
      ),
    );
  }
  void deleteNote(Note note){


  }
  // void _delete(BuildContext context, Note note) async {
  //
  //   int _noteList = await databaseHelper.deleteNote(note.id!);
  //   if (_noteList != 0) {
  //     _showSnackBar(context, 'Note Deleted Successfully');
  //     _updateNoteList();
  //   }
  // }
  //
  // void _showSnackBar(BuildContext context, String message) {
  //
  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }
}
