import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/features/presentation/pages/task_detail_page.dart';
import '../controllers/task_controller.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Công Việc'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: taskController.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        actions: [
          Obx(() => Switch(
            value: taskController.showOnlyIncomplete.value,
            onChanged: (value) => taskController.toggleFilter(),
          )),
        ],
      ),
      body: Obx(() => ListView.builder(
        itemCount: taskController.filteredTaskList.length,
        itemBuilder: (context, index) {

          final task = taskController.filteredTaskList[index];
          String formattedDeadline = DateFormat('dd/MM/yyyy').format(task.dueDate ??DateTime.now());

          return ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description),
                Text("Thời gian dự kiến: $formattedDeadline",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            leading: Obx(() {
              final filteredList = taskController.filteredTaskList;
              if (index >= filteredList.length) return SizedBox();

              final task = filteredList[index];

              return Checkbox(
                value: taskController.filteredTaskList[index].status == 1,
                onChanged: (value) {
                  taskController.toggleTaskStatus(task);
                },
              );
            }),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                taskController.deleteTask(task.id!);
              },
            ),

            onTap: () {
              Get.to(() => TaskDetailPage(task: task));
            },
          );
        },
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => TaskDetailPage(task: null));
        },
        tooltip: 'Thêm Công Việc',
        child: const Icon(Icons.add),
      ),
    );
  }
}
