//
//  KeychainManager.swift
//  TripJournal
//
//  Created by huynh on 11/9/24.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()

    private let serviceName = "com.TripJournal.service"
    private let accountName = "authToken"

    @Published 
    private var token: Token? {
        didSet {
            if let token = token {
                try? saveToken(token)
            } else {
                try? deleteToken()
            }
        }
    }

    private init() {}

    func saveToken(_ token: Token) throws {
        let tokenData = try JSONEncoder().encode(token)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary) // Delete any existing item
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unableToSaveToken
        }
    }

    func getToken() throws -> Token? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess else {
            return nil
        }

        guard let data = dataTypeRef as? Data else {
            return nil
        }

        return try JSONDecoder().decode(Token.self, from: data)
    }

    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unableToDeleteToken
        }
    }

    enum KeychainError: Error {
        case unableToSaveToken
        case unableToDeleteToken
    }
}
