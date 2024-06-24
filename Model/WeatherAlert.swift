//
//  WeatherAlert.swift
//  Model
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import Foundation

public struct WeatherAlert {

    public let id: String
    public let event: String

    public let effective: Date
    public let expires: Date
    
    public let severity: String
    public let certanity: String?
    public let urgency: String
    
    public let senderName: String
    public let description: String
    public let instruction: String?
    
    public let affectedAreasURLs: [URL]

    init(id: String, event: String, effective: Date, expires: Date, severity: String, certanity: String?, urgency: String, senderName: String, description: String, instruction: String?, affectedAreasURLs: [URL]) {
        self.id = id
        self.event = event
        self.effective = effective
        self.expires = expires
        self.severity = severity
        self.certanity = certanity
        self.urgency = urgency
        self.senderName = senderName
        self.description = description
        self.instruction = instruction
        self.affectedAreasURLs = affectedAreasURLs
    }
}
