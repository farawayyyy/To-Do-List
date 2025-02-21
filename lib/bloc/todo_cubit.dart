import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/models/todo_model.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );
    final updatedTodos = [...state, newTodo];
    emit(updatedTodos);
  }

  void toggleTodoCompletion(String id) {
    final updatedTodos = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
    emit(updatedTodos);
  }

  void deleteTodo(String id) {
    final updatedTodos = state.where((todo) => todo.id != id).toList();
    emit(updatedTodos);
  }
}
