// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Version information for the LibSerialPort library.
Pointer<Utf8> Function() SpVersion = splib
    .lookup<NativeFunction<_sp_native_t>>('sp_get_package_version_string')
    .asFunction();

typedef _sp_native_t = Pointer<Utf8> Function();

/**
 * @defgroup Enumeration Port enumeration
 *
 * Enumerating the serial ports of a system.
 *
 * @{
 */

/**
 * Obtain a pointer to a new sp_port structure representing the named port.
 *
 * The user should allocate a variable of type "struct sp_port *" and pass a
 * pointer to this to receive the result.
 *
 * The result should be freed after use by calling sp_free_port().
 *
 * @param[in] portname The OS-specific name of a serial port. Must not be NULL.
 * @param[out] port_ptr If any error is returned, the variable pointed to by
 *                      port_ptr will be set to NULL. Otherwise, it will be set
 *                      to point to the newly allocated port. Must not be NULL.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_get_port_by_name(const char *portname, struct sp_port **port_ptr);
int Function(Pointer<Utf8> portname, Pointer<Pointer<SpPort>> port_ptr)
    sp_get_port_by_name = splib
        .lookup<NativeFunction<_sp_get_port_by_name_native_t>>(
            'sp_get_port_by_name')
        .asFunction();
typedef _sp_get_port_by_name_native_t = Int32 Function(
    Pointer<Utf8> portname, Pointer<Pointer<SpPort>> port_ptr);

/**
 * Free a port structure obtained from sp_get_port_by_name() or sp_copy_port().
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 *
 * @since 0.1.0
 */
// void sp_free_port(struct sp_port *port);
int Function(Pointer<SpPort> port) sp_free_port = splib
    .lookup<NativeFunction<_sp_free_port_native_t>>('sp_free_port')
    .asFunction();
typedef _sp_free_port_native_t = Int32 Function(Pointer<SpPort> port);

/**
 * List the serial ports available on the system.
 *
 * The result obtained is an array of pointers to sp_port structures,
 * terminated by a NULL. The user should allocate a variable of type
 * "struct sp_port **" and pass a pointer to this to receive the result.
 *
 * The result should be freed after use by calling sp_free_port_list().
 * If a port from the list is to be used after freeing the list, it must be
 * copied first using sp_copy_port().
 *
 * @param[out] list_ptr If any error is returned, the variable pointed to by
 *                      list_ptr will be set to NULL. Otherwise, it will be set
 *                      to point to the newly allocated array. Must not be NULL.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_list_ports(struct sp_port ***list_ptr);
int Function(Pointer<Pointer<Pointer<SpPort>>> list_ptr) sp_list_ports = splib
    .lookup<NativeFunction<_sp_list_ports_native_t>>('sp_list_ports')
    .asFunction();
typedef _sp_list_ports_native_t = Int32 Function(
    Pointer<Pointer<Pointer<SpPort>>> list_ptr);

/**
 * Free a port list obtained from sp_list_ports().
 *
 * This will also free all the sp_port structures referred to from the list;
 * any that are to be retained must be copied first using sp_copy_port().
 *
 * @param[in] ports Pointer to a list of port structures. Must not be NULL.
 *
 * @since 0.1.0
 */
// void sp_free_port_list(struct sp_port **ports);
void Function(Pointer<Pointer<SpPort>> ports) sp_free_port_list = splib
    .lookup<NativeFunction<_sp_free_port_list_native_t>>('sp_free_port_list')
    .asFunction();
typedef _sp_free_port_list_native_t = Void Function(
    Pointer<Pointer<SpPort>> ports);

/**
 * @}
 * @defgroup Ports Port handling
 *
 * Opening, closing and querying ports.
 *
 * @{
 */

