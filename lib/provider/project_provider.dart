import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_calendar_app/data/database/drift.dart';
import 'package:get_it/get_it.dart';

// 날짜별 프로젝트 리스트 Provider
final selectedDayProvider = StateProvider<DateTime>(
  (ref) => DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ),
);

final projectsByDateProvider = StreamProvider.autoDispose<List<ProjectTableData>>((ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  return GetIt.I<AppDatabase>().streamProjects(selectedDay);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.I<AppDatabase>();
});

