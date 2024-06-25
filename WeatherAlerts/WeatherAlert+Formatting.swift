//
//  WeatherAlert+Formatting.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation
import Model

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a ZZZZ"
    return formatter
}()

extension WeatherAlert {

    var startDate: String {
        formatter.string(from: effective)
    }

    var endDate: String {
        formatter.string(from: expires)
    }
}
