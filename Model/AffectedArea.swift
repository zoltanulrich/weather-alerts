//
//  AffectedArea.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

public struct AffectedArea: Identifiable {

    public var id: String
    public let name: String
    public let state: String?
    public let isRadarStation: Bool

    init(id: String, name: String, state: String?, isRadarStation: Bool) {
        self.id = id
        self.name = name
        self.state = state
        self.isRadarStation = isRadarStation
    }
}

extension AffectedArea: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case properties
        case name
        case state
        case radarStation
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)

        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        name = try properties.decode(String.self, forKey: .name)
        state = try properties.decodeIfPresent(String.self, forKey: .state)
        isRadarStation = try properties.decodeIfPresent(String.self, forKey: .radarStation) != nil
    }
}
