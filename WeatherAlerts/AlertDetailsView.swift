//
//  AlertDetailsView.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI
import Model

struct AlertDetailsView: View {

    let model: AlertDetailsModel

    @State private var isDescriptionExpanded = false
    @State private var areInstructionsExpanded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text(model.alert.event)
                    .font(.title)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Source")
                        .font(.headline)
                    Text(model.alert.senderName)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Text(attributes)
                    .bold()

                Text("Effective \(model.alert.startDate) through \(model.alert.endDate)")
                    .font(.subheadline)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Description")
                        .font(.headline)
                    Text(model.alert.description)
                        .lineLimit(isDescriptionExpanded ? nil : 2)
                        .onTapGesture { isDescriptionExpanded.toggle() }
                }

                if let instruction = model.alert.instruction {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Instructions")
                            .font(.headline)
                        Text(instruction)
                            .lineLimit(areInstructionsExpanded ? nil : 2)
                            .onTapGesture { areInstructionsExpanded.toggle() }
                    }
                }

                switch model.affectedAreaState {
                case .isLoading:
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Affected areas")
                    }

                case .available(let areas) where !areas.isEmpty:
                    VStack(alignment: .leading) {
                        Text("Affected areas")
                            .font(.headline)
                        ForEach(areas, id: \.name) { area in
                            AffectedAreaView(area: area)
                        }
                    }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))

                default:
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .animation(.default, value: isDescriptionExpanded)
            .animation(.default, value: areInstructionsExpanded)
        }
        .task {
            await model.fetchAffectedAreas()
        }
    }

    var attributes: String {
        var attributes: [String] = []
        attributes.append(model.alert.severity)
        if let certainty = model.alert.certanity {
            attributes.append(certainty)
        }
        attributes.append(model.alert.urgency)
        return attributes.joined(separator: " | ")
    }
}

#if DEBUG
@testable import Model

#Preview {
    let alert = WeatherAlert(id: "1",
                             event: "Flash Flood Warning",
                             effective: Date().addingTimeInterval(-1 * 24 * 86400),
                             expires: Date().addingTimeInterval(+2 * 24 * 86400),
                             severity: "Severe",
                             certanity: nil,
                             urgency: "Immediate",
                             senderName: "National Weather Service",
                             description: "A flash flood warning is in effect for the area. A flash flood warning is in effect for the area. A flash flood warning is in effect for the area. A flash flood warning is in effect for the area. A flash flood warning is in effect for the area. A flash flood warning is in effect for the area.",
                             instruction: "Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground. Move to higher ground.",
                             affectedAreasURLs: [])
    let model = AlertDetailsModel(alert: alert, affectedAreaState: .available([
        AffectedArea(id: "1", name: "Area 51", state: "IL", isRadarStation: true),
        AffectedArea(id: "2", name: "Area 2", state: "NY", isRadarStation: false),
        AffectedArea(id: "3", name: "Area 3", state: "CA", isRadarStation: true)
    ]))
    return AlertDetailsView(model: model)
}

#endif
