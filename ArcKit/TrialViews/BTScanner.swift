//
//  BTScanner.swift
//  test
//
//  Created by bat on 10/6/25.
//

import UIKit

public class BTScanner: ArcTrialView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let alphaStepGrowth: CGFloat = 0.25
        let alphaStepDecrease: CGFloat = 0.75
        let speed: CGFloat = 0.5
        addArc(InflatingCircle(centerOffset: CGPoint.zero,
                               radiusRateStart: 0.3,
                               radiusRateEnd: 1,
                               alphaStepGrowth: alphaStepGrowth,
                               alphaStepDecrease: alphaStepDecrease,
                               lineWidth: 1,
                               speed: speed,
                               color: .gray))
        addArc(InflatingCircle(centerOffset: CGPoint.zero,
                               radiusRateStart: 0.3,
                               radiusRateEnd: 1,
                               alphaStepGrowth: alphaStepGrowth,
                               alphaStepDecrease: alphaStepDecrease,
                               lineWidth: 1,
                               speed: speed,
                               delay: 0.2,
                               color: .gray))
        addArc(InflatingCircle(centerOffset: CGPoint.zero,
                               radiusRateStart: 0.3,
                               radiusRateEnd: 1,
                               alphaStepGrowth: alphaStepGrowth,
                               alphaStepDecrease: alphaStepDecrease,
                               lineWidth: 1,
                               speed: speed,
                               delay: 0.4,
                               color: .gray))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
