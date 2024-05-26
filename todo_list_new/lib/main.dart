import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class TodoListItem {
  final String title;
  final Color color;

  TodoListItem({required this.title, required this.color});
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  List<TodoListItem> todoList = [
    TodoListItem(title: 'Task 1', color: Colors.blue),
    TodoListItem(title: 'Task 2', color: Colors.yellow),
    TodoListItem(title: 'Task 3', color: Colors.green),
    TodoListItem(title: 'Task 4', color: Colors.indigo)
  ];

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoList'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: todoList[index].color,
              title: Text(todoList[index].title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeDialog(
                                onPressed: () {
                                  final Color oldColor = todoList[index].color;
                                  setState(
                                    () {
                                      todoList.removeAt(index);
                                      todoList.insert(index, TodoListItem(title: _controller.text, color: oldColor));
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                                controller: _controller..text = todoList[index].title,
                              );
                            });
                      },
                      icon: const Icon(Icons.mode_edit)),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.plus_one),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddDialog(
                      onPressed: () {
                        if (_controller.text != '') {
                          Random rnd = Random();
                          setState(() {
                            todoList.add(TodoListItem(
                                title: _controller.text,
                                color: Color.fromRGBO(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255), 1)));
                            print(todoList);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      controller: _controller..text = '');
                });
          }),
    );
  }
}

class AddDialog extends StatelessWidget {
  final Function onPressed;
  final TextEditingController controller;
  const AddDialog({required this.onPressed, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  onPressed();
                },
                child: const Text('Добавить'))
          ],
        ),
      ),
    );
  }
}

class ChangeDialog extends StatelessWidget {
  final Function onPressed;
  final TextEditingController controller;
  const ChangeDialog({required this.onPressed, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  onPressed();
                },
                child: const Text('Отредактировать'))
          ],
        ),
      ),
    );
  }
}