import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_today/application/task_state.dart';
import 'package:task_today/infrastructure/model/task.dart';

final container = ProviderContainer();

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationSupportDirectory();

  if (dir.existsSync()) {
    final isar = await Isar.open(
      [TaskSchema],
      directory: dir.path,
    );

    return isar;
  } else {
    throw Exception('Directory does not exist');
  }
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final isar = ref.watch(isarProvider);

  return isar.when(
    data: (isar) => TaskNotifier(isar),
    loading: () => TaskNotifier(null),
    error: (error, stack) => throw error,
  );
});
