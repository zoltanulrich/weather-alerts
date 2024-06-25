//
//  ImageURLProvider.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

protocol ImageURLProvider {

    func imageURL(width: Int) -> URL
}
