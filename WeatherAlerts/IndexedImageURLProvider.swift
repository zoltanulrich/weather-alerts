//
//  IndexedImageURLProvider.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

final class IndexedImageURLProvider: ImageURLProvider {

    private let index: Int
    private let scale: Int

    init(index: Int, scale: Int) {
        self.index = index
        self.scale = scale
    }

    func imageURL(width: Int) -> URL {
        return URL(string: "https://picsum.photos/id/\(index)/\(width * scale)")!
    }
}
