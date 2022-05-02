import 'package:http_query_string/http_query_string.dart';
import 'package:test/test.dart';

void main() {
  Map<String, Map<String, dynamic>> testItems = {
    "idxList[0]=0&idxList[2]=2&idxList[-3]=3": {
      "idxList": ["3", "0", "2"],
    },
    "list2%5B%5D=bar&list2%5B%5D=foo&list2%5B%5D%5Bkey%5D=value": {
      "list2": [
        "bar",
        "foo",
        {"key": "value"}
      ]
    },
    "list%5B0%5D=bar&list%5B1%5D=foo&list%5B2%5D%5Bkey%5D=value": {
      "list": [
        "bar",
        "foo",
        {"key": "value"}
      ]
    },
    "items2%5Bfoo%5B%5D%3Dbar%5D=&items2%5B%5Dbar%5B%5D=foo": {
      "items2": {
        'foo[': '',
        '0': ['foo']
      },
    },
    "items3%5Bfoo%5B%5D=bar%5D&items3%5B%5Dbar%5B%5D=foo": {
      'items3': {
        'foo[': 'bar]',
        '0': ['foo']
      },
    },
    "foo%5Ba%5D=1&bar%5B0%5D=a&bar%5B1%5D=b&bar%5B2%5D=c&some%5Btest34%5D=34&some%5Bjohn%5D=doe":
        {
      "foo": {"a": "1"},
      "bar": ["a", "b", "c"],
      "some": {"test34": "34", "john": "doe"}
    },
    'foo%5B0%5D=A&foo%5B1%5D=X': {
      'foo': ['A', 'X'],
    },
    'foo=bar&john=doe': {"foo": 'bar', 'john': 'doe'},
    'foo=': {"foo": ''},
    'foo=+': {"foo": ' '},
    'foo=%09': {"foo": '\t'},
    'foo=bar': {"foo": 'bar'},
    '+foo+=+bar+%3D+baz+': {' foo ': ' bar = baz '},
    'foo=bar&bar=baz': {"foo": 'bar', "bar": 'baz'},
    'foo2=bar2&baz2=': {"foo2": 'bar2', "baz2": ''},
    'foo=bar&baz=': {"foo": 'bar', "baz": ''},
    '0=foo': {"0": 'foo'},
    'a%5B%3E%3D%5D=23': {
      "a": {'>=': '23'}
    },
    'cht=p3&chd=t%3A60%2C40&chs=250x100&chl=Hello%7CWorld': {
      "cht": 'p3',
      "chd": 't:60,40',
      "chs": '250x100',
      "chl": 'Hello|World'
    },
    'foo%5B0%5D=1&foo%5B1%5D=X&foo%5Bbar%5D=4': {
      'foo': {"0": '1', "1": "X", "bar": '4'},
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
    "subsub%5Bbar%5D=1&subsub%5Bfoo%5D%5Bbar%5D=23": {
      "subsub": {
        "bar": "1",
        "foo": {
          "bar": "23",
        },
      },
    },
  };

  group('test decoder', () {
    testItems.forEach((key, value) {
      test('parse $key', () {
        var decoder = Decoder();
        expect(decoder.convert(key), value,
            reason: 'Decoding should output the same for $key');
      });
    });
  });
}
