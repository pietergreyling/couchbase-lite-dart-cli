import 'dart:io';

// import 'package:cli/cli.dart' as cli;
import 'package:cli_repl/cli_repl.dart';
import 'package:cbl/cbl.dart';
import 'package:cbl_dart/cbl_dart.dart';

late final Database db;
String dbName = "";

main(List<String> args) async {
  Repl repl = Repl(prompt: '>>> ', continuation: '... ', validator: validator);

  // printStringList(args);

  if (args.isNotEmpty) {
    dbName = args[0];
    print("-- Database: $dbName");
  }

  await for (var x in repl.runAsync()) {
    String replCommand = x.trim();
    if (replCommand.isEmpty) continue;

    if (replCommand == 'throw;') throw "-- Oh no!";
    if (replCommand == 'exit;') throw "-- Bye bye";
    if (replCommand == 'quit;') throw "-- Quiting!";

    // DB operations
    if (replCommand == 'open;') db = await openDatabase(dbName);

    if (replCommand == 'test;') await saveDocument(db, x);

    if (replCommand.contains('save;')) await saveDocument(db, x);

    if (replCommand == 'list;') await listDocuments(db);

    if (replCommand == 'listall;') await listAllDocuments(db);

    if (replCommand == 'close;') await closeDatabase(db);

    print(x); // reflect the whole string as entered

  }
}

bool validator(String str) {
  return str.trim().isEmpty || str.trim().endsWith(';');
}

void printStringList(List<String> list) {
  print(list);
}

Future<Database> openDatabase(String dbname) async {
  // await CouchbaseLiteDart.init(edition: Edition.community);
  await CouchbaseLiteDart.init(edition: Edition.enterprise);
  Database db = await Database.openAsync(dbname);
  return db;
}

Future<void> closeDatabase(Database db) async {
  await db.close();
}

Future<void> saveDocument(Database db, String doctext) async {
  final doc = MutableDocument({
    'type': 'text',
    'createdAt': DateTime.now(),
    'body': doctext,
  });

  await db.saveDocument(doc);

  print('Document ${doc.id} stored: ${doc.toJson()}');
}

Future<void> listDocuments(Database db) async {
  final query = const QueryBuilder()
      .select(
        SelectResult.expression(Meta.id),
        SelectResult.property('createdAt'),
        SelectResult.property('body'),
      )
      .from(DataSource.database(db))
      .where(Expression.property('type').equalTo(
        Expression.string('text'),
      ))
      .orderBy(Ordering.property('createdAt').descending());

  final resultSet = await query.execute();
  int documentCount = 0;

  await for (final result in resultSet.asStream()) {
    documentCount++;
    print(result.toJson());
  }

  print('$documentCount documents found');
}

Future<void> listAllDocuments(Database db) async {
  final query = const QueryBuilder()
      .select(
        SelectResult.expression(Meta.id),
      )
      .from(DataSource.database(db));

  final resultSet = await query.execute();
  int documentCount = 0;

  await for (final result in resultSet.asStream()) {
    documentCount++;
    print(result.toJson());
  }

  print('$documentCount documents found');
}
