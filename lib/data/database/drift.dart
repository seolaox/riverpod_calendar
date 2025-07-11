import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p; //path안에 있는 모든 기능을 p라는 변수에 넣어가지고 불러오겠다.

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_calendar_app/data/model/project_table.dart';
import 'package:sqlite3/sqlite3.dart';

part 'drift.g.dart';


@DriftDatabase(
  tables: [ProjectTable] //[]안에 생성한 TableModel이름 넣기
)

class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection()); //DB와 연결을 연다

  //특정한 id만 가져오고 싶을 때
  Future<ProjectTableData> getProjectById(int id) =>
    (select(projectTable)..where((table) => table.id.equals(id),))
    .getSingle();

  //데이터 형태로 데이터 받아오고 싶을 때
   Stream<List<ProjectTableData>> streamProjects(
    DateTime date,
  ) => (select(projectTable)..where((table) => table.date.equals(date))..orderBy(
    [
      (table) => OrderingTerm(expression: table.date,
      mode: OrderingMode.asc)
    ]
  )).watch(); //앱 데이터베이스에 만들어진 값 projectTable가져와라
    
  //데이터 입력하고 싶을 때
  Future<int> createProject(ProjectTableCompanion data)=> into(projectTable).insert(data);

  //데이터 삭제하고 싶을 때
  Future<int> removeProject(int id) =>(delete(projectTable)..where(
    (table) => table.id.equals(id),)).go(); 

  //데이터 수정하고 싶을 때
  Future<int> updateProjectById(int id, ProjectTableCompanion data)
  => (update(projectTable)..where((table) => table.id.equals(id))).write(data);
  //업데이트(어떤칼럼을 업데이트 할건지)..어떤 데이터를 업데이트 할건지 조건 적용 + 입력한 데이터로 덮어 쓴다.



  @override
  int get schemaVersion => 1; //schema수정될 수 있으니 현재 버전 알려주는 기능
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory(); //앱을 설치하면 각각 앱별로 Document폴더가 생성되는데 그 위치 가져오는 함수
    final file = File(p.join(dbFolder.path, 'db.sqlite')); //p.join <- 현재 운영체제에 맞게 어려가지 경로를 합쳐줌.

/////////// 
    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path; //앱 실행시 배정받는 임시 폴더 위치를 sqlite에 알려줌
///////////

    return NativeDatabase.createInBackground(file); //openConnection실행시 이 DB를 실행한다는 코드
  },);
}



//futurebuilder사용시
  /* 
  ---데이터 가져올 때 (앱 데이터베이스에 만들어진 값 projectTable가져와라)---
    Future<List<ProjectTableData>> getProjects(
    DateTime date,
  ) => (select(projectTable)..where((table) => table.date.equals(date))).get();  

    /*
    전체 (select(ProjectTable).where((table) => table.date.equals(date))) 큰 괄호는 where가 반환한 값을 의미
    where가 아닌 where를 실행한 select의 값을 반환하려면 where앞에 .울 하나 더 붙여야 함.
 
    final selectQuery = select(projectTable);
    selectQuery.where((table) => table.date.equals(date)); //입력한 날짜와 같은 데이터만 가져 올 수 있는 쿼리
    return selectQuery.get(); 
    */


  ---일정 생성하고 싶을 때---
  Future<int> createProject(ProjectTableCompanion data)=> into(projectTable).insert(data);//ProjectTableCompanion-> 업데이트 하거나 데이터 생성할 때 사용


---일정 삭제하고 싶을 때 ----
  Future<int> removeProject(int id) =>(delete(projectTable)..where(
    (table) => table.id.equals(id),)).go(); 





  */