import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_calendar_app/ui/component/color.dart';
import 'package:riverpod_calendar_app/ui/component/custom_textfield.dart';
import 'package:riverpod_calendar_app/data/database/drift.dart';

class ProjectBottomsheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final int? id;

  const ProjectBottomsheet({
    required this.selectedDate,
    this.id,
    super.key,
  });

  @override
  ConsumerState createState() => _ProjectBottomsheetState();
}

class _ProjectBottomsheetState extends ConsumerState<ProjectBottomsheet> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>(); //이 프로젝트 전체에 단 하나의 값만 존재하는 key값을 , 자동으로 만들어 냄. 이 key안에 FormState(Form의 상태)를 저장
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectTableData?>(
      future: widget.id == null
          ? null
          : GetIt.I<AppDatabase>().getProjectById(widget.id!),
      builder: (context, snapshot) {
        if (widget.id != null &&
            snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        return Container(
          color: Colors.white,
          height: 600,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    _Title(
                      onSaved: (String? val) {
                        title = val;
                      },
                      initialValue: data?.title ?? '',
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: _Content(
                        onSaved: (String? val) {
                          content = val;
                        },
                        initialValue: data?.content ?? '',
                      ),
                    ),
                    SizedBox(height: 10),
                    _SaveButton(onPressed: onSavePressed),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onSavePressed() async {
    final isValid = formkey.currentState!.validate();
    if (isValid) {
      formkey.currentState!.save();
      final database = GetIt.I<AppDatabase>(); //main에서 만들어 놓은 Database가 자동으로 불러와짐
      if (widget.id == null) {
        await database.createProject(
          ProjectTableCompanion(
            title: Value(title!),
            content: Value(content!),
            date: Value(widget.selectedDate),
          ),
        );
      } else {
        await database.updateProjectById(
          widget.id!,
          ProjectTableCompanion(
            title: Value(title!),
            content: Value(content!),
            date: Value(widget.selectedDate),
          ),
        );
      }
      Navigator.of(context).pop();
      // 저장 후 Provider 갱신 필요시 ref.invalidate(projectsByDateProvider);
    }
  }
}

class _Title extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  const _Title({required this.onSaved, required this.initialValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      label: '제목',
      onSaved: onSaved,
      initialValue: initialValue,
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  const _Content({required this.onSaved, required this.initialValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      label: '내용',
      onSaved: onSaved,
      initialValue: initialValue,
      expand: true,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
