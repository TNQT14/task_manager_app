import 'package:get/get.dart';
import 'package:task_manager_app/core/utils/notification_helper.dart';
import 'package:task_manager_app/features/domain/entities/task.dart';
import 'package:task_manager_app/features/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/get_tasks_usecase.dart';
import 'package:task_manager_app/features/domain/usecases/update_task_usecase.dart';

class TaskController extends GetxController {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskController({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }


  var tasks = <Task>[].obs;
  var taskList = <Task>[].obs;
  var searchQuery = ''.obs;
  var filteredTaskList = <Task>[].obs;
  var showOnlyIncomplete = false.obs;

  Future<void> fetchTasks() async {
    tasks.value = await getTasksUseCase();
    updateFilteredTasks();
  }

  Future<void> addTask(Task task) async {
    await addTaskUseCase(task);
    await fetchTasks();

    if (task.dueDate != null) {
      await NotificationHelper.scheduleTaskNotification(
        task.id ?? tasks.length,
        "Nhắc nhở công việc",
        "Công việc '${task.title}' đã đến hạn!",
        task.dueDate!,
      );
    }
  }

  void applyFilter() {
    if (showOnlyIncomplete.value) {
      filteredTaskList.value = tasks.where((task) => task.status == 0).toList();
    } else {
      filteredTaskList.value = tasks;
    }
  }

  void toggleFilter() {
    showOnlyIncomplete.value = !showOnlyIncomplete.value;
    applyFilter();
  }

  Future<void> updateTask(Task task) async {
    await updateTaskUseCase(task);
    await fetchTasks();

    if (task.dueDate != null) {
      await NotificationHelper.scheduleTaskNotification(
        task.id ?? tasks.length,
        "Nhắc nhở công việc",
        "Công việc '${task.title}' đã đến hạn!",
        task.dueDate!,
      );
    }
  }

  Future<void> deleteTask(int id) async {
    await deleteTaskUseCase(id);
    await fetchTasks();
  }

  void updateFilteredTasks() {
    filteredTaskList.value = tasks
        .where((task) =>
            task.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            task.description
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredTasks();
  }

  void toggleTaskStatus(Task task) async {
    int newStatus = task.status == 1 ? 0 : 1;

    int index = taskList.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      taskList[index] = task.copyWith(status: newStatus);
    }
    await updateTaskUseCase(task.copyWith(status: newStatus));
    await fetchTasks();
  }
}
