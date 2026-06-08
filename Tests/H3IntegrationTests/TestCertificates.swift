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

import Crypto
import Foundation
import SwiftASN1
import X509

enum Credentials {
    case certificates(serverName: String, certPath: String, keyPath: String, trustRootsPath: String)
    case rawKeys(serverName: String, publicKeyPath: String, privateKeyPath: String, trustRootsPath: String)
}

enum TestCertificates {
    struct TestCertificate {
        let leaf: Certificate
        let ca: Certificate
        let privateKey: P256.Signing.PrivateKey
    }

    static func makeSelfSigned(host: String = "test-server") throws -> TestCertificate {
        let caKey = P256.Signing.PrivateKey()
        let certKey = P256.Signing.PrivateKey()

        let subject = try DistinguishedName {
            CommonName("127.0.0.1")
        }
        let caName = try DistinguishedName {
            CommonName("Test CA")
        }
        let ca = try makeCA(name: caName, privateKey: caKey)

        let cert = try self.make(
            issuerName: caName,
            issuerKey: .init(caKey),
            publicKey: .init(certKey.publicKey),
            subject: subject,
            extensions: try Certificate.Extensions {
                BasicConstraints.notCertificateAuthority

                try ExtendedKeyUsage(
                    [.serverAuth]
                )

                SubjectAlternativeNames([
                    .dnsName(host),
                    .ipAddress(ASN1OctetString(contentBytes: [127, 0, 0, 1])),
                ])
            }
        )
        return .init(leaf: cert, ca: ca, privateKey: certKey)
    }

    static func makeCA(name: DistinguishedName, privateKey: P256.Signing.PrivateKey) throws -> Certificate {
        try self.make(
            issuerName: name,
            issuerKey: .init(privateKey),
            publicKey: .init(privateKey.publicKey),
            subject: name,
            extensions: try .init {
                Critical(
                    BasicConstraints.isCertificateAuthority(maxPathLength: nil)
                )
                Critical(
                    KeyUsage(keyCertSign: true)
                )
            }
        )
    }

    static func make(
        issuerName: DistinguishedName,
        issuerKey: Certificate.PrivateKey,
        publicKey: Certificate.PublicKey,
        subject: DistinguishedName,
        extensions: Certificate.Extensions
    ) throws -> Certificate {
        let certificate = try Certificate(
            version: .v3,
            serialNumber: .init(),
            publicKey: publicKey,
            notValidBefore: .now - 365 * 24 * 3600,  // Approx. a year ago
            notValidAfter: .now + 365 * 24 * 3600,  // Approx. a year from now
            issuer: issuerName,
            subject: subject,
            signatureAlgorithm: .ecdsaWithSHA256,
            extensions: extensions,
            issuerPrivateKey: issuerKey
        )
        return certificate
    }

    static func makeOnDisk() throws -> (certPath: String, keyPath: String, trustRootsPath: String, serverName: String) {
        let serverName = "test-server"
        let certificate = try TestCertificates.makeSelfSigned(host: "test-server")
        let uuid = UUID().uuidString
        let caPath = FileManager.default.temporaryDirectory.appendingPathComponent("ca-\(uuid).pem")
        let certPath = FileManager.default.temporaryDirectory.appendingPathComponent("cert-\(uuid).pem")
        let keyPath = FileManager.default.temporaryDirectory.appendingPathComponent("key-\(uuid).pem")
        try certificate.ca.serializeAsPEM().pemString.data(using: .utf8)!.write(to: caPath)
        try certificate.leaf.serializeAsPEM().pemString.data(using: .utf8)!.write(to: certPath)
        try certificate.privateKey.pemRepresentation.data(using: .utf8)!.write(to: keyPath)
        return (certPath.path, keyPath.path, caPath.path, serverName)
    }

    static func makeOnDiskWithKeys() throws -> (
        certPath: String, privateKeyPath: String, publicKeyPath: String, trustRootsPath: String, serverName: String
    ) {
        let serverName = "test-server"
        let certificate = try TestCertificates.makeSelfSigned(host: "test-server")
        let uuid = UUID().uuidString
        let caPath = FileManager.default.temporaryDirectory.appendingPathComponent("ca-\(uuid).pem")
        let certPath = FileManager.default.temporaryDirectory.appendingPathComponent("cert-\(uuid).pem")
        let privateKeyPath = FileManager.default.temporaryDirectory.appendingPathComponent("private-key-\(uuid).der")
        let publicKeyPath = FileManager.default.temporaryDirectory.appendingPathComponent("public-key-\(uuid).der")
        try certificate.ca.serializeAsPEM().pemString.data(using: .utf8)!.write(to: caPath)
        try certificate.leaf.serializeAsPEM().pemString.data(using: .utf8)!.write(to: certPath)
        try certificate.privateKey.derRepresentation.write(to: privateKeyPath)
        try certificate.privateKey.publicKey.derRepresentation.write(to: publicKeyPath)
        return (certPath.path, privateKeyPath.path, publicKeyPath.path, caPath.path, serverName)
    }

    static func makeCredentials(for configuration: AuthenticationConfiguration) throws -> Credentials {
        switch configuration {
        case .certs:
            let (certPath, keyPath, trustRootsPath, serverName) = try self.makeOnDisk()
            return .certificates(
                serverName: serverName,
                certPath: certPath,
                keyPath: keyPath,
                trustRootsPath: trustRootsPath
            )
        case .keys:
            let (_, privateKeyPath, publicKeyPath, trustRootsPath, serverName) = try self.makeOnDiskWithKeys()
            return .rawKeys(
                serverName: serverName,
                publicKeyPath: publicKeyPath,
                privateKeyPath: privateKeyPath,
                trustRootsPath: trustRootsPath
            )
        }
    }
}

enum AuthenticationConfiguration {
    case certs
    case keys
}
