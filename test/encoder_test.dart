import 'package:http_query_string/http_query_string.dart';
import 'package:test/test.dart';

class _CustomClass {
  @override
  String toString() => "XXX";
}

void main() {
  Map<String, Map<String, dynamic>> testItems = {
    '0=foo': {"0": 'foo'},
    'a%5B%3E%3D%5D=23': {
      "a": {'>=': '23'}
    },
    'foo=c++': {"foo": 'c  '},
    'foo=c%2B%2B': {"foo": 'c++'},
    'a+b%5B%3E%3D%26%5D=23+37%5B%5D%26': {
      'a b': {'>=&': '23 37[]&'}
    },
    'a%5B%3C%3D%3E%5D=%3D23': {
      "a": {'<=>': '=23'}
    },
    'a%5B%3D%3D%5D=23': {
      "a": {'==': '23'}
    },
    "items%5Bfoo%5B%5D=bar%5D&items%5B%5Dbar%5B%5D=foo": {
      "items": {'foo[': 'bar]', ']bar[': 'foo'}
    },
    '': {"foo": null},
    'foo=': {"foo": ''},
    'foo=1': {"foo": true},
    'foo=0': {"foo": false},
    'foo=+': {"foo": ' '},
    'foo=%09': {"foo": '\t'},
    "customClass=XXX": {"customClass": _CustomClass()},
    'foo=bar': {"foo": 'bar'},
    '+foo+=+bar+%3D+baz+': {' foo ': ' bar = baz '},
    'foo=bar&bar=baz': {"foo": 'bar', "bar": 'baz'},
    'foo2=bar2&baz2=': {"foo2": 'bar2', "baz2": ''},
    'foo=bii': {"foo": 'bii', "baz": null},
    'foo=bar&baz=': {"foo": 'bar', "baz": ''},
    'cht=p3&chd=t%3A60%2C40&chs=250x100&chl=Hello%7CWorld': {
      "cht": 'p3',
      "chd": 't:60,40',
      "chs": '250x100',
      "chl": 'Hello|World'
    },
    'foo%5B0%5D=1&foo%5B1%5D=X': {
      'foo': [1, 'X'],
    },
    'foo%5B0%5D=1&foo%5B1%5D=X&foo%5Bbar%5D=4': {
      'foo': {"0": 1, "1": "X", "bar": 4},
    },
    'encode=bar+with+space&int=42&float=42.367&negative=-23&true=1&false=0&set%5B0%5D=a&set%5B1%5D=b&list%5B0%5D=bar&list%5B1%5D=foo&map%5Bkey%5D=value':
        {
      "encode": "bar with space",
      "int": 42,
      "float": 42.367,
      "negative": -23,
      "true": true,
      "false": false,
      "null": null,
      "set": {"a", "b"},
      "list": [
        "bar",
        "foo",
      ],
      "map": {"key": "value"},
    }
  };

  group('test decoder', () {
    testItems.forEach((key, value) {
      test('encode and expect $key', () {
        var encoder = Encoder();
        expect(encoder.convert(value), key,
            reason: 'Encoding should output the same for $key');
      });
    });
  });
}
