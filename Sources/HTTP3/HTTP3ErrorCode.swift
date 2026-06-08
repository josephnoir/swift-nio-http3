//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2026 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

/// RFC 9114 § 8.1: The following error codes are defined for use when abruptly terminating streams, aborting reading of streams, or immediately closing HTTP/3 connections.
package enum HTTP3ErrorCode: UInt64 {
    /// No error. This is used when the connection or stream needs to be closed, but there is no error to signal.
    case H3_NO_ERROR = 0x0100
    /// Peer violated protocol requirements in a way that does not match a more specific error code or endpoint declines to use the more specific error code.
    case H3_GENERAL_PROTOCOL_ERROR = 0x0101
    /// An internal error has occurred in the HTTP stack.
    case H3_INTERNAL_ERROR = 0x0102
    /// The endpoint detected that its peer created a stream that it will not accept.
    case H3_STREAM_CREATION_ERROR = 0x0103
    /// A stream required by the HTTP/3 connection was closed or reset.
    case H3_CLOSED_CRITICAL_STREAM = 0x0104
    /// A frame was received that was not permitted in the current state or on the current stream.
    case H3_FRAME_UNEXPECTED = 0x0105
    /// A frame that fails to satisfy layout requirements or with an invalid size was received.
    case H3_FRAME_ERROR = 0x0106
    /// The endpoint detected that its peer is exhibiting a behavior that might be generating excessive load.
    case H3_EXCESSIVE_LOAD = 0x0107
    /// A stream ID or push ID was used incorrectly, such as exceeding a limit, reducing a limit, or being reused.
    case H3_ID_ERROR = 0x0108
    /// An endpoint detected an error in the payload of a SETTINGS frame.
    case H3_SETTINGS_ERROR = 0x0109
    /// No SETTINGS frame was received at the beginning of the control stream.
    case H3_MISSING_SETTINGS = 0x010a
    /// A server rejected a request without performing any application processing.
    case H3_REQUEST_REJECTED = 0x010b
    /// The request or its response (including pushed response) is cancelled.
    case H3_REQUEST_CANCELLED = 0x010c
    /// The client's stream terminated without containing a fully formed request.
    case H3_REQUEST_INCOMPLETE = 0x010d
    /// An HTTP message was malformed and cannot be processed.
    case H3_MESSAGE_ERROR = 0x010e
    /// The TCP connection established in response to a CONNECT request was reset or abnormally closed.
    case H3_CONNECT_ERROR = 0x010f
    /// The requested operation cannot be served over HTTP/3. The peer should retry over HTTP/1.1.
    case H3_VERSION_FALLBACK = 0x0110

    // MARK: QPACK (RFC 9204)

    /// The decoder failed to interpret an encoded field section and is not able to continue decoding that field section.
    case QPACK_DECOMPRESSION_FAILED = 0x0200
    /// The decoder failed to interpret an encoder instruction received on the encoder stream.
    case QPACK_ENCODER_STREAM_ERROR = 0x0201
    /// The encoder failed to interpret a decoder instruction received on the decoder stream.
    case QPACK_DECODER_STREAM_ERROR = 0x0202
}
