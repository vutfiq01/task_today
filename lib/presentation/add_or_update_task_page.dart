import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_today/infrastructure/model/task.dart';
import '../application/task_provider.dart';

class AddOrUpdateTaskPage extends ConsumerWidget {
  final Task? task;

  AddOrUpdateTaskPage({Key? key, this.task}) : super(key: key);

  late final TextEditingController _controller = TextEditingController(
    text: task != null ? task?.task : '',
  );

  void _addTask(WidgetRef ref) {
    final taskText = _controller.text;

    if (taskText.isNotEmpty) {
      if (task != null) {
        task!.task = taskText;
        ref.read(taskProvider.notifier).updateTask(task!);
      } else {
        ref.read(taskProvider.notifier).addTask(taskText);
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Write you task here',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _addTask(ref);
                  Navigator.pop(context);
                },
                child: Text(
                  task != null ? 'Update' : 'Add',
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
