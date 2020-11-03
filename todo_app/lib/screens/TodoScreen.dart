import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:todo_app/providers/todo_providers.dart';

final _itemTodo = ScopedProvider<Todo>(null);

class TodoScreen extends StatelessWidget {

  addTodo(BuildContext context, String description){
    context.read(todosProvider).add(description);
    print("Count: ${context.read(todosProvider.state).length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: Container(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                TodoInput(onSubmit: (value) => addTodo(context, value)),
                SizedBox(height: 30,),
                Consumer(builder: (context, watch, _){
                  final count = watch(unDoneTodosCount);
                  return Text("Todos left : $count", style: Theme.of(context).textTheme.bodyText2,);
                }),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1, color: Colors.grey.withOpacity(0.4), offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        blurRadius: 2, color: Colors.grey.withOpacity(0.2), offset: Offset(0, 2.5),
                      )
                    ]
                  ),
                  child: FilterList()),
                Expanded(
                  flex: 1,
                  child: Container(
                    
                    child: Consumer(
                    builder: (context, watch, _){
                        final todos = watch(filteredTodos);
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ...todos.map((todo) => Dismissible(
                                background: Container(color: Colors.redAccent,),
                                key: ValueKey(todo.id),
                                onDismissed: (_){
                                  context.read(todosProvider).remove(todo.id);
                                },
                                child: ProviderScope(
                                  overrides: [_itemTodo.overrideWithValue(todo)],
                                  child: const TodoItem(),
                                ),
                              ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoInput extends StatefulWidget {
  final Function(String) onSubmit;

  const TodoInput({Key key, @required this.onSubmit}) : super(key: key);
  @override
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onSubmitted: _onSubmit,
        decoration: InputDecoration(
          labelText: "What need to be done ?",
          labelStyle: Theme.of(context).textTheme.headline6
        ),
      ),
    );
  }

  void _onSubmit(String value) {
    _controller.clear();
    widget.onSubmit(value);
  }
}

class FilterList extends ConsumerWidget{

 
  @override
  Widget build(BuildContext context, watch) {
    // TODO: implement build
    final filter = watch(filterTypeProvider);
     Color getColor(FilterType type){
      return type == filter.state ? Colors.blueAccent : null;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Tooltip(
          message: "ALL",
          child: FlatButton(onPressed: ()=> filter.state = FilterType.none, 
          textColor: getColor(FilterType.none),
          child: Text('ALL')),
        ),
        Tooltip(
          message: "DONE",
          child: FlatButton(onPressed: ()=> filter.state = FilterType.done, 
          textColor: getColor(FilterType.done),
          child: Text('DONE')),
        ),
        Tooltip(
          message: "UNDONE",
          child: FlatButton(onPressed: ()=> filter.state = FilterType.unDone, 
          textColor: getColor(FilterType.unDone),
          child: Text('UNDONE')),
        ),
      ],
    ) ;
  }
}

class TodoItem extends ConsumerWidget {
  
  const TodoItem();

  @override
  Widget build(BuildContext context, watch) {
    // TODO: implement build
   final todo = watch(_itemTodo);
   return ListTile(
     leading: Checkbox(
       value: todo.done,
       onChanged: (value) => context.read(todosProvider).toggle(todo.id),
     ),
     title: Text(todo.description),
   );

  }

}

