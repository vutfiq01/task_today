import 'package:isar/isar.dart';

part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;

  String? task;

  @override
  bool operator ==(Object other) {
    if (other is Task) {
      return id == other.id && task == other.task;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => id.hashCode ^ task.hashCode;
}
