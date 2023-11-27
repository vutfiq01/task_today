import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import '../infrastructure/model/task.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;
  const factory TaskState.loading() = _Loading;
  const factory TaskState.loaded(List<Task> tasks) = _Loaded;
  const factory TaskState.error(String message) = _Error;
}

class TaskNotifier extends StateNotifier<TaskState> {
  final Isar isar;

  TaskNotifier(this.isar) : super(const TaskState.initial());

  Future<void> loadTasks() async {
    try {
      state = const TaskState.loading();

      final tasks = await isar.tasks.where().findAll();

      state = TaskState.loaded(tasks);
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  Future<void> addTask(String text) async {
    try {
      final newTask = Task()..task = text;

      await isar.writeTxn(() async {
        await isar.tasks.put(newTask);
      });

      await loadTasks();
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await isar.writeTxn(() async {
        await isar.tasks.put(task);
      });

      await loadTasks();
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await isar.writeTxn(() async {
        await isar.tasks.delete(task.id);
      });

      await loadTasks();
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }
}
