import 'package:flutter/material.dart';

import '../model/model.dart';
import '../repository/database_repository.dart';

class AddTodoScreen extends StatefulWidget {
  final ToDoModel? todo;

  const AddTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  bool important = false;
  final titleController = TextEditingController();
  final subtitleControler = TextEditingController();

  @override
  void initState() {
    addTodoData();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleControler.dispose();
    super.dispose();
  }

  void addTodoData() {
    if (widget.todo != null) {
      if (mounted) {
        setState(() {
          titleController.text = widget.todo!.title;
          subtitleControler.text = widget.todo!.describtion;
          important = widget.todo!.isImportant;
        });
      }
    }
  }

  void addTodo() async {
    ToDoModel todo = ToDoModel(
        title: titleController.text,
        describtion: subtitleControler.text,
        isImportant: important);
    if (widget.todo == null) {
      Navigator.pop(context);
      await DatabaseRepository.instance.insert(todo: todo);
    } else {
      Navigator.pop(context);
      await DatabaseRepository.instance.update(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add todo' : 'Update Todo',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  label: Text('Todo title'), hintText: 'Develop amazing app '),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              controller: subtitleControler,
              decoration: const InputDecoration(
                label: Text('Todo subtitle'),
              ),
            ),
            SwitchListTile.adaptive(
              title: const Text('is your todo really important'),
              value: important,
              onChanged: (value) => setState(
                () {
                  important = value;
                },
              ),
            ),
            MaterialButton(
              color: Colors.black,
              height: 50,
              minWidth: double.infinity,
              onPressed: addTodo,
              child: Text(
                widget.todo == null ? 'Add todo' : 'Update Todo',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
