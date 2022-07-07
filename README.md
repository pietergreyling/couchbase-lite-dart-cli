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

Or,

`
exit;
`


### Some example Dart CLI sessions

![An example Dart CLI session](./screenshots/dart-cli-session-screenshot02.png?raw=true)


![An example Dart CLI session](./screenshots/dart-cli-session-screenshot.png?raw=true)


### Verification with the CBLite command-line tool

[cblite Tool Documentation](https://github.com/couchbaselabs/couchbase-mobile-tools/blob/master/Documentation.md)

`
cblite ls --body db/MY_TEST_DB.cblite2
`

![Verification with the official CBLite command-line tool](./screenshots/cblite-session-screenshot.png?raw=true)

### License

***This is not an official Couchbase supported product and is always a work in progress!***

Please feel free to create Git branches and contribute.

**[MIT License](https://opensource.org/licenses/MIT)**

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
