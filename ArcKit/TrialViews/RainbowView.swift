//
//  RainbowView.swift
//  test
//
//  Created by bat on 6/6/25.
//

import UIKit

public class RainbowView: ArcTrialView {
    
    // MARK: - private vars
    static private var colors: [UIColor] = [
        UIColor.red,
        UIColor.yellow,
        UIColor.green,
        UIColor.blue,
        UIColor.purple]
    private var narcs = 100
    
    // MARK: - init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createArcs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    override public func stopAnimating() {
        super.stopAnimating()
        createArcs()
    }

    // MARK: - private
    private func createArcs() {
        clearArcs()
        for i in 0..<narcs {
            let position = CGFloat(i) / CGFloat(narcs)
            let color = RainbowView.getColorFromPosition(position)
            addArc(SpinningArc(centerOffset: CGPoint.zero,
                               radiusRate: position,
                               startAngle: CGFloat.random(in: 1...50),
                               endAngle: CGFloat.random(in: 245...295),
                               lineWidth: 1,
                               speed: CGFloat.random(in: -50...50),
                               color: color))
        }
    }
    
    private class func getColorFromPosition(_ position: CGFloat) -> UIColor {
        let colPos = CGFloat(colors.count - 1) * position
        let colIndex = Int(floor(colPos))
        guard colIndex < colors.count - 1 else {
            return colors[colors.count - 1]
        }
        let lerpVal = colPos - CGFloat(colIndex)
        guard let colorStartComponents = colors[colIndex].cgColor.components,
              let colorEndComponents = colors[colIndex + 1].cgColor.components else {
            assertionFailure("Color issue")
            return .black
        }
        let r = lerp(a: colorStartComponents[0],
                     b: colorEndComponents[0],
                     progress: lerpVal)
        let g = lerp(a: colorStartComponents[1],
                     b: colorEndComponents[1],
                     progress: lerpVal)
        let b = lerp(a: colorStartComponents[2],
                     b: colorEndComponents[2],
                     progress: lerpVal)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    private class func lerp(a: CGFloat, b: CGFloat, progress: CGFloat) -> CGFloat {
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
