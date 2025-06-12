//
//  InflatingCircle.swift
//  test
//
//  Created by bat on 10/6/25.
//

import UIKit

public class InflatingCircle: ArcComponent {
    
    // MARK: - private vars
    private var centerOffset: CGPoint
    /// Radius at animation start
    /// From the frame provided for drawing, we get the max radius (aka min(width,height)), radiusRateStart allow computing radius from there. Must be in range [0, 1]
    private var radiusRateStart: CGFloat
    /// Radius at animation end
    private var radiusRateEnd: CGFloat
    /// At radiusRateStart we have alpha=0 until currentRadiusRate reaches alphaStepGrowth
    /// alphaStepGrowth is in range [0, 1] with 0=radiusRateStart, 1=radiusRateEnd
    private var alphaStepGrowth: CGFloat
    /// At radiusRateEnd we have alpha=0, it starts decreasing at alphaStepDecrease
    /// alphaStepDecrease is in range [0, 1] with 0=radiusRateStart, 1=radiusRateEnd
    private var alphaStepDecrease: CGFloat
    /// Line width
    private var lineWidth: CGFloat
    /// Arc rotating speed (degree per second)
    private var speed: CGFloat
    /// Animation delay
    private var delay: CGFloat
    /// Animation start time
    private var startTime: Date?
    /// Latest draw time
    private var latestTime: Date?
    /// Current radiusRate
    private var currentRadiusRate: CGFloat?
    /// Indicates if start delay is elapsed
    private var started: Bool = false
    /// Color
    private var color: UIColor = .gray
    /// Current color = color + current alpha
    private var currentColor: UIColor?

    // MARK: - init
    public init(centerOffset: CGPoint,
                radiusRateStart: CGFloat,
                radiusRateEnd: CGFloat,
                alphaStepGrowth: CGFloat,
                alphaStepDecrease: CGFloat,
                lineWidth: CGFloat,
                speed: CGFloat,
                delay: CGFloat = 0,
                color: UIColor? = nil) {
        guard radiusRateStart <= 1 && radiusRateStart >= 0 else {
            fatalError("Radius rate define the radius from the frame size, it's value should be in range [0, 1]")
        }
        guard radiusRateEnd <= 1 && radiusRateEnd >= 0 else {
            fatalError("Radius rate define the radius from the frame size, it's value should be in range [0, 1]")
        }
        self.centerOffset = centerOffset
        self.radiusRateStart = radiusRateStart
        self.radiusRateEnd = radiusRateEnd
        self.alphaStepGrowth = alphaStepGrowth
        self.alphaStepDecrease = alphaStepDecrease
        self.lineWidth = lineWidth
        if let color = color {
            self.color = color
        }
        self.speed = speed
        self.delay = delay
    }

    // MARK: - public
    
    /// Start animation initalize arc data and define the time start for computation
    public func startAnimating() {
        startTime = Date()
        latestTime = startTime
        currentRadiusRate = radiusRateStart
    }
    
    /// Stop the animation, reset all parameters
    public func stopAnimating() {
        startTime = nil
        latestTime = nil
        currentRadiusRate = nil
    }

    /// Compute data for current time and draw the arc
    /// This must be called within a graphic context (`UIView.draw` in most of the cases)
    public func draw(_ rect: CGRect) {
        guard let _ = startTime,
            let _ = currentRadiusRate else { return }
        compute()
        // We might have a start delay, let's not start before that
        guard started else { return }
        let (center, radius) = computeFromRect(rect)
        guard let currentColor = currentColor else {
            assertionFailure("Compute issue, missing data")
            return
        }
        // Draw
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0 ,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        currentColor.setStroke()
        path.stroke()
    }

    // MARK: - internal
    internal func compute() {
        guard let latestTime = latestTime,
              let currentRadiusRate = currentRadiusRate else {
            assertionFailure("unexpected undefined data")
            return
        }
        
        // Time and delay
        let drawTime = Date()
        var elapsedTime = drawTime.timeIntervalSince(latestTime)
        if !started {
            if elapsedTime > delay {
                started = true
                elapsedTime = elapsedTime - delay
            } else {
                // Wait for elapsed delay
                return 
            }
        }
        self.latestTime = drawTime
        
        // Compute movement
        var nextRadiusRate = currentRadiusRate + speed * elapsedTime
        if nextRadiusRate > radiusRateEnd {
            let diff = nextRadiusRate - radiusRateEnd
            nextRadiusRate = radiusRateStart + diff
        }
        self.currentRadiusRate = nextRadiusRate
        
        // Compute color
        let alpha = alphaAt(currentRadiusRate)
        currentColor = color.withAlphaComponent(alpha)
    }
    
    internal func computeFromRect(_ rect: CGRect) -> (CGPoint, CGFloat) {
        guard let currentRadiusRate = currentRadiusRate else {
            assertionFailure("undefined currentRadiusRate")
            return (CGPoint.zero, 0)
        }
        // Compute center + radius
        let frameCenter = CGPoint(x: rect.midX, y: rect.midY)
        let center = CGPoint(x: frameCenter.x + centerOffset.x,
                             y: frameCenter.y + centerOffset.y)
        
        let frameMaxRadius = (min(rect.width, rect.height) - lineWidth) / 2
        let radius = frameMaxRadius * currentRadiusRate
        return (center, radius)
    }
    
    private func alphaAt(_ radiusRate: CGFloat) -> CGFloat {
        let relativeRadiusRate = (radiusRate - radiusRateStart) / (radiusRateEnd - radiusRateStart)
        var alpha: CGFloat = 1
        if relativeRadiusRate < alphaStepGrowth {
            alpha = 1 - (alphaStepGrowth - relativeRadiusRate) / ( alphaStepGrowth )
        } else if relativeRadiusRate > alphaStepDecrease {
            alpha = 1 - (relativeRadiusRate - alphaStepDecrease) / ( 1 - alphaStepDecrease )
        }
        return alpha
    }
}
