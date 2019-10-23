// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// LibSerialPort for Dart
library libserialport;

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:ffi_libserialport/src/ffi/helper.dart';

import 'src/bindings/bindings.dart';
import 'src/bindings/types.dart';

class SerialPort {
  // static int _kMaxSmi64 = (1 << 62) - 1;
  // static int _kMaxSmi32 = (1 << 30) - 1;
  // static int _maxSize = sizeOf<IntPtr>() == 8 ? _kMaxSmi64 : _kMaxSmi32;

  Pointer<Pointer<SpPort>> _ttyFd = nullptr;

  /// Getter for open connection
  bool get isOpen => _ttyFd != nullptr;

  /// Getter for file descriptor (just for debug)
  Pointer<Pointer<SpPort>> get fd => _ttyFd;

  // Last error code
  int get error => _error;
  int _error;

  // Name of device on which the connection is made
  final String portName;
  // Connexion speed
  final int baudrate;
  // Number of data bits in each character
  final int databits;
  // Method of detecting errors in transmission
  final int parity;
  // Bits sent at the end of every character allow the receiving signal hardware to detect the end of a character
  final int stopbits;
  // Delay betwween to read in millis
  final int delay;
  Duration _delay;

  final StreamController<Uint8List> _onReadController =
      StreamController<Uint8List>();

  /// Read data send from the serial port
  Stream<Uint8List> get onRead => _onReadController.stream;

  SerialPort(this.portName,
      {this.baudrate: 9600,
      this.databits: 8,
      this.parity: SpParity.NONE,
      this.stopbits: 0,
      this.delay: 0}) {
    _delay = Duration(milliseconds: delay);
  }

  /// Version information.
  String get version => Utf8.fromUtf8(SpVersion());

  /// Retrieves with the system wide available ports
  static List<String> getAvailablePorts() {
    List<String> portList = [];
    Pointer<Pointer<Pointer<SpPort>>> ports = allocate();

    int status = sp_list_ports(ports);
    if (status != SpReturn.OK)
      throw Exception("($status) No serial devices detected");

    final Pointer<Pointer<SpPort>> refPorts = ports.value;
    for (int i = 0; isNotNull(refPorts.elementAt(i).value); i++) {
      portList.add(Utf8.fromUtf8(refPorts.elementAt(i).value.ref.name));
    }

    sp_free_port_list(ports.value);
    free(ports);
    return portList;
  }

  /// Open the connection and read
  void open() {
    if (isOpen) {
      throw "$portName is already opened";
    }

    _ttyFd = allocate();
    Pointer<Utf8> name = Utf8.toUtf8(portName);

    if ((_error = sp_get_port_by_name(name, _ttyFd)) != SpReturn.OK) {
      free(_ttyFd);
      _ttyFd = nullptr;
      throw "(sp_get_port_by_name) $portName : $error";
    }

    if ((_error = sp_open(_ttyFd.value, SpMode.READ)) != SpReturn.OK) {
      free(_ttyFd);
      _ttyFd = nullptr;
      throw "(sp_open) $portName : $error";
    }

    sp_set_baudrate(_ttyFd.value, baudrate);
    sp_set_bits(_ttyFd.value, databits);
    sp_set_stopbits(_ttyFd.value, stopbits);
    sp_set_parity(_ttyFd.value, parity);

    Timer(_delay, _readBlocking);
    return;
  }

  /// Close the connection
  void close() {
    _checkOpen();

    if ((_error = sp_close(_ttyFd.value)) != SpReturn.OK) {
      free(_ttyFd);
      _ttyFd = nullptr;
      throw "(sp_close) $portName : $error";
    }

    _onReadController.close();
  }

  // void _readNonBlocking() {
  //   if (!isOpen) return;

  //   sp_flush(_ttyFd.value, SpBuffer.INPUT);

  //   while (true) {
  //     int bytesWaiting = sp_input_waiting(_ttyFd.value);
  //     if (bytesWaiting > 0) {
  //       print('Bytes waiting $bytesWaiting');
  //       Pointer<Uint8> byteBuff = allocate(count: 512);
  //       int byteNum = sp_nonblocking_read(_ttyFd.value, byteBuff.cast(), 512);

  //       if (byteNum < 0) {
  //         // cleanup ...
  //         throw "(sp_blocking_read) $portName : $byteNum";
  //       }

  //       print(String.fromCharCodes((byteBuff.asTypedList(byteNum))));

  //       if (!_onReadController.isClosed) {
  //         _onReadController.add(byteBuff.asTypedList(byteNum));
  //       }

  //       free(byteBuff);

  //       break;
  //     } else
  //       sleep(_delay);
  //   }
  // }

  void _readBlocking() {
    if (!isOpen) return;

    sp_flush(_ttyFd.value, SpBuffer.INPUT);

    _waitForEvent();

    int bytesWaiting = sp_input_waiting(_ttyFd.value);
    if (bytesWaiting > 0) {
      print('Bytes waiting $bytesWaiting');
      Pointer<Uint8> byteBuff = allocate(count: 512);
      int byteNum = sp_blocking_read(_ttyFd.value, byteBuff.cast(), 512, 10);

      if (byteNum < 0) {
        // cleanup ...
        throw "(sp_blocking_read) $portName : $byteNum";
      }

      print(String.fromCharCodes((byteBuff.asTypedList(byteNum))));

      if (!_onReadController.isClosed) {
        _onReadController.add(byteBuff.asTypedList(byteNum));
      }

      free(byteBuff);
    }

    _readBlocking();
  }

  int _waitForEvent() {
    Pointer<Pointer<SpEventSet>> eventSet = allocate();

    if ((_error = sp_new_event_set(eventSet)) != SpReturn.OK) {
      free(eventSet);
      throw '(sp_new_event_set) $portName : $error';
    }

    if ((_error = sp_add_port_events(
            eventSet.value, _ttyFd.value, SpEvent.RX_READY | SpEvent.ERROR)) !=
        SpReturn.OK) {
      free(eventSet);
      throw '(sp_new_event_set) $portName : $error';
    }

    int res = sp_wait(eventSet.value, 10000);

    sp_free_event_set(eventSet.value);

    return res;
  }

  _checkOpen() {
    if (!isOpen) {
      throw "$portName is not opened";
    }
  }
}
