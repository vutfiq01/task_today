import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_today/application/task_state.dart';
import 'package:task_today/presentation/add_or_update_task_page.dart';
import '../application/task_provider.dart';
import '../infrastructure/model/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _deleteTask(WidgetRef ref, Task task) {
    ref.read(taskProvider.notifier).deleteTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Today'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(taskProvider);
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

            return state.when(
              initial: () => const CircularProgressIndicator(),
              loading: () => const CircularProgressIndicator(),
              loaded: (tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: const Icon(Icons.label, color: Colors.blue),
                    title: Text(task.task ?? ''),
                    trailing: IconButton(
                        onPressed: () {
                          _deleteTask(ref, task);
                        },
                        icon: const Icon(Icons.delete)),
                    onLongPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddOrUpdateTaskPage(
                                task: task,
                              )));
                    },
                  );
                },
              ),
              error: (message) => Container(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddOrUpdateTaskPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
