import '../../data/datasources/task_local_datasource.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource = TaskLocalDataSource.instance;

  @override
  Future<List<Task>> getTasks() async {
    final taskModels = await localDataSource.getTasks();

    return taskModels.map((taskModel) {
      return Task(
        id: taskModel.id,
        title: taskModel.title,
        description: taskModel.description,
        status: taskModel.status,
        dueDate: taskModel.dueDate,
      );
    }).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      dueDate: task.dueDate,
    );
    await localDataSource.addTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      dueDate: task.dueDate,
    );
    await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(int id) async {
    await localDataSource.deleteTask(id);
  }
}
