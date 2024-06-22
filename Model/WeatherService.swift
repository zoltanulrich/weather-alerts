//
//  WeatherService.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

enum ServiceError: Error {
    case general(_ message: String)
}

public protocol WeatherService {

    func fetchActiveAlerts() async throws -> WeatherAlertsBulletin
    func fetchAffectedArea(atURL: URL) async throws -> AffectedArea
}
