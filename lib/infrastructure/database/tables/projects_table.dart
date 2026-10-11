import 'package:drift/drift.dart';

class ProjectsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get vibe => text()();
  TextColumn get platform => text()();
  IntColumn get targetLengthMs => integer()();
  TextColumn get rawClipsJson => text()(); // List<String> paths
  TextColumn get aiEditTraceJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}