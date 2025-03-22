import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/features/domain/entities/task.dart';
import 'package:task_manager_app/features/presentation/controllers/task_controller.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? task;

  TaskDetailPage({this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dueDateController = TextEditingController();
  final TaskController taskController = Get.find();

  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _dueDateController.text = _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : '';
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Thêm Công Việc' : 'Chỉnh sửa Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tên công việc'),
            ),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: _dueDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Hạn hoàn thành',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDueDate(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: widget.task?.id,
                  title: _titleController.text,
                  description: _descController.text,
                  status: widget.task?.status ?? 0,
                  dueDate: _dueDate,
                );

                if (widget.task == null) {
                  taskController.addTask(newTask);
                } else {
                  taskController.updateTask(newTask);
                }

                Get.back();
              },
              child: Text(widget.task == null ? 'Lưu' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
