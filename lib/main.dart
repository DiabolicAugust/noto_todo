import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noto_todo/domain/todo.dart';
import 'package:noto_todo/presentation/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<List>(ConstantStrings.todosBoxName);
  runApp(const HomePage());
}
