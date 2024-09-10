//
//  JournalAPIService.swift
//  TripJournal
//
//  Created by huynh on 9/9/24.
//

import Combine
import Foundation

class JournalAPIService: JournalService {

    var isAuthenticated: AnyPublisher<Bool, Never>

    init() {
        fatalError("Unimplemented logIn")
    }
    
    func register(username: String, password: String) async throws -> Token {
        Token(accessToken: "", tokenType: "")
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        Token(accessToken: "", tokenType: "")
    }
    
    func logOut() {

    }
    
    func createTrip(with request: Trip) async throws -> Trip {
        Trip(id: 1, name: "", startDate: Date.now, endDate: .now, events: [])
    }
    
    func getTrips() async throws -> [Trip] {
        []
    }
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        Trip(id: 1, name: "", startDate: Date.now, endDate: .now, events: [])
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: Trip) async throws -> Trip {
        Trip(id: 1, name: "", startDate: Date.now, endDate: .now, events: [])
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        // TODO:
    }
    
    func createEvent(with request: Event) async throws -> Event {
        Event(id: 1, name: "", date: .now, medias: [])
    }
    
    func updateEvent(withId eventId: Event.ID, and request: Event) async throws -> Event {
            Event(id: 1, name: "", date: .now, medias: [])
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {

    }
    
    func createMedia(with request: Media) async throws -> Media {
        Media(id: 1)
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {

    }
    

}
