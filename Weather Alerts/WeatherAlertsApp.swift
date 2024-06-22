//
//  WeatherAlertsApp.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

@main
struct WeatherAlertsApp: App {
    var body: some Scene {
        WindowGroup {
            AlertsListView()
                .environment(AlertsListModel())
        }
    }
}
