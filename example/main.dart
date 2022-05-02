import 'package:http_query_string/http_query_string.dart';

void main() {
  var encoder = Encoder();

  var qs = encoder.convert({
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
  });

  print(qs);

  var decoder = Decoder();
  var newObject = decoder.convert(qs);

  print(newObject);
}
