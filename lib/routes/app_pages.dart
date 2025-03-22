import 'package:get/get.dart';
import 'package:task_manager_app/bidings/task_binding.dart';
import '../features/presentation/pages/home_page.dart';
import '../features/presentation/pages/task_detail_page.dart';
import 'app_routes.dart';

class AppPages {

  static const String initial = AppRoutes.home;


  static final routes = [
    GetPage(name: AppRoutes.home, page: () => HomePage()),
    GetPage(
      name: AppRoutes.taskDetail,
      page: () => TaskDetailPage(),
      binding: TaskBinding(),
    ),
  ];
}
