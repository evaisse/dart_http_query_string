import 'dart:convert';

class _ValueTargetPath {
  String rootKey;
  List<String> keyPath;
  String value;
  List<_ValueTargetPath> childs = [];

  _ValueTargetPath(this.rootKey, this.keyPath, this.value);

  _ValueTargetPath? popNode() {
    if (this.keyPath.isEmpty) return null;
    return _ValueTargetPath(
        this.keyPath[0], this.keyPath.sublist(1), this.value);
  }
}

class _ValueNode {
  String key;
  List<_ValueNode> childs = [];
  String? value;
  _ValueNode(this.key);
}

class Decoder extends Converter<String, Map<String, dynamic>> {
  Map<String, dynamic> convert(String queryString) {
    var valueTargets = queryString
        .split('&')
        .map((element) => parseKeyInMap(element))
        .toList();
    var nodeTree = flattenPathMap(valueTargets);
    return _convert(<String, dynamic>{}, nodeTree);
  }

  /// parse a given [element] like `foo[bar]=example` and extract split the underlying
  /// representation of multi dimensionnal arrays like
  /// `foo[gigig][aaa]=2` into a list of key path `['gigi', 'aaa']`
  _ValueTargetPath parseKeyInMap(String element) {
    var elements = element.split("=");
    var key = Uri.decodeQueryComponent(elements.first);
    var value =
        Uri.decodeQueryComponent(elements.length > 1 ? elements[1] : "");

    var subKeys = RegExp(r'\[([^\]]*)\]')
        .allMatches(key)
        .toList()
        .map((e) => e[1] ?? '')
        .toList();
    var rootKey = subKeys.isNotEmpty ? key.substring(0, key.indexOf('[')) : key;
    return _ValueTargetPath(rootKey, subKeys, value);
  }

  List<_ValueNode> flattenPathMap(List<_ValueTargetPath> targets) {
    var nodeList = <_ValueNode>[];
    var keys = targets.map((e) => e.rootKey).toSet();

    /// for each unique root key for this map/list
    for (var key in keys) {
      var node = nodeList.firstWhere((element) => element.key == key,
          orElse: () => _ValueNode(key));
      var nodeValues =
          targets.where((element) => element.rootKey == key).toList();

      /// for each value attached to a node with this root key
      for (var target in nodeValues) {
        var subNodes = [target]
            .map((e) => e.popNode())
            .whereType<_ValueTargetPath>()
            .toList();
        if (subNodes.isNotEmpty) {
          var flatSubNodes = flattenPathMap(subNodes);
          node.childs.addAll(flatSubNodes);
        } else {
          node.value = target.value;
        }
      }
      // a node cannot be without a value nor some childs
      assert(node.value != null || node.childs.isNotEmpty);
      nodeList.add(node);
    }
    return nodeList;
  }

  bool _isListKey(String key) {
    try {
      return int.tryParse(key)!=null;
    } catch (e) {
      return false;
    }
  }

  dynamic _convert(dynamic rootNode, List<_ValueNode> nodeTree) {
    assert(rootNode is Map || rootNode is List);

    for (var kv in nodeTree) {
      if (kv.childs.isNotEmpty) {
        /// this will decide if the current node should output has `Map<String, dynamic>` or `List<dynamic>`
        /// we check the keys to decide if it looks like a map or a list by looking for non numeric and empty
        /// [key] name
        var isMap = kv.childs
            .where((e) => !_isListKey(e.key) && e.key != '')
            .isNotEmpty;
        if (!isMap) {
          /// if the current node tree contains some keys like `["", "1", "0", ""]`
          /// we redraw the list indexes
          _reIndexChildList(kv.childs);
        }
        var newTree =
            _convert(isMap ? <String, dynamic>{} : <dynamic>[], kv.childs);
        _setKeyValueForNode(rootNode, kv.key, newTree);
      } else {
        _setKeyValueForNode(rootNode, kv.key, kv.value);
      }
    }

    return rootNode;
  }

  _setKeyValueForNode(dynamic node, String key, dynamic value) {
    assert(node is Map || node is List);
    if (node is Map) {
      if (key == '') key = '0';
      node[key] = value;
    } else {
      (node as List).add(value);
    }
  }

  void _reIndexChildList(List<_ValueNode> childs) {
    childs..sort((a, b) => a.key.compareTo(b.key));
    var newIndex = 0;
    childs.forEach((element) {
      element.key = "${newIndex++}";
    });
  }
}
