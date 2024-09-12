//
//  Request.swift
//  TripJournal
//
//  Created by huynh on 10/9/24.
//

import Foundation

// Define an enum for your API endpoints
enum APIRequest {
    // Authentication request
    case register(username: String, password: String)
    case login(username: String, password: String)
    // Trip request
    case createTrip(trip: TripCreate)
    case readTrips
    case readTrip(id: Int)
    case updateTrip(id: Int, trip: TripUpdate)
    case deleteTrip(id: Int)
    // Event request
    case createEvent(event: EventCreate)
    case readEvent(id: Int)
    case updateEvent(id: Int, event: Event)
    case deleteEvent(id: Int)
    // Media request
    case uploadMedia(media: Media)
    case deleteMedia(id: Int)

    // Base URL of the API
    var baseURL: String {
        return "http://localhost:8000"
    }

    // Set the specific path for each API case
    var path: String {
        switch self {
        case .register: 
            return "/register"
        case .login:
            return "/token"
        case .createTrip(_):
            return "/trips"
        case .readTrips:
            return "/trips"
        case .readTrip(id: let id):
            return "/trips/\(id)"
        case .updateTrip(id: let id, _):
            return "/trips/\(id)"
        case .deleteTrip(id: let id):
            return "/trips/\(id)"
        case .createEvent(_):
            return "/events"
        case .readEvent(id: let id):
            return "/events/\(id)"
        case .updateEvent(id: let id, _):
            return "events/\(id)"
        case .deleteEvent(id: let id):
            return "/events/\(id)"
        case .uploadMedia(_):
            return "/media"
        case .deleteMedia(id: let id):
            return "/media/\(id)"
        }
    }

    // Set the HTTP method for each API case
    var method: String {
        switch self {
        case .register: "POST"
        case .login: "POST"
        case .createTrip(_): "POST"
        case .readTrips: "GET"
        case .readTrip(_): "GET"
        case .updateTrip(_, _): "PUT"
        case .deleteTrip(_): "DELETE"
        case .createEvent(_): "POST"
        case .readEvent(id: _): "GET"
        case .updateEvent(_, _): "PUT"
        case .deleteEvent(_): "DELETE"
        case .uploadMedia(_): "POST"
        case .deleteMedia(_): "DELETE"
        }
    }

    // Set the HTTP headers (optional)
    var headers: [String: String]? {
        switch self {
        case .login(_, _):
            return [
                "accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .deleteTrip(_), .deleteEvent(_), .deleteMedia(_):
            return ["accept": "*/*"]
        default:
            return [
                "accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }

    // Set the body parameters for the request (if needed)
    var parametersData: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        switch self {
        case .login(let username, let password):
            let bodyString = "grant_type=&username=\(username)&password=\(password)"
            return bodyString.data(using: .utf8)
        case .register(let username, let password):
            let body = [
                "username": username,
                "password": password,
            ]
            return try? JSONSerialization.data(withJSONObject: body, options: [])
        case .createTrip(trip: let trip):
            return try? encoder.encode(trip)
        case .updateTrip(_, trip: let trip):
            return try? encoder.encode(trip)
        case .createEvent(event: let event):
            return try? encoder.encode(event)
        case .updateEvent(_, event: let event):
            return try? encoder.encode(event)
        case .uploadMedia(media: let media):
            return try? encoder.encode(media)
        default:
            return nil
        }
    }

    // Build the URLRequest for each API case
    func asURLRequest() -> URLRequest? {
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        // Add headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // Add body parameters
        if let parametersData = parametersData {
            request.httpBody = parametersData
        }

        return request
    }
}
