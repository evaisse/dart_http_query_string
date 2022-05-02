import 'dart:async';
import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:http_query_string/http_query_string.dart';

typedef _GetIOIn = String Function();
typedef _WriteIOOut = Function(String out);

CommandRunner createCommandRunner(
    {required _GetIOIn stdin,
    required _WriteIOOut stdout,
    required _WriteIOOut stderr}) {
  return CommandRunner("http_query_string",
      "A encoder/decoder for http query string to JSON and vice versa.")
    ..addCommand(EncodeCommand(stdin: stdin, stdout: stdout, stderr: stderr))
    ..addCommand(DecodeCommand(stdin: stdin, stdout: stdout, stderr: stderr));
}

class EncodeCommand extends Command {
  final name = 'encode';
  final _GetIOIn stdin;
  final _WriteIOOut stdout;
  final _WriteIOOut stderr;

  EncodeCommand(
      {required this.stdin, required this.stdout, required this.stderr});

  @override
  String get description =>
      'Encode given JSON object from stdin into a http query string';

  @override
  FutureOr<int> run() async {
    if (argResults == null) {
      return 1;
    }

    try {
      if (argResults!.arguments.isEmpty) {
        throw Exception('First argument is mandatory');
      }
      var json = argResults!.arguments[0];
      var object = JsonDecoder().convert(json);
      if (!(object is Map<String, dynamic>))
        throw Exception(
            'Invalid root input, you can only serialize a hash map at root level like {"foo": "bar"}, ${object.runtimeType} given.');
      stdout(Encoder().convert(object));
      return 0;
    } catch (e) {
      stderr("ERR: $e");
      return 1;
    }
  }
}

class DecodeCommand extends Command {
  final name = 'decode';

  final _GetIOIn stdin;
  final _WriteIOOut stdout;
  final _WriteIOOut stderr;

  @override
  // TODO: implement description
  String get description => 'Decode given http query string into a JSON object';

  DecodeCommand(
      {required this.stdin, required this.stdout, required this.stderr}) {
    argParser.addFlag('pretty-print', defaultsTo: true);
  }

  @override
  FutureOr<int> run() async {
    try {
      var json = Decoder().convert(argResults?.arguments.first ?? '');
      var encoder = (argResults!['pretty-print'] as bool)
          ? JsonEncoder.withIndent('  ')
          : JsonEncoder();
      stdout(encoder.convert(json));
      return 0;
    } catch (e) {
      stderr("$e");
      return 1;
    }
  }
}
