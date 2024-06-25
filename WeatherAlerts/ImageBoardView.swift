//
//  ImageBoardView.swift
//  WeatherAlerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

private enum Constant {
    static let headerImageHeight = 100.0
    static let horizontalImageWidth = 200.0
    static let thumbImageWidth = 120.0
    static let longPressMinimumDuration = 0.7
}

struct ImageBoardView<T: View>: View {

    let embeddedView: T
    let imageProvider: ImageURLProvider

    @GestureState private var dragState = DragState.inactive
    @State private var imageOffset = CGSize.zero
    @State private var wasImageMoved = false
    @State private var initialPosition: CGPoint = .zero
    @Environment(\.verticalSizeClass) var verticalSizeClass

    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
    }

    var body: some View {
        let initialLongPressDrag = LongPressGesture(minimumDuration: Constant.longPressMinimumDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in
                if case .second(true, let drag) = value, let drag, initialPosition == .zero {
                    Task {
                        initialPosition = drag.location
                        wasImageMoved = true
                    }
                }
            }

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
            if !wasImageMoved {
                if verticalSizeClass == .regular {
                    VStack {
                        Color(.clear)
                            .frame(height: Constant.headerImageHeight)
                            .overlay {
                                AsyncImage(url: imageProvider.imageURL(width: Int(geo.size.width))) { $0
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: Constant.headerImageHeight + geo.safeAreaInsets.top)
                                    .clipped()
                                    .ignoresSafeArea()
                                    .gesture(initialLongPressDrag)
                                } placeholder: {
                                    ProgressView()
                                }
                            }

                        embeddedView
                    }
                } else {
                    HStack {
                        AsyncImage(url: imageProvider.imageURL(width: Int(Constant.horizontalImageWidth))) { $0
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Constant.horizontalImageWidth)
                            .clipped()
                            .gesture(initialLongPressDrag)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        ScrollView {
                            embeddedView
                        }
                    }.ignoresSafeArea(edges: [.leading])
                }
            } else {
                ScrollView {
                    ZStack {
                        embeddedView

                        AsyncImage(url: imageProvider.imageURL(width: Int(Constant.thumbImageWidth))) { $0
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(Color.red, width: dragState.isDragging ? 1 : 0)
                            .frame(width: Constant.thumbImageWidth, height: Constant.thumbImageWidth)
                            .position(initialPosition)
                            .offset(
                                x: imageOffset.width + dragState.translation.width,
                                y: imageOffset.height + dragState.translation.height
                            )
                            .gesture(longPressDrag)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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

#if DEBUG
@testable import Model

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
    return NavigationStack {
        ImageBoardView(embeddedView: alertDetailsView, imageProvider: IndexedImageURLProvider(index: 10, scale: 2))
            .navigationTitle("Alert Details")
    }
}

#endif
