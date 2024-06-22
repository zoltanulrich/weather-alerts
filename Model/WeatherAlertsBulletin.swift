//
//  WeatherAlertsBulletin.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

public struct WeatherAlertsBulletin {

    public let date: Date
    public let alerts: [WeatherAlert]

    public init(date: Date, alerts: [WeatherAlert]) {
        self.date = date
        self.alerts = alerts
    }
}
