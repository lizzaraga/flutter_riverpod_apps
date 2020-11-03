import 'package:uuid/uuid.dart';

class Todo{
  String id;
  final String description;
  final bool done;

  Todo({String id, this.description, this.done}): id = id ?? Uuid().v4();

  @override
  String toString() {
    // TODO: implement toString
    return "Todo(description: $description, done: $done)";
  }
  
}

