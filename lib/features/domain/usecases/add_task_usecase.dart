import '../repositories/task_repository.dart';
import '../entities/task.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}