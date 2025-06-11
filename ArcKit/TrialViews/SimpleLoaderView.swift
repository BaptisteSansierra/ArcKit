//
//  SimpleSpinnerView.swift
//  test
//
//  Created by bat on 10/6/25.
//

import UIKit

public class SimpleSpinnerView: ArcTrialView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addArc(SpinningGradientArc(centerOffset: CGPoint.zero,
                                   radiusRate: 1,
                                   startAngle: -45,
                                   endAngle: 45,
                                   lineWidth: 5,
                                   colorTip: .blue,
                                   colorFoot: .blue,
                                   colorInterp: .linear,
                                   alphaTip: 1,
                                   alphaFoot: 0,
                                   alphaInterp: .pow(x: 2),
                                   speed: 200,
                                   acc: 0,
                                   startPolicy: .progressive))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
