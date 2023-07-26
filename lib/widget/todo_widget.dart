import 'package:flutter/material.dart';
import 'package:todo_sqflite/model/model.dart';
import 'package:todo_sqflite/screens/add_todo_screen.dart';

class TodoWidget extends StatelessWidget {
  final ToDoModel todo;
  final VoidCallback onDeletePressed;

  const TodoWidget({
    Key? key,
    required this.todo,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddTodoScreen(
            todo: todo,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.1)),
        child: ListTile(
          leading: IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
          trailing: todo.isImportant == true
              ? const Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                )
              : const SizedBox(),
          subtitle: Text(
            todo.title,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
          title: Text(
            todo.describtion,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
