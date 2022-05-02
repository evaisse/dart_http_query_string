import 'package:http_query_string/src/commands.dart';
import 'package:test/test.dart';

void main() {
  test('encode', () async {
    var stdoutStack = <String>[];
    var stderrStack = <String>[];

    var runner = createCommandRunner(
      stdin: () => '',
      stdout: (a) => stdoutStack.add(a),
      stderr: (a) => stderrStack.add(a),
    );

    var res;

    res = await runner.run(['encode', '{"a": "b"}']);
    expect(res, 0);
    res = await runner.run(['encode', '[badjsoon]']);
    expect(res, 1);
    expect(stderrStack.length, 1);
    expect(stderrStack.last.contains('FormatException'), true);

    res = await runner.run(['encode', '["a"]']);
    expect(res, 1);
    expect(stderrStack.last.contains('Invalid root input'), true);

    res = await runner.run(['encode', '']);
    expect(res, 1);

    res = await runner.run(['encode']);
    expect(res, 1);
  });

  test('decode', () async {
    var stdoutStack = <String>[];
    var stderrStack = <String>[];

    var runner = createCommandRunner(
      stdin: () => '',
      stdout: (a) => stdoutStack.add(a),
      stderr: (a) => stderrStack.add(a),
    );

    var res;

    res = await runner.run(['decode', 'foo=bar&toto=gogo']);
    expect(res, 0);
    expect(stdoutStack.last.contains('{\n'), true);
    res =
        await runner.run(['decode', 'foo=bar&toto=gogo', '--no-pretty-print']);
    expect(res, 0);
    expect(!stdoutStack.last.contains('{\n'), true);
    res = await runner.run(['decode', '']);
    expect(res, 0);

    res = await runner.run(['decode']);
    expect(res, 1);
  });
}
