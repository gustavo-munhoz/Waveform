//
//  FourierTransformHelper.swift
//
//
//  Created by Gustavo Munhoz Correa on 01/02/24.
//

import Accelerate

class FourierTransformHelper {
    static func convertPointsToComplex(points: [CGPoint]) -> [DSPDoubleComplex] {
        var complexPoints: [DSPDoubleComplex] = []
        
        for point in points {
            let complexPoint = DSPDoubleComplex(real: Double(point.x), imag: Double(point.y))
            complexPoints.append(complexPoint)
        }
        
        return complexPoints
    }
    
    static func applyFFT(to complexPoints: [DSPDoubleComplex]) -> [FourierCoefficient] {
        let n = complexPoints.count
        var coefficients: [FourierCoefficient] = []
        let log2n = vDSP_Length(log2(Double(n)))
        
        var realParts = [Double](repeating: 0, count: n)
        var imagParts = [Double](repeating: 0, count: n)
        for i in 0..<n {
            realParts[i] = complexPoints[i].real
            imagParts[i] = complexPoints[i].imag
        }
        
        guard let fftSetup = vDSP_create_fftsetupD(log2n, FFTRadix(kFFTRadix2)) else {
            fatalError("It was not possible to create FFT setup.")
        }
        
        realParts.withUnsafeMutableBufferPointer { realBuffer in
            imagParts.withUnsafeMutableBufferPointer { imagBuffer in
                var complexBuffer = DSPDoubleSplitComplex(realp: realBuffer.baseAddress!, imagp: imagBuffer.baseAddress!)
                
                vDSP_fft_zipD(fftSetup, &complexBuffer, 1, log2n, FFTDirection(FFT_FORWARD))
                
                for i in 0..<n {
                    let real = realBuffer[i]
                    let imag = imagBuffer[i]
                    let value = DSPDoubleComplex(real: real, imag: imag)
                    let amplitude = sqrt(real * real + imag * imag) / Double(n)
                    let phase = atan2(imag, real)
                    let frequency = i < n / 2 ? Double(i) : Double(i - n)
                    
                    let coefficient = FourierCoefficient(value: value, amplitude: amplitude, phase: phase, frequency: frequency)
                    coefficients.append(coefficient)
                }
            }
        }
        
        vDSP_destroy_fftsetupD(fftSetup)
        
        return coefficients.sorted(by: { $0.amplitude > $1.amplitude })
    }
}
