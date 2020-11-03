import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/Todo.dart';

enum FilterType{
  none,
  done,
  unDone
}

final todosProvider = StateNotifierProvider<TodosNotifier>((ref) => TodosNotifier());
final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.none);
final unDoneTodosCount = Provider<int>((ref){
  return ref.watch(todosProvider.state)
  .where((todo) => !todo.done)
    .length;
});

final filteredTodos = Provider<List<Todo>>((ref){
  final todos = ref.watch(todosProvider.state);
  final filterType = ref.watch(filterTypeProvider);
  switch (filterType.state) {
    case FilterType.done:
      return todos.where((todo) => todo.done).toList();
      break;
    case FilterType.unDone:
      return todos.where((todo) => !todo.done).toList();
      break;
    default:
      return todos;
  }
});


class TodosNotifier extends StateNotifier<List<Todo>>{
  TodosNotifier([List<Todo> state]) : super(state ?? []);
  
  add(String description){
    state = [
      ...state,
      Todo(description: description, done: false)
    ];
  }

  remove(String id){
    state = [...state.where((todo) => todo.id != id)];
  }

  update(String id, String description){
    state = [
      for (Todo item in state)
        if(item.id == id)
          Todo(id: id, description: description, done: item.done)
        else
          item,
    ];
  }

  toggle(String id){
    state = [
      for(var item in state)
        if(item.id == id)
          Todo(id: item.id, description: item.description, done: !item.done)
        else
          item
    ];
  }
}