/**
 * Open the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] flags Flags to use when opening the serial port.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_open(struct sp_port *port, enum sp_mode flags);
int Function(Pointer<SpPort> port, int flags) sp_open =
    splib.lookup<NativeFunction<_sp_open_native_t>>('sp_open').asFunction();
typedef _sp_open_native_t = Int32 Function(Pointer<SpPort> port, Int32 flags);

/**
 * Close the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_close(struct sp_port *port);
int Function(Pointer<SpPort> port) sp_close =
    splib.lookup<NativeFunction<_sp_close_native_t>>('sp_close').asFunction();
typedef _sp_close_native_t = Int32 Function(Pointer<SpPort> port);

/**
 * Set the baud rate for the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] baudrate Baud rate in bits per second.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_set_baudrate(struct sp_port *port, int baudrate);
int Function(Pointer<SpPort> port, int baudrate) sp_set_baudrate = splib
    .lookup<NativeFunction<_sp_set_baudrate_native_t>>('sp_set_baudrate')
    .asFunction();
typedef _sp_set_baudrate_native_t = Int32 Function(
    Pointer<SpPort> port, Int32 baudrate);

/**
 * Set the data bits for the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] bits Number of data bits.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_set_bits(struct sp_port *port, int bits);
int Function(Pointer<SpPort> port, int baudrate) sp_set_bits = splib
    .lookup<NativeFunction<_sp_set_bits_native_t>>('sp_set_bits')
    .asFunction();
typedef _sp_set_bits_native_t = Int32 Function(
    Pointer<SpPort> port, Int32 bits);

/**
 * Set the parity setting for the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] parity Parity setting.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_set_parity(struct sp_port *port, enum sp_parity parity);
int Function(Pointer<SpPort> port, int baudrate) sp_set_parity = splib
    .lookup<NativeFunction<_sp_set_parity_native_t>>('sp_set_parity')
    .asFunction();
typedef _sp_set_parity_native_t = Int32 Function(
    Pointer<SpPort> port, Int32 parity);

/**
 * Set the stop bits for the specified serial port.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] stopbits Number of stop bits.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_set_stopbits(struct sp_port *port, int stopbits);
int Function(Pointer<SpPort> port, int baudrate) sp_set_stopbits = splib
    .lookup<NativeFunction<_sp_set_stopbits_native_t>>('sp_set_stopbits')
    .asFunction();
typedef _sp_set_stopbits_native_t = Int32 Function(
    Pointer<SpPort> port, Int32 stopbits);

/**
 * Gets the number of bytes waiting in the input buffer.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 *
 * @return Number of bytes waiting on success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_input_waiting(struct sp_port *port);
int Function(Pointer<SpPort> port) sp_input_waiting = splib
    .lookup<NativeFunction<_sp_input_waiting_native_t>>('sp_input_waiting')
    .asFunction();
typedef _sp_input_waiting_native_t = Int32 Function(Pointer<SpPort> port);

/**
 * Read bytes from the specified serial port, without blocking.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[out] buf Buffer in which to store the bytes read. Must not be NULL.
 * @param[in] count Maximum number of bytes to read.
 *
 * @return The number of bytes read on success, or a negative error code. The
 *         number of bytes returned may be any number from zero to the maximum
 *         that was requested.
 *
 * @since 0.1.0
 */
// enum sp_return sp_nonblocking_read(struct sp_port *port, void *buf, size_t count);
int Function(Pointer<SpPort> port, Pointer<Void> buf, int count)
    sp_nonblocking_read = splib
        .lookup<NativeFunction<_sp_nonblocking_read_native_t>>(
            'sp_nonblocking_read')
        .asFunction();
typedef _sp_nonblocking_read_native_t = Int32 Function(
    Pointer<SpPort> port, Pointer<Void> buf, Int32 count);

/**
 * Read bytes from the specified serial port, blocking until complete.
 *
 * @warning If your program runs on Unix, defines its own signal handlers, and
 *          needs to abort blocking reads when these are called, then you
 *          should not use this function. It repeats system calls that return
 *          with EINTR. To be able to abort a read from a signal handler, you
 *          should implement your own blocking read using sp_nonblocking_read()
 *          together with a blocking method that makes sense for your program.
 *          E.g. you can obtain the file descriptor for an open port using
 *          sp_get_port_handle() and use this to call select() or pselect(),
 *          with appropriate arrangements to return if a signal is received.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[out] buf Buffer in which to store the bytes read. Must not be NULL.
 * @param[in] count Requested number of bytes to read.
 * @param[in] timeout_ms Timeout in milliseconds, or zero to wait indefinitely.
 *
 * @return The number of bytes read on success, or a negative error code. If
 *         the number of bytes returned is less than that requested, the
 *         timeout was reached before the requested number of bytes was
 *         available. If timeout is zero, the function will always return
 *         either the requested number of bytes or a negative error code.
 *
 * @since 0.1.0
 */
