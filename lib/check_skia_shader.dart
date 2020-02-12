import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:li/single_arg.dart';

class CheckSkiaShader extends SinglePositionalArgCommand {
  @override
  String get description => 'Find out if a Skia shader cache is binary or SkSL';

  @override
  String get name => 'check_skia_shader';

  @override
  String get argName => 'cache-file-path-or-directory';

  @override
  Future<void> run() async {
    checkArgCount();

    final String path = argResults.rest[0];

    if (FileSystemEntity.isFileSync(path)) {
      _ShaderCacheType type = await _getSingleFileType(path);
      print('${_kTypePrettyNames[type]}');
    } else if (FileSystemEntity.isDirectorySync(path)) {
      final Directory dir = Directory(path);
      final Map<_ShaderCacheType, List<String>> typeMap = {
        _ShaderCacheType.sksl: <String>[],
        _ShaderCacheType.binary: <String>[],
        _ShaderCacheType.unknown: <String>[],
      };
      for (FileSystemEntity fileEntity in dir.listSync()) {
        typeMap[await _getSingleFileType(fileEntity.path)].add(fileEntity.path);
      }
      for (_ShaderCacheType type in _ShaderCacheType.values) {
        print('Found ${typeMap[type].length} shaders in ${_kTypePrettyNames[type]}.');
        for (String path in typeMap[type]..sort()) {
          print('  $path');
        }
        print('');
      }
    } else {
      print('$path is not a valid file or direcotry.');
    }
  }

  Future<_ShaderCacheType> _getSingleFileType(String path) async {
    final File file = File(path);
    final Uint8List bytes = await file.readAsBytes();
    final Uint8List header = bytes.sublist(0, 4);

    if (IterableEquality().equals(header, _kSkSLHeader)) {
      return _ShaderCacheType.sksl;
    } else if (IterableEquality().equals(header, _kBinaryHeader)) {
      return _ShaderCacheType.binary;
    } else {
      return _ShaderCacheType.unknown;
    }
  }

  static Uint8List _stringToBytes(String s) {
    final result = Uint8List(s.length);
    for (int i = 0; i < s.length; i += 1) {
      result[i] = s.codeUnitAt(i);
    }
    return result;
  }

  static final Uint8List _kSkSLHeader = _stringToBytes('LSKS');
  static final Uint8List _kBinaryHeader = _stringToBytes('BPLG');
}

enum _ShaderCacheType {
  sksl,
  binary,
  unknown,
}

const Map<_ShaderCacheType, String> _kTypePrettyNames = {
  _ShaderCacheType.sksl: 'SkSL type',
  _ShaderCacheType.binary: 'binary type',
  _ShaderCacheType.unknown: 'unknown type',
};
