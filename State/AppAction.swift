import SwiftUI

/// This file defines the `AppAction` enum, which represents all possible actions within your application.
/// Each case in this enum corresponds to a different action that can be taken, which will then be handled by the reducer.

import Accelerate

enum AppAction {
    // MARK: - Navigation
    case navigateToIntroduction
    case navigateToSmoothie
    case navigateToFrequency
    case navigateToEpicycle
    case navigateToRealWorld
    case navigateToTryYourself
    case navigateToGallery
    case navigateToDrawing(ModelSVG)
    
    
    // MARK: - Image related actions
    case setupParser
    case loadSVG(named: ModelSVG, resetExpoent: Bool)
    case setFourierCoefficients([FourierCoefficient])
    case setSVGPoints([DSPDoubleComplex])
    case svgLoadingFailed
    case svgParsingFailed
    case setDrawingViewModel([FourierCoefficient])
    case setExpoentOfTwo(Int)
    
    // MARK: - Image controls
    case increaseCircleNumber
    case decreaseCircleNumber
    case setZoom(CGFloat)
}

