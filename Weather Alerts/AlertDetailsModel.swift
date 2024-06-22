//
//  AlertDetailsModel.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation
import Model

@Observable
final class AlertDetailsModel {

    let alert: WeatherAlert

    enum AffectedAreasState {
        case isLoading
        case available(_ affectedAreas: [AffectedArea])
        case failedLoading
    }

    private(set) var affectedAreaState: AffectedAreasState = .isLoading

    private let service = ServiceFactory.defaultWeatherService

    init(alert: WeatherAlert, affectedAreaState: AffectedAreasState = .isLoading) {
        self.alert = alert
        self.affectedAreaState = affectedAreaState
    }

    func fetchAffectedAreas() async {
        await MainActor.run { affectedAreaState = .isLoading }

        do {
            let affectedAreas = try await withThrowingTaskGroup(of: AffectedArea.self, returning: [AffectedArea].self) { [weak self] group in
                guard let self else { return [] }
                for url in alert.affectedAreasURLs {
                    group.addTask {
                        try Task.checkCancellation()
                        return try await self.service.fetchAffectedArea(atURL: url)
                    }
                }
                return try await group.reduce(into: []) { $0.append($1) }
            }
            await MainActor.run { affectedAreaState = .available(affectedAreas) }
        } catch {
            print("Error: ", error)
            await MainActor.run { affectedAreaState = .failedLoading }
        }
    }
}
