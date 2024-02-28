//
//  SVGMiddleware.swift
//
//
//  Created by Gustavo Munhoz Correa on 19/02/24.
//
import Combine
import Foundation

let svgLogic: Middleware<AppState, AppAction> = { state, action in
    switch action {
        // MARK: - Navigation
        case .navigateToDrawing(let svg):
            return Just(.loadSVG(named: svg, resetExpoent: true))
                .eraseToAnyPublisher()
            
        case .navigateToFrequency:
            return Just(.setExpoentOfTwo(8)).eraseToAnyPublisher()
            
        // MARK: - SVG handling
            
        case .setupParser:
            return Just(.loadSVG(named: .logo, resetExpoent: false))
                .eraseToAnyPublisher()
            
        case .loadSVG(let svg, let resetExpoent):
            guard let path = Bundle.main.path(forResource: svg.rawValue, ofType: "svg"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path))
                    
            else { return Just(.svgLoadingFailed).eraseToAnyPublisher() }
            
            guard let paths = state.parser?.parse(data: data, withExp: state.currentExpOfTwo)
            
            else { return Just(.svgParsingFailed).eraseToAnyPublisher() }
            
            let points = paths.flatMap { $0.complexPoints }
            
            return Just(.setSVGPoints(points)).eraseToAnyPublisher()
            
        case .setSVGPoints(let points):
            var coefficients = FourierTransformHelper.applyFFT(to: points)
            
            let n = coefficients.count
            
            for i in 0..<n {
                coefficients[i].value.real /= Double(n)
                coefficients[i].value.imag /= Double(n)
            }
            
            coefficients.removeFirst()
            
            return Just(.setFourierCoefficients(coefficients))
                .eraseToAnyPublisher()
            
        case .setFourierCoefficients(let coefficients):
            return Just(.setDrawingViewModel(coefficients)).eraseToAnyPublisher()
            
        // MARK: - Image controls
            
        case .increaseCircleNumber:
            return Just(.loadSVG(named: state.currentDrawing, resetExpoent: false))
                .eraseToAnyPublisher()
            
        case .decreaseCircleNumber:
            return Just(.loadSVG(named: state.currentDrawing, resetExpoent: false))
                .eraseToAnyPublisher()
            
        default:
            break
        
    }
    return Empty().eraseToAnyPublisher()
}
