# Couchbase Lite Dart CLI

Interactive command line interface Couchbase Lite REPL utility built with the Dart programming language.

This code uses the [cbl-dart community package](https://pub.dev/packages/cbl) which implements Couchbase Lite for Dart and Flutter. 

* [https://pub.dev/packages/cbl](https://pub.dev/packages/cbl)
* [https://github.com/cbl-dart/cbl-dart](https://github.com/cbl-dart/cbl-dart)




### How to run the program:

`
$ dart cli/bin/cli.dart db/MY_TEST_DB
`

Or,

`
$ dart compile exe cli/bin/cli.dart
`

`
$ cli/bin/cli.exe db/MY_TEST_DB
`

Then do:

`
open;
`

`
save; some freetext...
`

`
list;
`

`
listall;
`

`
close;
`

`
quit;
`


### An example Dart CLI session

![An example Dart CLI session](./screenshots/dart-cli-session-screenshot.png?raw=true)


### Verification with the official CBLite command-line tool

[cblite Tool Documentation](https://github.com/couchbaselabs/couchbase-mobile-tools/blob/master/Documentation.md)

`
cblite ls --body db/MY_TEST_DB.cblite2
`

![Verification with the official CBLite command-line tool](./screenshots/cblite-session-screenshot.png?raw=true)

