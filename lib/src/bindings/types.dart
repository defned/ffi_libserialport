// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;

class SpEventSet extends Struct {
  Pointer<Void> handles;
  
  Pointer<Int32> masks;
  
  @Int32()
  int count;
}

class SpPort extends Struct {
  Pointer<ffi.Utf8> name;
}

class SpPortConfig extends Struct {
  // SpPortConfig();

  static Pointer<SpPortConfig> allocate(int baudrate, int bits) {
    Pointer<SpPortConfig> instance = ffi.allocate();
    instance.ref..baudrate = baudrate..bits = bits;

    return instance;
  }

  @Int32()
  int baudrate;
  @Int32()
  int bits;
  @Int32()
  int parity;
  @Int32()
  int stopbits;
  @Int32()
  int rts;
  @Int32()
  int cts;
  @Int32()
  int dtr;
  @Int32()
  int dsr;
  @Int32()
  int xon_xoff;
}

/** Return values. */
class SpReturn {
  /** Operation completed successfully. */
  static const OK = 0;
  /** Invalid arguments were passed to the function. */
  static const ERR_ARG = -1;
  /** A system error occurred while executing the operation. */
  static const ERR_FAIL = -2;
  /** A memory allocation failed while executing the operation. */
  static const ERR_MEM = -3;
  /** The requested operation is not supported by this system or device. */
  static const ERR_SUPP = -4;
}

/** Port access modes. */
class SpMode {
  /** Open port for read access. */
  static const READ = 1;
  /** Open port for write access. */
  static const WRITE = 2;
  /** Open port for read and write access. @since 0.1.1 */
  static const READ_WRITE = 3;
}

/** Port events. */
class SpEvent {
  /** Data received and ready to read. */
  static const RX_READY = 1;
  /** Ready to transmit new data. */
  static const TX_READY = 2;
  /** Error occurred. */
  static const ERROR = 4;
}

/** Buffer selection. */
class SpBuffer {
  /** Input buffer. */
  static const INPUT = 1;
  /** Output buffer. */
  static const OUTPUT = 2;
  /** Both buffers. */
  static const BOTH = 3;
}

/** Parity settings. */
class SpParity {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** No parity. */
  static const NONE = 0;
  /** Odd parity. */
  static const ODD = 1;
  /** Even parity. */
  static const EVEN = 2;
  /** Mark parity. */
  static const MARK = 3;
  /** Space parity. */
  static const SPACE = 4;
}

/** RTS pin behaviour. */
class SpRTS {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** RTS off. */
  static const OFF = 0;
  /** RTS on. */
  static const ON = 1;
  /** RTS used for flow control. */
  static const FLOW_CONTROL = 2;
}

/** CTS pin behaviour. */
class SpCTS {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** CTS ignored. */
  static const IGNORE = 0;
  /** CTS used for flow control. */
  static const FLOW_CONTROL = 1;
}

/** DTR pin behaviour. */
class SpDTR {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** DTR off. */
  static const OFF = 0;
  /** DTR on. */
  static const ON = 1;
  /** DTR used for flow control. */
  static const FLOW_CONTROL = 2;
}

/** DSR pin behaviour. */
class SpDSR {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** DSR ignored. */
  static const IGNORE = 0;
  /** DSR used for flow control. */
  static const FLOW_CONTROL = 1;
}

/** XON/XOFF flow control behaviour. */
class SpXONXOFF {
  /** Special value to indicate setting should be left alone. */
  static const INVALID = -1;
  /** XON/XOFF disabled. */
  static const DISABLED = 0;
  /** XON/XOFF enabled for input only. */
  static const IN = 1;
  /** XON/XOFF enabled for output only. */
  static const OUT = 2;
  /** XON/XOFF enabled for input and output. */
  static const INOUT = 3;
}

/** Standard flow control combinations. */
class SpFlowControl {
  /** No flow control. */
  static const NONE = 0;
  /** Software flow control using XON/XOFF characters. */
  static const XONXOFF = 1;
  /** Hardware flow control using RTS/CTS signals. */
  static const RTSCTS = 2;
  /** Hardware flow control using DTR/DSR signals. */
  static const DTRDSR = 3;
}

/** Input signals. */
class SpSignal {
  /** Clear to send. */
  static const CTS = 1;
  /** Data set ready. */
  static const DSR = 2;
  /** Data carrier detect. */
  static const DCD = 4;
  /** Ring indicator. */
  static const RI = 8;
}

/**
 * Transport types.
 *
 * @since 0.1.1
 */
class SpTransport {
  /** Native platform serial port. @since 0.1.1 */
  static const NATIVE = 1;
  /** USB serial port adapter. @since 0.1.1 */
  static const USB = 1;
  /** Bluetooth serial port adapter. @since 0.1.1 */
  static const BLUETOOTH = 2;
}
