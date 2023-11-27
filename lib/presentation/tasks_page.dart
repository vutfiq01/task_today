import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_today/application/task_state.dart';
import '../application/task_provider.dart';
import '../infrastructure/model/task.dart';

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  final TextEditingController _controller = TextEditingController();

  void _addTask(WidgetRef ref) {
    final task = _controller.text;

    if (task.isNotEmpty) {
      ref.read(taskProvider.notifier).addTask(task);

      _controller.clear();
    }
  }

  void _toggleTask(WidgetRef ref, Task task) {
    final updatedTask = Task()
      ..id = task.id
      ..task = task.task == 'Done' ? 'Todo' : 'Done'; // Toggle the task status

    ref.read(taskProvider.notifier).updateTask(updatedTask);
  }

  void _deleteTask(WidgetRef ref, Task task) {
    ref.read(taskProvider.notifier).deleteTask(task);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<TaskState>(
      taskProvider,
      (_, state) {
        state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red,
                ),
              );
            },
            orElse: () {} // No action for other states
            );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Today'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(taskProvider);
            return state.when(
              initial: () => const Text('Welcome to Task Today!'),
              loading: () => const CircularProgressIndicator(),
              loaded: (tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: const Icon(Icons.label, color: Colors.blue),
                    title: Text(task.task ?? ''),
                    trailing: task.task == 'Done'
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      _toggleTask(ref, task);
                    },
                    onLongPress: () {
                      _deleteTask(ref, task);
                    },
                  );
                },
              ),
              error: (message) => Container(),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Enter a task'),
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: () => _addTask(ref),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
