//
//  ImageBoardView.swift
//  Weather Alerts
//
//  Created by Zoltan Ulrich on 22.06.2024.
//

import SwiftUI

private enum Constant {
    static let movedImageWidth = 300.0
    static let defaultImageHeight = 240.0
}

struct ImageBoardView<T: View>: View {

    let embeddedView: T
    let index: Int

    @State private var wasImageDragged = false
    @State private var isDraggingImage: Bool = false
    @State private var imageLocation: CGPoint = .zero

    @Environment(\.displayScale) private var displayScale
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        GeometryReader { geo in
            if !wasImageDragged {
                if verticalSizeClass == .regular {
                    VStack {
                        Color(.clear)
                            .frame(height: Constant.defaultImageHeight)
                            .overlay {
                                AsyncImage(url: urlForImage(ofWidth: geo.size.width)) { $0
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: Constant.defaultImageHeight + geo.safeAreaInsets.top)
                                    .clipped()
                                    .ignoresSafeArea()
                                    .onLongPressGesture {
                                        wasImageDragged = true
                                    }
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .onAppear {
                                imageLocation = .init(x: geo.size.width / 2, y: geo.size.height / 2)
                            }

                        embeddedView
                    }
                } else {
                    HStack {
                        AsyncImage(url: urlForImage(ofWidth: geo.size.width)) { $0
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 2)
                            .clipped()
                            .onLongPressGesture {
                                wasImageDragged = true
                            }
                        } placeholder: {
                            ProgressView()
                        }
                        .onAppear {
                            imageLocation = .init(x: geo.size.width / 2, y: geo.size.height / 2)
                        }

                        embeddedView
                    }
                }
            } else {
                ZStack {
                    embeddedView

                    AsyncImage(url: urlForImage(ofWidth: geo.size.width)) { $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constant.movedImageWidth)
                        .position(imageLocation)
                        .clipped()
                        .gesture(dragGesture)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
    }

    func urlForImage(ofWidth width: CGFloat) -> URL! {
        URL(string: "https:/picsum.photos/id/\(index + 10)/\(Int(width * displayScale))")
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.imageLocation = value.location
                self.isDraggingImage = true
            }

            .onEnded { _ in
                self.isDraggingImage = false
            }
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
    let alertDetailsView = AlertDetailsView(model: model, index: 0)
    return ImageBoardView(embeddedView: alertDetailsView, index: 0)
}
