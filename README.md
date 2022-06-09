# couchbase-lite-dart-cli

Commandline interface Couchbase Lite POC (proof of concept) utility built with the Dart programming language.


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

![Verification with the official CBLite command-line tool](./screenshots/cblite-session-screenshot.png?raw=true)

