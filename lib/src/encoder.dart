import 'dart:convert';

class Encoder extends Converter<Map<String, dynamic>, String> {
  final bool strictNullHandling;

  Encoder({this.strictNullHandling = false});

  String _encodePairs(key, value) {
    return Uri.encodeQueryComponent(key) +
        '=' +
        Uri.encodeQueryComponent(value);
  }

  List<String> _encodeList(String key, List<dynamic> list) {
    var params = <String>[];
    var i = 0;
    list.forEach((element) =>
        params.addAll(_encodeValuesForKey(key + "[${i++}]", element)));
    return params;
  }

  List<String> _encodeMap(String key, Map<dynamic, dynamic> map) {
    var params = <String>[];
    map.forEach((nkey, value) {
      params.addAll(_encodeValuesForKey(key + "[" + nkey + "]", value));
    });
    return params;
  }

  List<String> _encodeValuesForKey(String key, dynamic values) {
    if (values is String) {
      return [_encodePairs(key, values)];
    } else if (values is Map) {
      return _encodeMap(key, values);
    } else if (values is Iterable) {
      return _encodeList(key, values.toList());
    } else if (values is int ||
        values is double ||
        values is num ||
        values is String) {
      return _encodeValuesForKey(key, "$values");
    } else if (values is bool) {
      return _encodeValuesForKey(key, values ? "1" : "0");
    } else if (values == null) {
      // @todo handle null type resolution by removing key of adding a `foo=''` value
      // return encodeValuesForKey(key, "");
      return [];
    } else {
      // @todo handle specific behavior for custom objects
      return _encodeValuesForKey(key, "$values");
    }
  }

  String convert(Map<String, dynamic> queryParams) {
    var params = <String>[];
    queryParams.forEach((key, value) {
      params.addAll(_encodeValuesForKey(key, value));
    });
    return params.join('&');
  }
}
