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

  final Repl repl = Repl(continuation: '... ', validator: validator);

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

  await for (final rawCommand in repl.runAsync()) {
    final String command =
        rawCommand.substring(0, rawCommand.length - 1).trim();
    if (command.isEmpty) continue;

    try {
      if (command == 'throw') {
        throw "-- Oh no!";
      } else if (command == 'exit') {
        printResponse("Bye bye");
        break;
      } else if (command == 'quit') {
        printResponse("Quiting!");
        break;
      }
      // DB operations
      else if (command.startsWith('open')) {
        final path = command.substring(4).trim();
        if (path.isNotEmpty) {
          setDbLocation(path);
        }

        if (dbName == null) {
          printResponse("No database specified");
          continue;
        }
        db = await openDatabase(dbName!, dbDirectory!);
        printResponse('Opened database at ${p.relative(db!.path!)}.');
      } else if (command == 'test') {
        await saveDocument(useDb(), rawCommand);
      } else if (command.contains('save')) {
        await saveDocument(useDb(), rawCommand);
      } else if (command == 'list') {
        await listDocuments(useDb());
      } else if (command == 'listall') {
        await listAllDocuments(useDb());
      } else if (command == 'delete') {
        await deleteDatabase(useDb());
        db = null;
      } else if (command == 'close') {
        await closeDatabase(useDb());
        db = null;
      } else {
        printResponse("Unknown command: $command");
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
