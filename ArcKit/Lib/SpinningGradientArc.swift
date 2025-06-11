//
//  SpinningGradientArc.swift
//  test
//
//  Created by bat on 5/6/25.
//

import UIKit

class SpinningGradientArc: SpinningArc {
    
    public enum Interpolation {
        case linear
        case pow(x: CGFloat)
    }
    
    private var colorTip: UIColor
    private var colorFoot: UIColor
    private var colorInterpPolicy: Interpolation

    private var alphaTip: CGFloat
    private var alphaFoot: CGFloat
    private var alphaInterpPolicy: Interpolation

    public init(centerOffset: CGPoint,
                radiusRate: CGFloat,
                startAngle: CGFloat,
                endAngle: CGFloat,
                lineWidth: CGFloat,
                colorTip: UIColor,
                colorFoot: UIColor,
                colorInterp: Interpolation,
                alphaTip: CGFloat,
                alphaFoot: CGFloat,
                alphaInterp: Interpolation,
                speed: CGFloat,
                acc: CGFloat = 0,
                clockwise: Bool = true,
                startPolicy: StartPolicy = .full) {
        
        self.colorTip = colorTip
        self.colorFoot = colorFoot
        self.colorInterpPolicy = colorInterp
        self.alphaTip = alphaTip
        self.alphaFoot = alphaFoot
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
    
    
    override func draw(_ rect: CGRect) {
        guard let _ = startTime else { return }
        compute()
        let (center, radius) = computeFromRect(rect)

        // How many samples do we need for a clean alpha/color interpolation ?
        // Let's compute arc length
        let diffAngle = abs(startAngle - endAngle)
        let arcLen = 2 * CGFloat.pi * radius * diffAngle / 360.0
        // let's say a sample each 3 pixel
        let samples = Int(floor(arcLen / 3.0))
        
        // And go sampling
        var sampleStartAngle = currentStartAngle!
        let sampleAngle = (currentEndAngle! - currentStartAngle!) / CGFloat(samples)
        for i in 0 ..< samples {
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

            let r = lerp(a: colorFoot.cgColor.components![0],
                         b: colorTip.cgColor.components![0],
                         progress: colorInterp)
            let g = lerp(a: colorFoot.cgColor.components![1],
                         b: colorTip.cgColor.components![1],
                         progress: colorInterp)
            let b = lerp(a: colorFoot.cgColor.components![2],
                         b: colorTip.cgColor.components![2],
                         progress: colorInterp)
            let a = lerp(a: alphaFoot,
                         b: alphaTip,
                         progress: alphaInterp)
            
            let currentColor = UIColor(red: r, green: g, blue: b, alpha: a)
                        
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
    
    
    override func compute() {
        super.compute()
    }
    
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

