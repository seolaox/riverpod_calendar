import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:riverpod_calendar_app/ui/component/color.dart';
import 'package:riverpod_calendar_app/ui/component/calendar.dart';
import 'package:riverpod_calendar_app/ui/component/project_card.dart';
import 'package:riverpod_calendar_app/ui/component/project_bottomsheet.dart';
import 'package:riverpod_calendar_app/ui/component/today_banner.dart';
import 'package:riverpod_calendar_app/provider/project_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final projectsAsync = ref.watch(projectsByDateProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ProjectBottomsheet(selectedDate: selectedDay);
            },
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: selectedDay,
              onDaySelected: (day, _) {
                ref.read(selectedDayProvider.notifier).state = day;
              },
              selectedDayPredicate: (day) => day.isAtSameMomentAs(selectedDay),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2, top: 8),
                child: projectsAsync.when(
                  data:
                      (projects) => Column(
                        children: [
                          TodayBanner(
                            selectedDay: selectedDay,
                            taskCount: projects.length,
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount: projects.length,
                              itemBuilder: (context, index) {
                                final project = projects[index];
                                return Slidable(
                                  key: ValueKey(project.id),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await ref
                                              .read(appDatabaseProvider)
                                              .removeProject(project.id);
                                          ref.invalidate(
                                            projectsByDateProvider,
                                          );
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: '삭제',
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return ProjectBottomsheet(
                                            selectedDate: selectedDay,
                                            id: project.id,
                                          );
                                        },
                                      );
                                    },
                                    child: ProjectCard(
                                      title: project.title,
                                      content: project.content,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 4),
                            ),
                          ),
                        ],
                      ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
