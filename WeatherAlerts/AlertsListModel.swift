//
//  Model.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation
import Model

@Observable
final class AlertsListModel {

    enum State {
        case isLoading
        case available(_ bulletin: WeatherAlertsBulletin)
        case failedLoading
    }

    private(set) var state: State = .isLoading

    private let service = ServiceFactory.defaultWeatherService

    init(state: State = .isLoading) {
        self.state = state
    }

    @MainActor
    func fetchBulletin() async {
        do {
            let bulletin = try await service.fetchActiveAlerts()
            state = .available(bulletin)
        } catch {
            print("Error: ", error)
            state = .failedLoading
        }
    }
}
