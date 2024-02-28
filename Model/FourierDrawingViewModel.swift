//
//  FourierDrawingViewModel.swift
//  
//
//  Created by Gustavo Munhoz Correa on 19/02/24.
//

import SwiftUI
import Combine


class FourierDrawingViewModel: ObservableObject {
    @Published var lastVectorTip: CGPoint = .zero
    @Published var scale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var epicycles: [Epicycle] = []
    @Published var pathPoints: [CGPoint] = []
    
    private(set) var maxPathPoints: Int
    private(set) var time: CGFloat = 0.0
    private(set) var coefficients: [FourierCoefficient] = []
    private var timer: AnyCancellable?
    private var lastCenter = CGPoint.zero
    
    init(coefficients: [FourierCoefficient], maxPoints: Int = 340) {
        self.coefficients = coefficients
        self.maxPathPoints = maxPoints
        startDrawing()
    }
    
    func setMaxPathPoints(to value: Int) {
        self.maxPathPoints = value
    }
    
    func startDrawing() {
        timer = Timer.publish(every: 1/(60 * scale), on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.time += 1/(60 * scale * scale)
            
            if self.time >= 2 * .pi {
                self.time = 0
                self.lastCenter = CGPoint.zero
            } else {
                self.updateEpicyclesAndPath()
            }
        }
    }
    
    private func updateEpicyclesAndPath() {
        var newEpicycles: [Epicycle] = []
        var currentCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)

        for coefficient in coefficients {
            let endX = currentCenter.x + coefficient.amplitude * cos(coefficient.phase + coefficient.frequency * time)
            let endY = currentCenter.y + coefficient.amplitude * sin(coefficient.phase + coefficient.frequency * time)
            
            newEpicycles.append(Epicycle(amplitude: coefficient.amplitude, frequency: coefficient.frequency, phase: coefficient.phase, center: currentCenter))
            
            currentCenter = CGPoint(x: endX, y: endY)
        }
        
        DispatchQueue.main.async {
            self.epicycles = newEpicycles
            self.pathPoints.append(currentCenter)
            
            if self.pathPoints.count > self.maxPathPoints {
                self.pathPoints.removeFirst(self.pathPoints.count - self.maxPathPoints)
            }
            
            self.lastVectorTip = currentCenter
        }
    }
}
