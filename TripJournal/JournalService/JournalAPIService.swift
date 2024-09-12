//
//  JournalAPIService.swift
//  TripJournal
//
//  Created by huynh on 9/9/24.
//

import Combine
import Foundation


class JournalAPIService: JournalService {

    @Published private var token: Token? {
        didSet {
            if let token = token {
                try? KeychainManager.shared.saveToken(token)
            } else {
                try? KeychainManager.shared.deleteToken()
            }
        }
    }
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    init() {}

    func register(username: String, password: String) async throws -> Token {
        let loginRequest = APIRequest.register(username: username, password: password)

        guard let request = loginRequest.asURLRequest() else {
            throw NetworkError.badRequest
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                self.token = token
                return token
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.badResponse
        }

    }

    func logIn(username: String, password: String) async throws -> Token {
        let loginRequest = APIRequest.login(username: username, password: password)

        guard let request = loginRequest.asURLRequest() else {
            throw NetworkError.badRequest
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                self.token = token
                return token
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.badResponse
        }

    }

    func logOut() {
        self.token = nil
    }

    func createTrip(with request: TripCreate) async throws -> Trip {
        let loginRequest = APIRequest.createTrip(trip: request)

        guard var request = loginRequest.asURLRequest() else {
            throw NetworkError.badRequest
        }
        guard let token = try KeychainManager.shared.getToken() else {
            throw NetworkError.badRequest
        }
        request.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let trip = try decoder.decode(Trip.self, from: data)
                return trip
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.badResponse
        }
    }

    func getTrips() async throws -> [Trip] {
        let loginRequest = APIRequest.readTrips

        guard var request = loginRequest.asURLRequest() else {
            throw NetworkError.badRequest
        }
        guard let token = try KeychainManager.shared.getToken() else {
            throw NetworkError.badRequest
        }
        request.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let trips = try decoder.decode([Trip].self, from: data)
                return trips
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.badResponse
        }
    }

    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        fatalError()
//        Trip(id: 1, name: "", startDate: Date.now, endDate: .now, events: [])
    }

    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        fatalError()
//        Trip(id: 1, name: "", startDate: Date.now, endDate: .now, events: [])
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        // TODO:
    }

    func createEvent(with request: EventCreate) async throws -> Event {
//        Event(id: 1, name: "", date: .now, medias: [])
        fatalError()
    }

    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
//        Event(id: 1, name: "", date: .now, medias: [])
        fatalError()
    }

    func deleteEvent(withId eventId: Event.ID) async throws {

    }

    func createMedia(with request: MediaCreate) async throws -> Media {
        fatalError()
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {

    }

    enum NetworkError: Error {
        case badRequest
        case badResponse
        case failedToDecodeResponse
    }
}
