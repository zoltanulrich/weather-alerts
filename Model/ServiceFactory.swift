//
//  ServiceFactory.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

public final class ServiceFactory {

    public static var defaultWeatherService: WeatherService {
        WeatherServiceImpl()
    }
}
