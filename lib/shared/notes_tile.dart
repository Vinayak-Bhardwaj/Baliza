import 'package:baliza/screens/Home/note_editor.dart';
import 'package:baliza/service_providers/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesTile extends StatefulWidget {
  String? heading;
  String? content;
  int? index;

  NotesTile({this.content, this.heading, this.index});

  @override
  _NotesTileState createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final databaseServiceInstance = Provider.of<DatabaseService>(context);
    
    //Method to find out number of words in a string
    final List l = widget.content!.split(' ');

    //For multiple line comments display
    String? content1;
    String? content2;

    // To assign contents based on how big the content is
    if (l.length < 5) {
      content1 = widget.content;
    } else if (l.length >= 5 && l.length < 12) {
      content1 = '';
      content2 = '';
      for (int i = 0; i < 6; i++) {
        content1 = content1! + l[i];
        content1 = content1 + ' ';
      }
      for (int i = 6; i < l.length; i++) {
        content2 = content2! + l[i];
        content2 = content2 + ' ';
      }
    } else {
      content1 = '';
      content2 = '';
      for (int i = 0; i < 6; i++) {
        content1 = content1! + l[i];
        content1 = content1 + ' ';
      }
      for (int i = 6; i < 12; i++) {
        content2 = content2! + l[i];
        content2 = content2 + ' ';
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NoteEditor(
                  editHeading: widget.heading,
                  editContent: widget.content,
                  editIndex: widget.index);
            },
          ),
        );
      },
      child: Container(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              //Heading and Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  //Heading
                  Text('${widget.heading}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: size.height * 0.024)),
                  
                  SizedBox(height: 5.0),

                  //Content
                  Text('$content1', style: TextStyle(fontSize: size.height * 0.0182)),
                  if (content2 != null)
                    Text('$content2....', style: TextStyle(fontSize: size.height * 0.0182)),

                ],
              ),

              //star, menu and Date Time widget
              Column(
                children: <Widget>[
                  
                  //Star and Menu in a row
                  Row(
                    children: <Widget>[
                     
                      //Star icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pressed = !pressed;
                          });
                        },
                        child: (pressed == true)
                        ? ImageIcon(AssetImage('assets/Home/starIconYellow.png'), color: Colors.yellow)
                        : ImageIcon(AssetImage('assets/Home/starIconWhite.png')),
                      ),

                      //ADDING 3 DOTS Menu
                      IconButton(
                        icon: Icon(Icons.more_vert, size: size.height * 0.0243),
                        onPressed: () async {
                          await databaseServiceInstance
                              .deleteNotes(widget.index.toString());
                          setState(() {
                          });
                        },
                      ),

                    ],
                  ),

                  //Date Time widget
                  Text("Date Time",
                      style: TextStyle(fontSize: size.height * 0.0182, color: Colors.grey)),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
