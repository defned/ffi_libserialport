// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:ffi_libserialport/libserialport.dart';

final dataDir = path.join(Directory.current.path, 'testdata');

void createIsolate(SendPort port) {
  SerialPort sp = SerialPort(SerialPort.getAvailablePorts()[0]);
  sp.open();
  // sp.onRead.listen((onData) {
  sp.onData = (onData) {
    String data = String.fromCharCodes(onData);
    print("[ISOLATE] data: " + data);
    port.send(data);
  };
  // );
}

void main() async {
  ReceivePort replyPort = ReceivePort();
  Isolate i = await Isolate.spawn(createIsolate, replyPort.sendPort);

  // test('version', () {
  //   expect(sp.version, isNotEmpty);
  // });

  group('model', () {
    test('List ports', () {
      int mutex;
      replyPort.listen((onData) {
        print("Card input has arrived: " + onData);
        i.kill(priority: Isolate.immediate);
        mutex = 0;
      }, onDone: () {
        print("done!");
      });
      while (mutex == null) {
        sleep(Duration(milliseconds: 1000));
        print("Waiting for card input ... ");
      }
    });
  });
}
