import 'package:flutter/material.dart';
import 'package:todo_sqflite/model/model.dart';
import 'package:todo_sqflite/repository/database_repository.dart';
import 'package:todo_sqflite/screens/add_todo_screen.dart';
import 'package:todo_sqflite/widget/todo_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    initDb();
    getTodos();
    super.initState();
  }

  void initDb() async {
    await DatabaseRepository.instance.database;
  }

  List<ToDoModel> myTodos = [];
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getTodos();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My todos'),
        ),
        body: myTodos.isEmpty
            ? const Center(child: Text('You don\'t have any todos yet'))
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final todo = myTodos[index];
                  return TodoWidget(
                    todo: todo,
                    onDeletePressed: () {
                      delete(todo: todo, context: context);
                      getTodos();
                    },
                  );
                },
                itemCount: myTodos.length,
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: gotoAddScreen,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getTodos() async {
    await DatabaseRepository.instance.getAllTodos().then((value) {
      setState(() {
        myTodos = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  void gotoAddScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTodoScreen();
    }));
  }

  void delete({required ToDoModel todo, required BuildContext context}) async {
    DatabaseRepository.instance.delete(todo.id!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}
