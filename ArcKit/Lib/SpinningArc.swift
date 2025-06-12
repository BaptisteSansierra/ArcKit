//
//  SpinningArc.swift
//  test
//
//  Created by bat on 5/6/25.
//

import UIKit

/// SpinningArc once `startAnimating` compute a rotating arc evolution parameters over time
/// It can be drawn at any moment by calling the `draw` method
public class SpinningArc: ArcComponent {

    // MARK: - enums

    /// StartPolicy define how the animation will start
    /// .full : start animating the full arc
    /// .progressive : arc will grow until reaching its adult size
    public enum StartPolicy {
        case full
        case progressive
    }

    // MARK: - internal vars
    internal var centerOffset: CGPoint
    /// From the frame provided for drawing, we get the max radius (aka min(width,height)), radiusRate allow computing radius from there. Must be in range [0, 1]
    internal var radiusRate: CGFloat
    /// Define if drawing clockwise
    internal var clockwise: Bool
    /// Start angle in degree
    internal var startAngle: CGFloat
    /// End angle in degree
    internal var endAngle: CGFloat
    /// Line width
    internal var lineWidth: CGFloat
    /// Arc rotating speed (degree per second)
    internal var speed: CGFloat  //
    /// Arc rotating acceleration (degree per second2)
    internal var acc: CGFloat
    /// Define the start drawing phase
    internal var startPolicy: StartPolicy

    internal var startTime: Date?
    internal var latestTime: Date?
    internal var currentStartAngle: CGFloat?
    internal var currentEndAngle: CGFloat?
    internal var currentSpeed: CGFloat?
    internal var startPhaseEnded = false

    // MARK: - private vars
    private var color: UIColor = .gray

    // MARK: - init
    public init(centerOffset: CGPoint,
                radiusRate: CGFloat,
                startAngle: CGFloat,
                endAngle: CGFloat,
                lineWidth: CGFloat,
                speed: CGFloat,
                acc: CGFloat = 0,
                color: UIColor? = nil,
                clockwise: Bool = true,
                startPolicy: StartPolicy = .full) {
        guard radiusRate <= 1 && radiusRate >= 0 else {
            fatalError("Radius rate define the radius from the frame size, it's value should be in range [0, 1]")
        }
        self.centerOffset = centerOffset
        self.radiusRate = radiusRate
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.lineWidth = lineWidth
        if let color = color {
            self.color = color
        }
        self.speed = speed
        self.acc = acc
        self.clockwise = clockwise
        self.startPolicy = startPolicy
    }
    
    // MARK: - public
    
    /// Start animation initalize arc data and define the time start for computation
    public func startAnimating() {
        startTime = Date()
        latestTime = startTime
        currentStartAngle = startAngle
        currentSpeed = speed
        switch startPolicy {
            case .full:
                currentEndAngle = endAngle
                startPhaseEnded = true
            case .progressive:
                currentEndAngle = startAngle
        }
    }
    
    /// Stop the animation, reset all parameters
    public func stopAnimating() {
        startTime = nil
        latestTime = nil
        currentStartAngle = nil
        currentEndAngle = nil
        currentSpeed = nil
        startPhaseEnded = false
    }

    /// Compute data for current time and draw the arc
    /// This must be called within a graphic context (`UIView.draw` in most of the cases)
    public func draw(_ rect: CGRect) {
        guard let _ = startTime else { return }
        compute()
        let (center, radius) = computeFromRect(rect)
        guard let currentStartAngle = currentStartAngle,
            let currentEndAngle = currentEndAngle else {
            assertionFailure("Compute issue, missing data")
            return
        }

        // Draw
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: currentStartAngle * CGFloat.pi / 180.0,
                                endAngle: currentEndAngle * CGFloat.pi / 180.0,
                                clockwise: clockwise)
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        color.setStroke()
        path.stroke()
    }

    // MARK: - internal
    internal func compute() {
        guard let latestTime = latestTime,
            let currentStartAngle = currentStartAngle,
            let currentEndAngle = currentEndAngle else {
            assertionFailure("unexpected undefined data")
            return
        }
        // Compute movement
        let drawTime = Date()
        let elapsedTime = drawTime.timeIntervalSince(latestTime)
        self.latestTime = drawTime

        if !startPhaseEnded && startPolicy == .progressive {
            let nextEndAngle = currentEndAngle + speed * elapsedTime
            let diffAngle = abs(endAngle - startAngle) // expected delta once arc is fully expanded
            if abs(nextEndAngle - currentStartAngle) < diffAngle {
                // currentStartAngle is kept to startAngle
            } else {
                let nextStartAngle = currentStartAngle + speed * elapsedTime
                // Ups, the step may be higher than expected from here
                // Apply the required correction
                let delta = abs(nextStartAngle - nextEndAngle) - diffAngle
                self.currentStartAngle = nextStartAngle + delta
                startPhaseEnded = true
            }
            self.currentEndAngle = nextEndAngle
        } else {
            self.currentStartAngle = currentStartAngle + speed * elapsedTime
            self.currentEndAngle = currentEndAngle + speed * elapsedTime
        }
        speed += acc * elapsedTime
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
