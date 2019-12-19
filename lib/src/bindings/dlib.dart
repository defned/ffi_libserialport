// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of libserialport;

const Set<String> _supported = {'linux64', 'mac64', 'win64'};

/// Computes the shared object filename for this os and architecture.
///
/// Throws an exception if invoked on an unsupported platform.
String _getObjectFilename() {
  final architecture = sizeOf<IntPtr>() == 4 ? '32' : '64';
  String os, extension;
  if (Platform.isLinux) {
    os = 'linux';
    extension = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    extension = 'so';
  } else if (Platform.isWindows) {
    os = 'win';
    extension = 'dll';
  } else {
    throw Exception('Unsupported platform!');
  }

  final result = os + architecture;
  if (!_supported.contains(result)) {
    throw Exception('Unsupported platform: $result!');
  }

  return 'libserialport_c-$result.$extension';
}

/// LibSerialPort C library.
DynamicLibrary splib = (() {
  var transformUri = (String uri) {
    int pathBeg = uri.indexOf("file:///");
    if (pathBeg != null && pathBeg > 0) {
      uri = uri.substring(pathBeg);
      return Uri.parse(uri).path;
    }
    return uri;
  };

  String objectFile = "";
  List<String> searchPaths = [
    join(File(Platform.resolvedExecutable).parent.path, _getObjectFilename()),
    if (Platform.isMacOS)
      join(
          join(File(Platform.resolvedExecutable).parent.parent.path,
              "Frameworks/App.framework/Versions/A/Resources/flutter_assets/blobs/"),
          _getObjectFilename()),
    join(Directory(".").absolute.parent.path, _getObjectFilename()),
    transformUri(Platform.script
            .resolve("src/blobs/")
            .resolve(_getObjectFilename())
            .path)
        .substring(Platform.isWindows ? 1 : 0),
    transformUri(Platform.script
            .resolve("blobs/")
            .resolve(_getObjectFilename())
            .path)
        .substring(Platform.isWindows ? 1 : 0),
    transformUri(Platform.script
            .resolve("src/blobs/")
            .resolve(_getObjectFilename())
            .path)
        .substring(Platform.isWindows ? 1 : 0)
        .replaceAll("test/", "lib/"),
    transformUri(Platform.script
            .resolve("blobs/")
            .resolve(_getObjectFilename())
            .path)
        .substring(Platform.isWindows ? 1 : 0)
        .replaceAll("test/", "lib/"),
  ];

  for (int i = 0; i < searchPaths.length; i++) {
    if (File(searchPaths[i]).existsSync()) {
      objectFile = searchPaths[i];
      break;
    }
  }

  if (objectFile.isEmpty) {
    throw "libseriaport library not found at [$searchPaths]";
  }

  print("Found libserialport library at '$objectFile'");
  return DynamicLibrary.open(objectFile);
})();
