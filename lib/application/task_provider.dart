import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:task_today/application/task_state.dart';
import '../global_constants.dart';

final isarProvider = Provider<Isar>((ref) {
  return isar;
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final isar = ref.watch(isarProvider);
  return TaskNotifier(isar);
});
