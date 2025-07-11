import 'package:drift/drift.dart';

class ProjectTable extends Table{
  IntColumn get id => integer().autoIncrement()(); //IntColumn(원하는타입) get(가져온다) id (설정한 값) => integer()() (원하는 타입 함수처럼 실행)
  TextColumn get title => text()(); 
  TextColumn get content => text()(); 
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault
          (()=> DateTime.now().toUtc())(); //기본값을 입력할때 clientDefault를 사용하여 () => 함수를 넣어 기본값으로 입력하고 싶은 값을 넣음.
          //clientDefault(() => DateTime.now().toUtc()) row가 생성될때마다 생성된 날짜 값을 넣도록 하는 함수
}

  