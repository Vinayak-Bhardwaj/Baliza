import 'package:baliza/service_providers/auth.dart';
import 'package:baliza/service_providers/database.dart';
import 'package:flutter/material.dart';

class NoteEditor extends StatefulWidget {
  @override
  _NoteEditorState createState() => _NoteEditorState();

  String? editHeading;
  String? editContent;
  int? editIndex;
  NoteEditor({this.editHeading, this.editContent, this.editIndex});

}

class _NoteEditorState extends State<NoteEditor> {

  //Declaring Variables
  bool pressed = false;
  String? heading;
  String? content;
  late String numberOfNotes;

  AuthService auth = AuthService();
  final databaseInstance = DatabaseService();
  

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    //Calling Constructor
    NoteEditor();
    
    //If the data is edited so edit heading and other variables wont be null so passing them
    if(widget.editHeading != null && widget.editContent != null && widget.editIndex != null) {
      heading = widget.editHeading;
      content = widget.editContent;
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[50],
          ),
          margin: EdgeInsets.all(10.0),
          child: Center(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () async {
                await databaseInstance.getNumberOfNotes(auth.user!.uid);
                
                // Case where user atleast writes something in the fields instead of directly going back
                if (heading != null && content != null) {
                  int number = databaseInstance.NumberOfNotes;
                  numberOfNotes = (widget.editIndex != null) ? widget.editIndex.toString() : number.toString();
                  await databaseInstance.updateNotes(
                      auth.user!.uid, heading, content, numberOfNotes);
                }
                Navigator.pushNamed(context, '/Home');
              },
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              SizedBox(height: size.height * 0.0853),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.blue[50],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        // if it's in edit mode so we have a initiall value otherwise not
                        initialValue : (widget.editHeading != null) ? widget.editHeading : null,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.0365,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter Heading",
                          fillColor: Colors.blue[50],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue.shade50, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            heading = val;
                          });
                        },
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black,
                      ),
                      TextFormField(
                        // if it's in edit mode so we have a initiall value otherwise not
                        initialValue : (widget.editContent != null) ? widget.editContent: null,
                        maxLines: 20,
                        style: TextStyle(
                          fontSize: size.height * 0.0207,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter the content",
                          fillColor: Colors.blue[50],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue.shade50, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            content = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.0975),

              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.grey,
                      offset: Offset(0.0, 1.5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: ImageIcon(AssetImage('assets/Home/pencilIcon.png'), size: 40, color: Colors.blue[900]),
                      ),
                      
                      SizedBox(width: 70),
                      
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pressed = !pressed;
                          });
                        },
                        child: (pressed == true)
                        ? ImageIcon(AssetImage('assets/Home/starIconYellow.png'), color: Colors.yellow, size: size.height * 0.0426)
                        : ImageIcon(AssetImage('assets/Home/starIconWhite.png'), size: size.height * 0.0426, color: Colors.blue[900]),
                      ),
                      SizedBox(width: size.width * 0.1703),
                      Icon(Icons.share, size: size.height * 0.0426, color: Colors.blue[900]),
                      SizedBox(width: size.width * 0.1703),
                      Icon(Icons.more_vert, size: size.height * 0.0426, color: Colors.blue[900]),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
    );
  }
}
