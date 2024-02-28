import SwiftUI

/// Use this file to manage state changes in response to actions within your application.
/// Reducers are pure functions that take the current state and an action, and return a new state.
/// They should not produce side effects, meaning they should only compute the new state based on the given state and action.
///
/// Define the appReducer below, which is a specific implementation of a reducer for your app's state and actions.
/// It takes the current app state and an action, and returns the new app state after applying the action's effects.

typealias Reducer<State, Action> = (State, Action) -> State

let appReducer: Reducer<AppState, AppAction> = { state, action in
    var newState = state
    
    switch action {
        // MARK: - Image related actions
        case .setupParser:
            guard newState.parser == nil else { break }
            
            newState.parser = SVGParser()
            
        case .loadSVG(let svg, let resetExpoent):
            if resetExpoent {
                newState.currentExpOfTwo = 2
            }
            
            newState.currentDrawing = svg
        
        case .setFourierCoefficients(let coefficients):
            newState.fourierData.coefficients = coefficients

        case .setSVGPoints(let points):
            newState.fourierData.svgPoints = points
            
        case .setDrawingViewModel(let coefficients):
            newState.fourierData.viewModel = FourierDrawingViewModel(coefficients: coefficients)
            
            if newState.currentDrawing == .logo {
                newState.fourierData.viewModel?.setMaxPathPoints(to: 100)
            }
            
        case .setExpoentOfTwo(let exp):
            guard exp >= 2, exp < 11 else { break }
            
            newState.currentExpOfTwo = exp
            
        // MARK: - Navigation actions
            
        case .navigateToIntroduction: 
            newState.viewState = .guide
            newState.guideState = .introduction
            
        case .navigateToSmoothie:
            newState.guideState = .smoothie
            
        case .navigateToFrequency:
            newState.guideState = .frequency
            
        case .navigateToEpicycle:
            newState.guideState = .epicycle
            
        case .navigateToRealWorld:
            newState.guideState = .realWorld
            
        case .navigateToTryYourself:
            newState.guideState = .tryYourself
            
        case .navigateToGallery:
            newState.guideState = .introduction
            newState.drawingTitles = ModelSVG.allCases
            
            newState.viewState = .gallery
            
        case .navigateToDrawing(let svg):
            newState.viewState = .drawing(svg)
            
        // MARK: - Image controls
            
        case .increaseCircleNumber:
            if newState.currentExpOfTwo < 11 {
                newState.currentExpOfTwo += 1
            }
        
        case .decreaseCircleNumber:
            if newState.currentExpOfTwo > 2 {
                newState.currentExpOfTwo -= 1
            }
            
        default:
            break
    
    }
    return newState
}

