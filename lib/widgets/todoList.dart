import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TodoListBuilder extends StatefulWidget {
  List<String> todoList;
  void Function() updateLocalData;
  TodoListBuilder(
      {super.key, required this.todoList, required this.updateLocalData});

  @override
  State<TodoListBuilder> createState() => _TodoListBuilderState();
}

class _TodoListBuilderState extends State<TodoListBuilder> {
  //this is being triggered when the list item is clicked
  void onItemClicked({required int index}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.todoList.removeAt(index);
                  });
                  widget.updateLocalData();
                  Navigator.pop(context);
                },
                child: Text("Mark as Done")),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.todoList.isEmpty)
        ? Center(child: Text("No item on the todo list"))
        : ListView.builder(
            itemCount: widget.todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: UniqueKey(),
                  // secondaryBackground: Container(
                  //   color: Colors.red[300],
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Icon(Icons.delete),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  direction: DismissDirection
                      .startToEnd, //by doing this it enables just one direction
                  background: Container(
                    color: Colors.green,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    // if(direction ==DismissDirection.startToEnd){}
                    setState(() {
                      widget.todoList.removeAt(index);
                    });
                    widget.updateLocalData();
                  },
                  child: ListTile(
                    onTap: () {
                      onItemClicked(index: index);
                    },
                    title: Text(widget.todoList[index]),
                  ));
            });
  }
}
