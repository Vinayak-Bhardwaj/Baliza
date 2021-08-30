import 'package:baliza/service_providers/auth.dart';
import 'package:baliza/service_providers/database.dart';
import 'package:baliza/shared/notes_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? numberOfNotes;

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthService>(context);
    final databaseServiceInstance = Provider.of<DatabaseService>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("MyNotes",
            style: TextStyle(color: Colors.black, fontSize: size.height * 0.028)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[50],
          ),
          margin: EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              //Does nothing for now
            },
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue[50],
            ),
            margin: EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async{
                await auth.signOut();
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: FutureBuilder(
            future: databaseServiceInstance.getUserNotes(auth.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List notes = databaseServiceInstance.userNotes;
                if (notes.isEmpty == false) {
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      Map information = notes[index];
                      return Column(
                        children: [
                          NotesTile(
                              heading: information['heading'],
                              content: information['content'],
                              index: index,
                              ),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text("No Notes Till Now, Click + to create one"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          numberOfNotes = databaseServiceInstance.userNotes.length;
          Navigator.pushNamed(context, '/NoteEditor');
        },
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}
