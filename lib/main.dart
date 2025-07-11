import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_calendar_app/data/database/drift.dart';
import 'package:riverpod_calendar_app/ui/screen/home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 실행할 준비가 돼 있는지 확인을 하는 절차
  await initializeDateFormatting(); //날짜 함수 초기화
  final database = AppDatabase();
  GetIt.I.registerSingleton(database);

  /*
  원래는 main함수에 runapp을 바로 실행하면 위 WidgetsFlutterBinding함수가 자동으로 실행이 되나
  만약에 main함수에서 다른 함수를 실행하고 싶다면 직접 WidgetsFlutterBinding함수를 불러줘야 함.
   */

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'SCDream',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
