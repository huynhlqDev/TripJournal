//
//  NetworkManager.swift
//  TripJournal
//
//  Created by huynh on 12/9/24.
//

import Foundation

// MARK: Enum Network Error
enum NetworkError: Error {
    case badRequest
    case badResponse
    case failedToDecodeResponse
    case unauthorized
}

final class NetworkManager {

    static let shared = NetworkManager()

    /// Request API with decode response data
    /// - Parameters:
    ///   - request: An `APIRequest` object representing the HTTP request.
    ///   - responseType: The `Decodable` object type that the API response will be decoded into.
    ///   - isAuthorization: false if unAuthored
    /// - Returns: A decoded object from the API response of type `T`.
    /// - Throws:
    ///   - `NetworkError.badRequest`: If the request is invalid.
    ///   - `NetworkError.unauthorized`: If the token cannot be retrieved from `KeychainManager`.
    ///   - `NetworkError.badResponse`: If the HTTP response is invalid or the status code is not 200 - 299.
    ///   - `NetworkError.failedToDecodeResponse`: If the response data cannot be decoded.
    func requestAPIWithResponse<T: Decodable>(
        request: APIRequest,
        responseType: T.Type,
        isAuthorization: Bool = true
    ) async throws -> T {
        // Convert APIRequest to URLRequest
        guard var urlRequest = request.asURLRequest() else {
            throw NetworkError.badRequest
        }

        if isAuthorization {
            // get token from KeychainManager and added header
            guard let token = try? KeychainManager.shared.getToken() else {
                throw NetworkError.unauthorized
            }
            urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            // perform request with URLSession
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Verify HTTP response and checking status (200 - 299: OK)
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.badResponse
            }

            // Decode data
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.badResponse
        }
    }
    
    /// Request API without decode response data
    /// - Parameters:
    ///   - request: An `APIRequest` object representing the HTTP request.
    ///   - isAuthorization: false if unAuthored
    /// - Throws:
    ///   - `NetworkError.badRequest`: If the request is invalid.
    ///   - `NetworkError.unauthorized`: If the token cannot be retrieved from `KeychainManager`.
    ///   - `NetworkError.badResponse`: If the HTTP response is invalid or the status code is not 200 - 299.
    ///   - `NetworkError.failedToDecodeResponse`: If the response data cannot be decoded.
    func requestAPIWithoutResponse(request: APIRequest, isAuthorization: Bool = true) async throws {
        // Convert APIRequest to URLRequest
        guard var urlRequest = request.asURLRequest() else {
            throw NetworkError.badRequest
        }

        if isAuthorization {
            // get token from KeychainManager and added header
            guard let token = try? KeychainManager.shared.getToken() else {
                throw NetworkError.unauthorized
            }
            urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            // perform request with URLSession
            let (_, response) = try await URLSession.shared.data(for: urlRequest)

            // Verify HTTP response and checking status (200 - 299: OK)
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.badResponse
            }
        } catch {
            throw NetworkError.badResponse
        }
    }
}
