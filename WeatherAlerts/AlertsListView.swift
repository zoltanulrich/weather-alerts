//
//  AlertsListView.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

struct AlertsListView: View {

    @Environment(AlertsListModel.self) var model
    @Environment(\.displayScale) private var displayScale
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        let imageProvider: (_ index: Int) -> ImageURLProvider = {
            IndexedImageURLProvider(index: $0, scale: Int(displayScale))
        }

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
                            ImageBoardView(embeddedView: AlertDetailsView(model: .init(alert: alert)),
                                           imageProvider: imageProvider(index + 10))
                        } label: {
                            AlertRowView(alert: alert, imageProvider: imageProvider(index + 10))
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await refresh()
                }
            }
        }
    }

    private func refresh() async {
        await model.fetchBulletin()
    }
}

#if DEBUG
@testable import Model

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
        WeatherAlert(id: "2",
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

#endif
