import SwiftUI
import Accelerate

/// This file defines the `AppState` struct, which represents the entire state of your application.
/// It should include all properties that determine the UI and functionality of your app.
/// Consider splitting this into substructures if your app state becomes too complex.

struct AppState {
    var viewState: ViewState = .start
    var guideState: GuideState = .introduction
    
    var parser: SVGParser?
    var fourierData: FourierDataState = FourierDataState()
    var currentDrawing: ModelSVG = .Curve
    var currentExpOfTwo: Int = 8
    
    var drawingTitles: [ModelSVG] = []
}

struct FourierDataState {
    var viewModel: FourierDrawingViewModel?
    var coefficients: [FourierCoefficient] = []
    var svgPoints: [DSPDoubleComplex] = []
}
