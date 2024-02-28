//
//  FourierDrawingView.swift
//
//
//  Created by Gustavo Munhoz Correa on 10/02/24.
//

import SwiftUI
import Accelerate
import Combine

struct FourierDrawingView: View {
    @ObservedObject var viewModel: FourierDrawingViewModel
    @EnvironmentObject var store: AppStore
    
    @State private var isGuide: Bool = true
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    ForEach(viewModel.epicycles, id: \.frequency) { epicycle in
                        Path { path in
                            path.addArc(center: epicycle.center, radius: epicycle.amplitude, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                            let endX = epicycle.center.x + epicycle.amplitude * cos(epicycle.phase + epicycle.frequency * viewModel.time)
                            let endY = epicycle.center.y + epicycle.amplitude * sin(epicycle.phase + epicycle.frequency * viewModel.time)
                            path.move(to: epicycle.center)
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(Color("EpicycleStroke")
                            .opacity(store.state.viewState.isStart ? 0.2 : 1),
                            lineWidth: 1 / (isGuide ? viewModel.scale : viewModel.scale * viewModel.scale)
                        )
                    }
                    
                    Path { path in
                        if let firstPoint = viewModel.pathPoints.first {
                            path.move(to: firstPoint)
                            for point in viewModel.pathPoints.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(Color("FourierLineStroke"), lineWidth: 4 / (isGuide ? viewModel.scale : pow(viewModel.scale, 2)))
                }
                .scaleEffect((isGuide ? viewModel.scale : viewModel.scale * viewModel.scale),
                             anchor: viewModel.scale <= 1 ? UnitPoint.center
                                    : UnitPoint(
                                        x: viewModel.lastVectorTip.x / geometry.size.width,
                                        y: viewModel.lastVectorTip.y / geometry.size.height))
                .offset(y: -geometry.size.height * 0.35)
            }
        }
        .onAppear {
            isGuide = store.state.viewState.isGuide
        }
    }
}
