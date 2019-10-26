// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// import 'dart:cli' as cli;
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate' show Isolate;

import 'package:ffi_libserialport/src/bindings/wait_for.dart';

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

String _platformPath(String name, {String path}) {
  if (path == null) path = "";
  if (Platform.isLinux || Platform.isAndroid)
    return path + "lib" + name + ".so";
  if (Platform.isMacOS) return path + "lib" + name + ".so";
  if (Platform.isWindows) return path + name + ".dll";
  throw Exception("Platform not implemented");
}

/// LibSerialPort C library.
DynamicLibrary splib = (() {
  String objectFile;
  if (Platform.script.path.endsWith('.snapshot')) {
    // If we're running from snapshot, assume that the shared object
    // file is a sibling.
    objectFile =
        File.fromUri(Platform.script).parent.path + '/' + _getObjectFilename();
  }
  else if (Platform.script.path.endsWith('.framework')) {
    // If we're running from snapshot, assume that the shared object
    // file is a sibling.
    objectFile =
        File.fromUri(Platform.script).parent.path + '/' + _getObjectFilename();
        print("Framework");
  } else {
    final rootLibrary = 'package:ffi_libserialport/libserialport.dart';

//     Isolate.resolvePackageUri(Uri.parse(rootLibrary)).then((s) {
// print("${Platform.script.path} $s");
//     });
    // final blobs = cli.
    //     waitFor(Isolate.resolvePackageUri(Uri.parse(rootLibrary)))
    //     .resolve('src/blobs/');
    // objectFile = blobs.resolve(_getObjectFilename()).toFilePath();
    // print(objectFile);

    // print(Platform.script.path);
    // objectFile = Platform.script
    //     .resolve('blobs/')
    //     .resolve(_getObjectFilename())
    //     .path;
    // int pathBeg = objectFile.indexOf("file:///");
    // if (pathBeg != null) objectFile = objectFile.substring(pathBeg);
    // objectFile = objectFile.replaceFirst("file:///", "/");
    // objectFile = objectFile.replaceFirst("test", "lib");
    // print(objectFile);
  }
  return DynamicLibrary.open("/Users/belakovics/Projects/BelakovicsEV/flutter-desktop-embedding/example/build/macos/Build/Products/Debug/Flutter Desktop Example.app/Contents/Frameworks/App.framework/Versions/A/Resources/flutter_assets/blobs/libserialport_c-mac64.so");
})();
