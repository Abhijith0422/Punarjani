// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punarjani/theme/theme.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];
  final TextEditingController _textController = TextEditingController();
  bool ischecked = false;

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
      _textController.clear();
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Todo List',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 20),
        ),
        backgroundColor: const Color(0xFFFF4500),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Enter a task',
                      labelStyle: const TextStyle(fontFamily: 'Poppins'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTodoItem(_textController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAE0C8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 20.0),
                  ),
                  child: Consumer<ThemeProvider>(
                      builder: (context, themeprovider, _) {
                    return const Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Checkbox(
                      value: ischecked,
                      onChanged: (bool? value) {
                        setState(() {
                          ischecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _todoItems[index],
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        trailing: ischecked
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeTodoItem(index),
                              )
                            : null,
                      ),
                    ),
                  ],
                );
              },
              itemCount: _todoItems.length,
            ),
          )
        ],
      ),
    );
  }
}
