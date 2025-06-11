//
//  Circle.swift
//  test
//
//  Created by bat on 11/6/25.
//

import UIKit

public class Circle: ArcComponent {
    
    // MARK: - private vars
    private var centerOffset: CGPoint
    /// From the frame provided for drawing, we get the max radius (aka min(width,height)), radiusRate allow computing radius from there. Must be in range [0, 1]
    internal var radiusRate: CGFloat
    /// Line width
    private var lineWidth: CGFloat
    /// Color
    private var color: UIColor = .gray
    /// Fill the circle ?
    private var fill: Bool
    
    // MARK: - init
    public init(centerOffset: CGPoint,
                radiusRate: CGFloat,
                lineWidth: CGFloat,
                fill: Bool,
                color: UIColor? = nil) {
        guard radiusRate <= 1 && radiusRate >= 0 else {
            fatalError("Radius rate define the radius from the frame size, it's value should be in range [0, 1]")
        }
        self.centerOffset = centerOffset
        self.radiusRate = radiusRate
        self.lineWidth = lineWidth
        self.lineWidth = lineWidth
        if let color = color {
            self.color = color
        }
        self.fill = fill
    }
    
    // MARK: - public
    
    public func startAnimating() {
        // Not animated
    }
    
    public func stopAnimating() {
        // Not animated
    }
    
    public func draw(_ rect: CGRect) {
        let (center, radius) = computeFromRect(rect)
        // Draw
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0 ,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        if fill {
            color.setFill()
            path.fill()
        } else {
            color.setStroke()
            path.stroke()
        }
    }
    
    internal func computeFromRect(_ rect: CGRect) -> (CGPoint, CGFloat) {
        // Compute center + radius
        let frameCenter = CGPoint(x: rect.midX, y: rect.midY)
        let frameMaxRadius = (min(rect.width, rect.height) - lineWidth) / 2
        let center = CGPoint(x: frameCenter.x + centerOffset.x,
                             y: frameCenter.y + centerOffset.y)
        let radius = frameMaxRadius * radiusRate
        return (center, radius)
    }
}
