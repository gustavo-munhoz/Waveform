//
//  FourierCoefficient.swift
//  
//
//  Created by Gustavo Munhoz Correa on 19/02/24.
//

import Accelerate

struct FourierCoefficient {
    var value: DSPDoubleComplex
    var amplitude: CGFloat
    var phase: CGFloat
    var frequency: CGFloat
}

struct FourierPath {
    var complexPoints: [DSPDoubleComplex]
}
