//
//  AlertView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI
import Model

struct AlertView: View {

    let alert: WeatherAlert
    let index: Int

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: .init(string: "https:/picsum.photos/id/\(index + 10)/144")!) { $0
                .resizable()
                .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 72)
            .clipped()
            .padding(EdgeInsets(top: -4, leading: -16, bottom: -4, trailing: 0))

            VStack(alignment: .leading) {
                Text(alert.event)
                    .font(.headline)
                Text("\(alert.startDate) through \(alert.endDate)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Text("From \(alert.senderName)")
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let alert = WeatherAlert(id: "1",
                             event: "Severe Thunderstorm Warning",
                             effective: Date().addingTimeInterval(-1 * 24 * 86400),
                             expires: Date().addingTimeInterval(+2 * 24 * 86400),
                             severity: "Severe",
                             certanity: "High",
                             urgency: "Immediate",
                             senderName: "NWS Billings MT",
                             description: "At 227 AM MDT, Doppler radar was tracking a strong thunderstorm 26\nmiles east of Volborg, or 29 miles west of Ekalaka, moving east at 40\nmph.\n\nHAZARD...Wind gusts up to 50 mph and half inch hail.\n\nSOURCE...Radar indicated.\n\nIMPACT...Gusty winds could knock down tree limbs and blow around\nunsecured objects. Minor hail damage to vegetation is\npossible.\n\nLocations impacted include...\nEkalaka and Medicine Rocks State Park.",
                             instruction: "If outdoors, consider seeking shelter inside a building.\n\nTorrential rainfall is also occurring with this storm and may lead to\nlocalized flooding. Do not drive your vehicle through flooded\nroadways.",
                             affectedAreasURLs: [
                                URL(string: "https://www.apple.com")!,
                                URL(string: "https://www.apple.com")!
                             ])

    return List { AlertView(alert: alert, index: 0).listRowInsets(.none) }
}
