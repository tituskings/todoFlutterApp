import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/addTodo.dart';
import 'package:todo_app/widgets/todoList.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Already exists"),
                content: Text("This todo data already exists"),
                actions: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("close"))
                ]);
          });
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = (prefs.getStringList("todoList") ?? []).toList();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void showAddTodoButtonSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 200,
              child: Addtodo(
                addTodo: addTodo,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blueGrey[900],
          onPressed: showAddTodoButtonSheet,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
                height: 200,
                width: double.infinity,
                color: Colors.blueGrey[900],
                child: Center(
                  child: Text(
                    "Todo App",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("www.google.com"));
              },
              leading: Icon(Icons.person),
              title: Text(
                "About me",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo App"),
      ),
      body:
          TodoListBuilder(todoList: todoList, updateLocalData: updateLocalData),
    );
  }
}
