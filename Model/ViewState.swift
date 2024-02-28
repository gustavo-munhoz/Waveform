//
//  ViewState.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import Foundation

enum ViewState {
    case start
    case guide
    case gallery
    case drawing(ModelSVG)
    
    var isGuide: Bool {
        if case .guide = self {
            return true
        }
        return false
    }
    
    var isStart: Bool {
        if case .start = self {
            return true
        }
        return false
    }
}
