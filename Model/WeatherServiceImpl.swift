//
//  WeatherServiceImpl.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

final class WeatherServiceImpl: WeatherService {

    private let urlSession = URLSession.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetchActiveAlerts() async throws -> WeatherAlertsBulletin {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.weather.gov"
        urlComponents.path = "/alerts/active"
        urlComponents.queryItems = [
            URLQueryItem(name: "status", value: "actual"),
            URLQueryItem(name: "message_type", value: "alert")
        ]
        let (data, response) = try await urlSession.data(from: urlComponents.url!)
        guard let response = response as? HTTPURLResponse else {
            throw ServiceError.general("Invalid response")
        }

        try Task.checkCancellation()

        switch response.statusCode {
        case 200..<300:
            let alertsResponse = try decoder.decode(AlertsResponse.self, from: data)
            let weatherAlerts = alertsResponse.features.map { feature in
                WeatherAlert(
                    id: feature.id,
                    event: feature.properties.event,
                    effective: feature.properties.effective,
                    expires: feature.properties.expires,
                    severity: feature.properties.severity,
                    certanity: feature.properties.certanity,
                    urgency: feature.properties.urgency,
                    senderName: feature.properties.senderName,
                    description: feature.properties.description,
                    instruction: feature.properties.instruction,
                    affectedAreasURLs: feature.properties.affectedZones ?? []
                )
            }
            return .init(date: alertsResponse.updated, alerts: weatherAlerts)
        
        default:
            throw ServiceError.general(response.description)
        }
    }

    func fetchAffectedArea(atURL url: URL) async throws -> AffectedArea {
        let (data, response) = try await urlSession.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw ServiceError.general("Invalid response")
        }

        try Task.checkCancellation()

        switch response.statusCode {
        case 200..<300:
            return try decoder.decode(AffectedArea.self, from: data)
        default:
            throw ServiceError.general(response.description)
        }
    }
}

private struct AlertsResponse: Decodable {

    struct Feature: Decodable {
        let id: String
        let properties: Properties
    }

    struct Properties: Decodable {
        let event: String
        let effective: Date
        let expires: Date
        let severity: String
        let certanity: String?
        let urgency: String
        let senderName: String
        let description: String
        let instruction: String?
        let affectedZones: [URL]?
    }

    let updated: Date
    let features: [Feature]
}
