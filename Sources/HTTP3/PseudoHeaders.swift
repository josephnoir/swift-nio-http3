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

package import HTTPTypes

extension HTTPField.Name {
    package static var method: HTTPField.Name { .init(parsed: ":method")! }
    package static var scheme: HTTPField.Name { .init(parsed: ":scheme")! }
    package static var authority: HTTPField.Name { .init(parsed: ":authority")! }
    package static var path: HTTPField.Name { .init(parsed: ":path")! }
    package static var status: HTTPField.Name { .init(parsed: ":status")! }
}
