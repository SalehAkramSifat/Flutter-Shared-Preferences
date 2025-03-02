import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // ✅ Data Save Function (Bug Fixed)
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_controller.text.isNotEmpty) { // ফাঁকা নোট আটকানো হলো
      notes.add(_controller.text);
      await prefs.setStringList('notes', notes); // List হিসেবে স্টোর
      _controller.clear();
      setState(() {});
    }
  }

  // ✅ Data Load Function
  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedNotes = prefs.getStringList('notes');

    if (storedNotes != null) {
      setState(() {
        notes = storedNotes;
      });
    }
  }

  // ✅ Data Delete Function
  Future<void> deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes.removeAt(index);
    await prefs.setStringList('notes', notes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Preferences Notes'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 3,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit),
                labelText: "What's on your mind?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: saveData,
                child: Text("Save"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                  trailing: IconButton(
                    onPressed: () => deleteNote(index),
                    icon: Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
