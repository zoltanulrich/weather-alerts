//
//  AlertRowView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI
import Model

private enum Constant {
    static let imageWidth = 144
}

struct AlertRowView: View {

    let alert: WeatherAlert
    let imageProvider: ImageURLProvider

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: imageProvider.imageURL(width: Constant.imageWidth)) { $0
                .resizable()
                .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 72)
            .clipped()
            .padding(EdgeInsets(top: -4, leading: -20, bottom: -4, trailing: 0))

            VStack(alignment: .leading) {
                Text(alert.event)
                    .font(.headline)
                Text("\(alert.startDate) through \(alert.endDate)")
                    .font(.subheadline)
                Text("Source: \(alert.senderName)")
                    .foregroundStyle(.gray)
            }
        }
    }
}

#if DEBUG
@testable import Model

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

    return List { AlertRowView(alert: alert, imageProvider: IndexedImageURLProvider(index: 10, scale: 2)).listRowInsets(.none) }
}

#endif
