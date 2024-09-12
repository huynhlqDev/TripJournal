import Foundation

/// An object that can be used to create a new trip.
struct TripCreate: Codable {
    let name: String
    let startDate: Date
    let endDate: Date

    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

/// An object that can be used to update an existing trip.
struct TripUpdate: Codable {
    let name: String
    let startDate: Date
    let endDate: Date

    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

/// An object that can be used to create a media.
struct MediaCreate {
    let eventId: Event.ID
    let base64Data: Data
}

/// An object that can be used to create a new event.
struct EventCreate {
    let tripId: Trip.ID
    let name: String
    let note: String?
    let date: Date
    let location: Location?
    let transitionFromPrevious: String?
}

/// An object that can be used to update an existing event.
struct EventUpdate {
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var transitionFromPrevious: String?
}
