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

package import NIOQUICHelpers

extension QUICStreamID {
    package var isUnidirectional: Bool {
        switch self.type {
        case .clientInitiatedUnidirectional, .serverInitiatedUnidirectional:
            return true
        case .clientInitiatedBidirectional, .serverInitiatedBidirectional:
            return false
        }
    }

    package var isBidirectional: Bool {
        !self.isUnidirectional
    }

    package var isClientInitiated: Bool {
        switch self.type {
        case .clientInitiatedUnidirectional, .clientInitiatedBidirectional:
            return true
        case .serverInitiatedUnidirectional, .serverInitiatedBidirectional:
            return false
        }
    }

    package var isServerInitiated: Bool {
        !self.isClientInitiated
    }
}
