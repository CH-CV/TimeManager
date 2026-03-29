import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'features/task/data/models/task_model.dart';
import 'features/pomodoro/data/models/pomodoro_record.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(PomodoroRecordAdapter());

  await NotificationService().init();

  runApp(const ProviderScope(child: TimewiseApp()));
}
