import 'package:get/get.dart';
import 'package:task_manager_app/features/domain/repositories/task_repository.dart';
import 'package:task_manager_app/features/domain/repositories/task_repository_impl.dart';
import 'package:task_manager_app/features/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/get_tasks_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/update_task_usecase.dart';
import 'package:task_manager_app/features/presentation/controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl());

    Get.lazyPut(() => GetTasksUseCase(Get.find()));
    Get.lazyPut(() => AddTaskUseCase(Get.find()));
    Get.lazyPut(() => UpdateTaskUseCase(Get.find()));
    Get.lazyPut(() => DeleteTaskUseCase(Get.find()));

    Get.lazyPut(() => TaskController(
      getTasksUseCase: Get.find(),
      addTaskUseCase: Get.find(),
      updateTaskUseCase: Get.find(),
      deleteTaskUseCase: Get.find(),
    ));
  }
}
