import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/todo_cubit.dart';
import 'package:todolist/models/todo_model.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(color: Colors.white, shadows: [
            BoxShadow(color: Colors.blue, blurRadius: 12, offset: Offset(6, 3)),
            BoxShadow(
                color: Colors.purple, blurRadius: 11, offset: Offset(-3, -3)),
          ]),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 14, 10, 36),
      ),
      body: Container(
        color: const Color.fromARGB(255, 30, 4, 48),
        child: BlocBuilder<TodoCubit, List<Todo>>(
          builder: (context, todos) {
            if (todos.isEmpty) {
              return const Center(
                child: Text(
                  'No tasks yet!',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              );
            }
            return Container(
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        context.read<TodoCubit>().toggleTodoCompletion(todo.id);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: (Colors.purple)),
                      onPressed: () {
                        context.read<TodoCubit>().deleteTodo(todo.id);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.pink,
        backgroundColor: Colors.blue,
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(
          Icons.edit_note_rounded,
          color: Colors.purple,
          size: 37,
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Builder(
              builder: (innerContext) {
                return TextButton(
                  onPressed: () {
                    final title = controller.text.trim();
                    if (title.isNotEmpty) {
                      context.read<TodoCubit>().addTodo(title);
                      Navigator.of(dialogContext).pop();
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Task title cannot be empty!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.purple),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
