# http_query_string

[![Build status](https://github.com/evaisse/dart_http_query_string/actions/workflows/dart.yml/badge.svg)](https://github.com/evaisse/dart_http_query_string/actions)
[![codecov](https://codecov.io/gh/evaisse/dart_http_query_string/branch/master/graph/badge.svg?token=MHN3KFE7QE)](https://codecov.io/gh/evaisse/dart_http_query_string)

A RFC1867 compliant query string encoder and decoder, compatible with the PHP & jQuery traditional syntax for nested array/objects.

Inspired by : 

 - PHP function [`http_build_query()`](https://www.php.net/manual/en/function.http-build-query.php) & [`parse_str()`](https://www.php.net/manual/en/function.parse-str.php)
 - nodejs [`qs` package](https://www.npmjs.com/package/qs)


```dart
import 'package:http_query_string/http_query_string.dart';

void main() {
  var decoder = Decoder();
  print(decoder.convert("foo=bar&list%5B0%5D=bar&list%5B1%5D=foo&list%5B2%5D%5Bkey%5D=value"));
}
```

Will print out something like that 

```json
{
  "foo": "bar",
  "list": [
    "bar",
    "foo",
    {"key": "value"}
  ]
}
```

And vice versa : 

```dart
import 'package:http_query_string/http_query_string.dart';

void main() {
  print(Encoder().convert(<String, dynamic>{
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
      "map": {
        "key": "value"
      },
  }));
}
```

Will output 

````
'encode=bar+with+space&int=42&float=42.367&negative=-23&true=1&false=0&set%5B0%5D=a&set%5B1%5D=b&list%5B0%5D=bar&list%5B1%5D=foo&map%5Bkey%5D=value'
````