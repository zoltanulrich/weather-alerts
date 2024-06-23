//
//  AlertsListView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

struct AlertsListView: View {

    @Environment(AlertsListModel.self) var model
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        NavigationStack {
            List {
                switch model.state {
                case .isLoading:
                    HStack {
                        Spacer()
                        ProgressView {
                            Text("Loading alerts...")
                        }
                        Spacer()
                    }.listRowInsets(.none)

                case .available(let bulletin):
                    ForEach(Array(bulletin.alerts.enumerated()), id: \.1.id) { index, alert in
                        NavigationLink {
                            ImageBoardView(embeddedView: AlertDetailsView(model: .init(alert: alert)), imageURL: urlForImage(ofWidth: Constant.imageWidth, index: index))
                        } label: {
                            AlertView(alert: alert, index: index)
                        }
                    }.listRowInsets(.none)

                case .failedLoading:
                    VStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle")
                            .imageScale(.large)
                            .foregroundStyle(.red)
                        Text("Failed to load alert. Pull to try again.")
                    }.listRowInsets(.none)
                }
            }.refreshable {
                await model.fetchBulletin()
            }
            .navigationTitle("Active Alerts")
        }
        .task {
            await model.fetchBulletin()
        }
    }

    func urlForImage(ofWidth width: CGFloat, index: Int) -> URL! {
        URL(string: "https:/picsum.photos/id/\(index + 10)/\(Int(width * displayScale))")
    }
}


import Model

#Preview {
    let bulletin = WeatherAlertsBulletin(date: Date(), alerts: [
        WeatherAlert(id: "1",
                     event: "Flash Flood Warning",
                     effective: Date().addingTimeInterval(-1 * 24 * 86400),
                     expires: Date().addingTimeInterval(2 * 24 * 86400),
                     severity: "Severe",
                     certanity: "High",
                     urgency: "Immediate",
                     senderName: "NWS Billings MT",
                     description: "A flash flood warning is in effect for the area",
                     instruction: "Move to higher ground immediately",
                     affectedAreasURLs: [URL(string: "https://example.com")!]),
        WeatherAlert(id: "1",
                     event: "Flash Flood Warning",
                     effective: Date().addingTimeInterval(-1 * 24 * 86400),
                     expires: Date().addingTimeInterval(2 * 24 * 86400),
                     severity: "Severe",
                     certanity: "High",
                     urgency: "Immediate",
                     senderName: "NWS Billings MT",
                     description: "A flash flood warning is in effect for the area",
                     instruction: "Move to higher ground immediately",
                     affectedAreasURLs: [URL(string: "https://example.com")!])
    ])

    let model = AlertsListModel(state: .available(bulletin))

    return AlertsListView()
        .environment(model)
}
