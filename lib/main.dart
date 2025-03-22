import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/bidings/task_binding.dart';
import 'package:task_manager_app/routes/app_pages.dart';
import 'core/utils/notification_helper.dart';
import 'features/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: TaskBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
