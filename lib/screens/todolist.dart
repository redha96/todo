import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetailPage(Todo("", 3, ""));
        },
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int postion) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.todos[postion].priority),
                child: Text(
                  this.todos[postion].id.toString(),
                ),
              ),
              title: Text(this.todos[postion].title),
              subtitle: Text(this.todos[postion].date),
              onTap: () {
                debugPrint("Tapped on " + this.todos[postion].id.toString());
                navigateToDetailPage(this.todos[postion]);
              },
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todoFuture = helper.getTodos();
      todoFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }

  Color getPriorityColor(int priority) {
    Color color = Colors.green;
    switch (priority) {
      case 1:
        color = Colors.red;
        break;

      case 2:
        color = Colors.orange;
        break;
    }
    return color;
  }

  void navigateToDetailPage(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );
    if (result == true) {
      getData();
    } else
      debugPrint("the value of result is" + result.toString());
  }
}
