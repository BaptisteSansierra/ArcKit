//
//  MultiArcSpinnerView.swift
//  test
//
//  Created by bat on 5/6/25.
//

import UIKit

public class MultiArcSpinnerView: ArcTrialView {
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let speedA: CGFloat = 100
        let speedB: CGFloat = -150
        let speedC: CGFloat = 200
        let lineWidth: CGFloat = 1
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.85,
                           startAngle: -45,
                           endAngle: 45,
                           lineWidth: lineWidth,
                           speed: speedA))
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.85,
                           startAngle: 135,
                           endAngle: 225,
                           lineWidth: lineWidth,
                           speed: speedA))
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.5,
                           startAngle: 45,
                           endAngle: 135,
                           lineWidth: lineWidth,
                           speed: speedB))
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.5,
                           startAngle: 225,
                           endAngle: 315,
                           lineWidth: lineWidth,
                           speed: speedB))
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.25,
                           startAngle: -45,
                           endAngle: 45,
                           lineWidth: lineWidth,
                           speed: speedC))
        addArc(SpinningArc(centerOffset: CGPoint.zero,
                           radiusRate: 0.25,
                           startAngle: 135,
                           endAngle: 225,
                           lineWidth: lineWidth,
                           speed: speedC))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
