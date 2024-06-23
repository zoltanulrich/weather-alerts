//
//  ImageBoardView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

enum Constant {
    static let imageWidth = 120.0
    static let imageHeight = 100.0
    static let longPressMinimumDuration = 0.7
}

struct ImageBoardView<T: View>: View {

    let embeddedView: T
    let imageURL: URL

    @GestureState private var dragState = DragState.inactive
    @State private var imageOffset = CGSize.zero

    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
    }

    var body: some View {
        let longPressDrag = LongPressGesture(minimumDuration: Constant.longPressMinimumDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in
                switch value {
                case .first(true):
                    state = .pressing
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                default:
                    state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else { return }
                self.imageOffset.width += drag.translation.width
                self.imageOffset.height += drag.translation.height
            }
        
        GeometryReader { geo in
//            if !dragState.isActive && imageOffset == .zero {
//                VStack {
//                    AsyncImage(url: imageURL) { $0
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: geo.size.width, height: Constant.imageHeight)
//                        .clipped()
//                        .gesture(longPressDrag)
//                    } placeholder: {
//                        ProgressView()
//                    }
//
//                    embeddedView
//                }
//            } else {
                ZStack {
                    embeddedView

                    AsyncImage(url: imageURL) { $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(Color.green, width: dragState.isDragging ? 1 : 0)
                        .frame(width: Constant.imageWidth, height: Constant.imageWidth)
                        .offset(
                            x: imageOffset.width + dragState.translation.width,
                            y: imageOffset.height + dragState.translation.height
                        )
                        .gesture(longPressDrag)
                    } placeholder: {
                        ProgressView()
                    }
                }
//            }
        }
    }
}

extension ImageBoardView.DragState {

    var translation: CGSize {
        if case .dragging(let translation) = self {
            translation
        } else {
            .zero
        }
    }

    var isActive: Bool {
        if case .inactive = self { false } else { true }
    }

    var isDragging: Bool {
        if case .dragging = self { true } else { false }
    }
}

import Model

#Preview {
    let alert = WeatherAlert(id: "1",
                             event: "Flash Flood Warning",
                             effective: Date().addingTimeInterval(-1 * 24 * 86400),
                             expires: Date().addingTimeInterval(+2 * 24 * 86400),
                             severity: "Severe",
                             certanity: "Observed",
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
    let alertDetailsView = AlertDetailsView(model: model)
    return ImageBoardView(embeddedView: alertDetailsView, imageURL: URL(string: "https:/picsum.photos/id/10/300")!)
}
