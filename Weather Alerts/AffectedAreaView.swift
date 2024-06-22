//
//  AffectedAreaView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI
import Model

struct AffectedAreaView: View {

    let area: AffectedArea

    var body: some View {
        HStack {
            if let state = area.state {
                Text("\(area.name), \(state)")
            } else {
                Text(area.name)
            }
            Spacer()
            if area.isRadarStation {
                Image(systemName: "antenna.radiowaves.left.and.right")
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {

    AffectedAreaView(area: .init(id: "1", name: "San Francisco", state: "CA", isRadarStation: true))
}
