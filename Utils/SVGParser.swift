//
//  File.swift
//  
//
//  Created by Gustavo Munhoz Correa on 01/02/24.
//

import Foundation

class SVGParser: NSObject {
    private var parser: XMLParser?
    private var currentElement: String?
    private var pathsData: [String] = []

    public func parse(data: Data, withExp exp: Int) -> [FourierPath] {
        self.parser = XMLParser(data: data)
        self.parser?.delegate = self
        self.pathsData.removeAll()
        parser?.parse()
        let paths = pathsData.map { processPathData($0, withExp: exp) }
        return paths
    }
}


extension SVGParser: XMLParserDelegate {
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "path", let d = attributeDict["d"] {
            pathsData.append(d)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = nil
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse error: \(parseError.localizedDescription)")
    }
}

extension SVGParser {
    func processPathData(_ data: String, withExp exp: Int) -> FourierPath {
        var points: [CGPoint] = []
        let commandSet: Set<Character> = ["M", "m", "L", "l", "C", "c", "H", "h", "V", "v", "S", "s", "Z", "z"]
        var currentCommand: Character = " "
        var currentValues: [CGFloat] = []
        let pattern = "([a-zA-Z])"
        let range = NSRange(data.startIndex..<data.endIndex, in: data)
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        var dataString = regex.stringByReplacingMatches(in: data, options: [], range: range, withTemplate: " $1 ")

        dataString = dataString
                        .replacingOccurrences(of: ",", with: " ")
                        .replacingOccurrences(of: "-", with: " -")

        let elements = dataString.split(whereSeparator: { $0.isWhitespace }).map(String.init)
        var lastControlPoint: CGPoint? = nil

        var index = 0
        while index < elements.count {
            let element = elements[index]

            if let char = element.first, commandSet.contains(char) {
                if !currentValues.isEmpty {
                    processCommand(&points, currentCommand: currentCommand, currentValues: &currentValues, lastControlPoint: &lastControlPoint)

                }
                currentCommand = char
                index += 1
            } else {
                if let value = Double(element) {
                    currentValues.append(CGFloat(value))
                }
                index += 1
            }
        }

        processCommand(&points, currentCommand: currentCommand, currentValues: &currentValues, lastControlPoint: &lastControlPoint)
        
        let downsampledPoints = downsamplePointsToFitPowerOfTwo(points: points, maxPowerOfTwoExp: exp)
        let complexPoints = FourierTransformHelper.convertPointsToComplex(points: downsampledPoints)
        
        return FourierPath(complexPoints: complexPoints)
    }

    private func processCommand(_ points: inout [CGPoint], currentCommand: Character, currentValues: inout [CGFloat], lastControlPoint: inout CGPoint?) {
        let isRelative = currentCommand.isLowercase
        var lastPoint = points.last ?? .zero
        
        func reflectedControlPoint() -> CGPoint {
            guard let lastCP = lastControlPoint, let lastEndPoint = points.last else { return lastPoint }
            return CGPoint(x: 2 * lastEndPoint.x - lastCP.x, y: 2 * lastEndPoint.y - lastCP.y)
        }
        
        switch currentCommand.uppercased() {
            case "M":
                while currentValues.count >= 2 {
                    let x = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    lastPoint = CGPoint(x: x, y: y)
                    
                    points.append(lastPoint)
                }

            case "L":
                while currentValues.count >= 2 {
                    let x = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    lastPoint = CGPoint(x: x, y: y)
                    
                    points.append(lastPoint)
                }
                
                
            case "H":
                while !currentValues.isEmpty {
                    let x = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    lastPoint = CGPoint(x: x, y: lastPoint.y)
                    points.append(lastPoint)
                }
                    
            case "V":
                while !currentValues.isEmpty {
                    let y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    lastPoint = CGPoint(x: lastPoint.x, y: y)
                    points.append(lastPoint)
                }
                    
            case "C":
                while currentValues.count >= 6 {
                    let controlPoint1X = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let controlPoint1Y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    let controlPoint2X = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let controlPoint2Y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    let endPointX = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let endPointY = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    let controlPoint1 = CGPoint(x: controlPoint1X, y: controlPoint1Y)
                    let controlPoint2 = CGPoint(x: controlPoint2X, y: controlPoint2Y)
                    let endPoint = CGPoint(x: endPointX, y: endPointY)

                    addCubicBezierCurve(&points, controlPoint1: controlPoint1, controlPoint2: controlPoint2, endPoint: endPoint)
                    lastPoint = endPoint
                    lastControlPoint = controlPoint2
                }
                
            case "S":
                while currentValues.count >= 4 {
                    let firstControlPoint = lastControlPoint != nil ? reflectedControlPoint() : lastPoint
                    let controlPoint2X = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let controlPoint2Y = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()
                    let endPointX = isRelative ? lastPoint.x + currentValues.removeFirst() : currentValues.removeFirst()
                    let endPointY = isRelative ? lastPoint.y + currentValues.removeFirst() : currentValues.removeFirst()

                    let controlPoint2 = CGPoint(x: controlPoint2X, y: controlPoint2Y)
                    let endPoint = CGPoint(x: endPointX, y: endPointY)

                    addCubicBezierCurve(&points, controlPoint1: firstControlPoint, controlPoint2: controlPoint2, endPoint: endPoint)
                    lastPoint = endPoint
                    lastControlPoint = controlPoint2
                }
                
            case "Z":
                lastControlPoint = nil
                lastPoint = points.last ?? .zero

                
        default:
            fatalError("SVG Command not implemented")
        }
    }

    private func addCubicBezierCurve(_ points: inout [CGPoint], controlPoint1: CGPoint, controlPoint2: CGPoint, endPoint: CGPoint) {
        let startPoint = points.last ?? .zero
        let steps = 200

        for step in 1...steps {
            let t = CGFloat(step) / CGFloat(steps)
            let mt = 1 - t
            let x = mt * mt * mt * startPoint.x +
                    3 * mt * mt * t * controlPoint1.x +
                    3 * mt * t * t * controlPoint2.x +
                    t * t * t * endPoint.x
            
            let y = mt * mt * mt * startPoint.y +
                    3 * mt * mt * t * controlPoint1.y +
                    3 * mt * t * t * controlPoint2.y +
                    t * t * t * endPoint.y
            
            points.append(CGPoint(x: x, y: y))
        }
    }
    
    private func downsamplePointsToFitPowerOfTwo(points: [CGPoint], maxPowerOfTwoExp: Int) -> [CGPoint] {
        let maxPoints = min(points.count, 1 << maxPowerOfTwoExp)
        
        guard !points.isEmpty else { return [] }
        
        let interval = CGFloat(points.count - 1) / CGFloat(maxPoints - 1)
        
        var downsampledPoints: [CGPoint] = []
        
        for index in 0..<maxPoints {
            let originalIndex = Int(round(CGFloat(index) * interval))
            if originalIndex < points.count {
                downsampledPoints.append(points[originalIndex])
            }
        }
        
        if downsampledPoints.last != points.last {
            downsampledPoints.append(points.last!)
        }
        
        return downsampledPoints
    }
}
