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

    func logOut() {
        self.token = nil
    }

    func register(username: String, password: String) async throws -> Token {
        let token: Token = try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.register(username: username, password: password),
            responseType: Token.self,
            isAuthorization: false
        )
        self.token = token
        return token
    }

    func logIn(username: String, password: String) async throws -> Token {
        let token: Token = try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.login(username: username, password: password),
            responseType: Token.self,
            isAuthorization: false
        )
        self.token = token
        return token
    }

    func createTrip(with request: TripCreate) async throws -> Trip {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.createTrip(trip: request),
            responseType: Trip.self
        )
    }

    func getTrips() async throws -> [Trip] {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.readTrips,
            responseType: [Trip].self
        )
    }

    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.readTrip(id: tripId),
            responseType: Trip.self
        )
    }

    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.updateTrip(id: tripId, trip: request),
            responseType: Trip.self
        )
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        try await NetworkManager.shared.requestAPIWithoutResponse(
            request: APIRequest.deleteTrip(id: tripId)
        )
    }

    func createEvent(with request: EventCreate) async throws -> Event {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.createEvent(event: request),
            responseType: Event.self
        )
    }

    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.updateEvent(id: eventId, event: request),
            responseType: Event.self
        )
    }

    func deleteEvent(withId eventId: Event.ID) async throws {
        try await NetworkManager.shared.requestAPIWithoutResponse(
            request: APIRequest.deleteEvent(id: eventId)
        )
    }

    func createMedia(with request: MediaCreate) async throws -> Media {
        try await NetworkManager.shared.requestAPIWithResponse(
            request: APIRequest.uploadMedia(media: request),
            responseType: Media.self
        )
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {
        try await NetworkManager.shared.requestAPIWithoutResponse(
            request: APIRequest.deleteEvent(id: mediaId)
        )
    }
    
}
