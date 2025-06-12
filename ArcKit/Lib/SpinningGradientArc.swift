//
//  SpinningGradientArc.swift
//  test
//
//  Created by bat on 5/6/25.
//

import UIKit

public class SpinningGradientArc: SpinningArc {
    
    public enum Interpolation {
        case linear
        case pow(x: CGFloat)
    }
    
    // MARK: - private vars
    private var colorStart: UIColor
    private var colorEnd: UIColor
    private var colorInterpPolicy: Interpolation
    private var alphaStart: CGFloat
    private var alphaEnd: CGFloat
    private var alphaInterpPolicy: Interpolation

    // MARK: - init
    public init(centerOffset: CGPoint,
                radiusRate: CGFloat,
                startAngle: CGFloat,
                endAngle: CGFloat,
                lineWidth: CGFloat,
                colorStart: UIColor,
                colorEnd: UIColor,
                colorInterp: Interpolation,
                alphaStart: CGFloat,
                alphaEnd: CGFloat,
                alphaInterp: Interpolation,
                speed: CGFloat,
                acc: CGFloat = 0,
                clockwise: Bool = true,
                startPolicy: StartPolicy = .full) {
        self.colorStart = colorStart
        self.colorEnd = colorEnd
        self.colorInterpPolicy = colorInterp
        self.alphaStart = alphaStart
        self.alphaEnd = alphaEnd
        self.alphaInterpPolicy = alphaInterp

        super.init(centerOffset: centerOffset,
                   radiusRate: radiusRate,
                   startAngle: startAngle,
                   endAngle: endAngle,
                   lineWidth: lineWidth,
                   speed: speed,
                   acc: acc,
                   clockwise: clockwise,
                   startPolicy: startPolicy)
    }
    
    // MARK: - override
    public override func draw(_ rect: CGRect) {
        guard let _ = startTime else { return }
        compute()
        let (center, radius) = computeFromRect(rect)
        guard let currentStartAngle = currentStartAngle,
            let currentEndAngle = currentEndAngle else {
            assertionFailure("Compute issue, missing data")
            return
        }
        // How many samples do we need for a clean alpha/color interpolation ?
        // Let's compute arc length
        let diffAngle = abs(startAngle - endAngle)
        let arcLen = 2 * CGFloat.pi * radius * diffAngle / 360.0
        // let's say a sample each 3 pixel
        let samples = Int(floor(arcLen / 3.0))
        // And go sampling
        var sampleStartAngle = currentStartAngle
        let sampleAngle = (currentEndAngle - currentStartAngle) / CGFloat(samples)
        for i in 0 ..< samples {
            // Compute current color
            let samplingProgression = CGFloat(i) / CGFloat(samples)
            let sampleEndAngle = sampleStartAngle + sampleAngle
            var colorInterp: CGFloat
            switch colorInterpPolicy {
                case .linear:
                    colorInterp = samplingProgression
                case .pow(let x):
                    colorInterp = pow(samplingProgression, x)
            }
            var alphaInterp: CGFloat
            switch alphaInterpPolicy {
                case .linear:
                    alphaInterp = samplingProgression
                case .pow(let x):
                    alphaInterp = pow(samplingProgression, x)
            }
            guard let colorStartComponents = colorStart.cgColor.components,
                  let colorEndComponents = colorEnd.cgColor.components else {
                assertionFailure("Color issue")
                return
            }
            let r = lerp(a: colorEndComponents[0],
                         b: colorStartComponents[0],
                         progress: colorInterp)
            let g = lerp(a: colorEndComponents[1],
                         b: colorStartComponents[1],
                         progress: colorInterp)
            let b = lerp(a: colorEndComponents[2],
                         b: colorStartComponents[2],
                         progress: colorInterp)
            let a = lerp(a: alphaEnd,
                         b: alphaStart,
                         progress: alphaInterp)
            let currentColor = UIColor(red: r, green: g, blue: b, alpha: a)
            // Draw path
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius,
                                    startAngle: sampleStartAngle * CGFloat.pi / 180.0,
                                    endAngle: sampleEndAngle * CGFloat.pi / 180.0,
                                    clockwise: true)
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            currentColor.setStroke()
            path.stroke()
            sampleStartAngle = sampleEndAngle
        }
    }
    
    public override func compute() {
        super.compute()
    }
    
    // MARK: - private
    private func lerp(a: CGFloat, b: CGFloat, progress: CGFloat) -> CGFloat {
        guard progress >= 0  else {
            assertionFailure("Values can only be lerped from 0 to 1 \(progress)...")
            return a
        }
        guard progress <= 1 else {
            assertionFailure("Values can only be lerped from 0 to 1 \(progress)...")
            return b
        }
        return a * (1 - progress) + b * progress
    }
}

