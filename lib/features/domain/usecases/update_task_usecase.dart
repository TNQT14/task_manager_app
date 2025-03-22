import '../repositories/task_repository.dart';
import '../entities/task.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    await repository.updateTask(task);
  }
}