// enum sp_return sp_blocking_read(struct sp_port *port, void *buf, size_t count, unsigned int timeout_ms);
int Function(Pointer<SpPort> port, Pointer<Void> buf, int count, int timeout_ms)
    sp_blocking_read = splib
        .lookup<NativeFunction<_sp_blocking_read_native_t>>('sp_blocking_read')
        .asFunction();
typedef _sp_blocking_read_native_t = Int32 Function(
    Pointer<SpPort> port, Pointer<Void> buf, Int32 count, Uint16 timeout_ms);

/**
 * Flush serial port buffers. Data in the selected buffer(s) is discarded.
 *
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] buffers Which buffer(s) to flush.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_flush(struct sp_port *port, enum sp_buffer buffers);
int Function(Pointer<SpPort> port, int buffers) sp_flush =
    splib.lookup<NativeFunction<_sp_flush_native_t>>('sp_flush').asFunction();
typedef _sp_flush_native_t = Int32 Function(
    Pointer<SpPort> port, Int32 buffers);

/**
 * @}
 *
 * @defgroup Waiting Waiting
 *
 * Waiting for events and timeout handling.
 *
 * @{
 */

/**
 * Allocate storage for a set of events.
 *
 * The user should allocate a variable of type struct sp_event_set *,
 * then pass a pointer to this variable to receive the result.
 *
 * The result should be freed after use by calling sp_free_event_set().
 *
 * @param[out] result_ptr If any error is returned, the variable pointed to by
 *                        result_ptr will be set to NULL. Otherwise, it will
 *                        be set to point to the event set. Must not be NULL.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_new_event_set(struct sp_event_set **result_ptr);
int Function(Pointer<Pointer<SpEventSet>> event_set) sp_new_event_set = splib
    .lookup<NativeFunction<_sp_new_event_set_native_t>>('sp_new_event_set')
    .asFunction();
typedef _sp_new_event_set_native_t = Int32 Function(
    Pointer<Pointer<SpEventSet>> event_set);
/**
 * Add events to a struct sp_event_set for a given port.
 *
 * The port must first be opened by calling sp_open() using the same port
 * structure.
 *
 * After the port is closed or the port structure freed, the results may
 * no longer be valid.
 *
 * @param[in,out] event_set Event set to update. Must not be NULL.
 * @param[in] port Pointer to a port structure. Must not be NULL.
 * @param[in] mask Bitmask of events to be waited for.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_add_port_events(struct sp_event_set *event_set,
//        const struct sp_port *port, enum sp_event mask);
int Function(Pointer<SpEventSet> event_set, Pointer<SpPort> port, int mask)
    sp_add_port_events = splib
        .lookup<NativeFunction<_sp_add_port_events_native_t>>(
            'sp_add_port_events')
        .asFunction();
typedef _sp_add_port_events_native_t = Int32 Function(
    Pointer<SpEventSet> event_set, Pointer<SpPort> port, Int32 mask);

/**
 * Wait for any of a set of events to occur.
 *
 * @param[in] event_set Event set to wait on. Must not be NULL.
 * @param[in] timeout_ms Timeout in milliseconds, or zero to wait indefinitely.
 *
 * @return SP_OK upon success, a negative error code otherwise.
 *
 * @since 0.1.0
 */
// enum sp_return sp_wait(struct sp_event_set *event_set, unsigned int timeout_ms);
int Function(Pointer<SpEventSet> event_set, int timeout_ms) sp_wait =
    splib.lookup<NativeFunction<_sp_wait_native_t>>('sp_wait').asFunction();
typedef _sp_wait_native_t = Int32 Function(
    Pointer<SpEventSet> event_set, Uint16 timeout_ms);
/**
 * Free a structure allocated by sp_new_event_set().
 *
 * @param[in] event_set Event set to free. Must not be NULL.
 *
 * @since 0.1.0
 */
// void sp_free_event_set(struct sp_event_set *event_set);
void Function(Pointer<SpEventSet> event_set) sp_free_event_set = splib
    .lookup<NativeFunction<_sp_free_event_set_native_t>>('sp_free_event_set')
    .asFunction();
typedef _sp_free_event_set_native_t = Void Function(
    Pointer<SpEventSet> event_set);
