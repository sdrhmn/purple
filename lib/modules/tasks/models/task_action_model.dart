import 'package:timely/modules/tasks/models/task_model.dart';

class TaskAction {
  Task task;
  String action;

  TaskAction({required this.task, required this.action});

  toJson() {
    return {
      'task': task.toJson(),
      'action': action,
    };
  }

  // factory TaskAction.fromDataTaskAction(DataTaskAction dataTaskAction) {
  //   return TaskAction(task: dataTaskAction.data)
  // }
}

class DataTaskAction {
  // TODO InShaaAllah
}
