import 'dart:convert';
import 'dart:io';

import 'package:cbl/cbl.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:cli_repl/cli_repl.dart';
import 'package:path/path.dart' as p;

Database? db;
String? dbName;
String? dbDirectory;

main(List<String> args) async {
  await initCouchbaseLite();

  Repl repl = Repl(continuation: '... ', validator: validator);

  // printStringList(args);

  if (args.isNotEmpty) {
    final path = args[0].trim();
    if (path.isEmpty) {
      throw Exception('Path is empty');
    }
    setDbLocation(path);
    printResponse("Database: $path");
  }

  printPrompt();

  await for (var x in repl.runAsync()) {
    String replCommand = x.substring(0, x.length - 1).trim();
    if (replCommand.isEmpty) continue;

    if (replCommand == 'throw') throw "-- Oh no!";
    if (replCommand == 'exit') {
      printResponse("Bye bye");
      break;
    }
    if (replCommand == 'quit') {
      printResponse("Quiting!");
      break;
    }

    try {
      // DB operations
      if (replCommand.startsWith('open')) {
        final path = replCommand.substring(4).trim();
        if (path.isNotEmpty) {
          setDbLocation(path);
        }

        if (dbName == null) {
          printResponse("No database specified");
          continue;
        }
        db = await openDatabase(dbName!, dbDirectory!);
        printResponse('Opened database at ${p.relative(db!.path!)}.');
      }

      if (replCommand == 'test') await saveDocument(useDb(), x);

      if (replCommand.contains('save')) await saveDocument(useDb(), x);

      if (replCommand == 'list') await listDocuments(useDb());

      if (replCommand == 'listall') await listAllDocuments(useDb());

      if (replCommand == 'delete') {
        await deleteDatabase(useDb());
        db = null;
      }

      if (replCommand == 'close') {
        await closeDatabase(useDb());
        db = null;
      }
    } on DatabaseNotOpenException {
      printResponse('Database is not not open.');
    }

    printPrompt();
  }
}

void printPrompt() {
  stdout.write('>>> ');
}

void printResponse(String response) {
  print('-- $response');
}

bool validator(String str) {
  return str.trim().isEmpty || str.trim().endsWith(';');
}

void printStringList(List<String> list) {
  print(list);
}

void printJson(Object? value) {
  print(const JsonEncoder.withIndent('  ').convert(value));
}

void printResult(Result result) {
  printJson(result.toPlainMap());
}

Future<void> initCouchbaseLite() async {
  await CouchbaseLiteDart.init(edition: Edition.enterprise);

  // Suppress warning that file logging is not configured.
  Database.log.console.level = LogLevel.error;
}

void setDbLocation(String path) {
  dbName = p.basename(path);
  dbDirectory = p.dirname(path);
}

Database useDb() {
  if (db == null) {
    throw DatabaseNotOpenException();
  }
  return db!;
}

Future<Database> openDatabase(String dbName, String dbDirectory) async {
  return await Database.openAsync(
    dbName,
    DatabaseConfiguration(directory: dbDirectory),
  );
}

Future<void> deleteDatabase(Database db) async {
  await db.delete();
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

  print('Document ${doc.id} stored:');
  printJson(doc.toPlainMap());
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
    printResult(result);
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
    printResult(result);
  }

  print('$documentCount documents found');
}

class DatabaseNotOpenException implements Exception {}
