//
//  Sonar.swift
//  test
//
//  Created by bat on 6/6/25.
//

import UIKit

public class SonarView: ArcTrialView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let speed: CGFloat = 150
        let lineWidth: CGFloat = 2
        //let baseColor = UIColor(red: 23/255.0, green: 172/255.0, blue: 44/255.0, alpha: 1)
        let baseColor = UIColor(red: 180/255.0, green: 172/255.0, blue: 172/255.0, alpha: 1)
        /*
        addArc(Circle(centerOffset: CGPoint.zero,
                      radiusRate: 1,
                      lineWidth: 1,
                      fill: false,
                      color: baseColor.withAlphaComponent(0.3)))
        addArc(Circle(centerOffset: CGPoint.zero,
                      radiusRate: 0.01,
                      lineWidth: 1,
                      fill: false,
                      color: baseColor.withAlphaComponent(0.3)))
        addArc(Circle(centerOffset: CGPoint.zero,
                      radiusRate: 1,
                      lineWidth: 1,
                      fill: true,
                      color: baseColor.withAlphaComponent(0.05)))
         */
        addArc(Circle(centerOffset: CGPoint.zero,
                      radiusRate: 1,
                      lineWidth: 1,
                      fill: true,
                      color: .black.withAlphaComponent(0.01)))
        addArc(SpinningGradientArc(centerOffset: CGPoint.zero,
                                   radiusRate: 1,
                                   startAngle: -45,
                                   endAngle: 45,
                                   lineWidth: lineWidth,
                                   colorTip: baseColor,
                                   colorFoot: baseColor,
                                   colorInterp: .linear,
                                   alphaTip: 1,
                                   alphaFoot: 0,
                                   alphaInterp: .linear,
                                   speed: speed,
                                   acc: 0,
                                   startPolicy: .progressive))
        addArc(SpinningGradientArc(centerOffset: CGPoint.zero,
                                   radiusRate: 0.75,
                                   startAngle: -45,
                                   endAngle: 45,
                                   lineWidth: lineWidth,
                                   colorTip: baseColor,
                                   colorFoot: baseColor,
                                   colorInterp: .linear,
                                   alphaTip: 1,
                                   alphaFoot: 0,
                                   alphaInterp: .pow(x: 2),
                                   speed: speed,
                                   acc: 0,
                                   startPolicy: .progressive))
        addArc(SpinningGradientArc(centerOffset: CGPoint.zero,
                                   radiusRate: 0.5,
                                   startAngle: -45,
                                   endAngle: 45,
                                   lineWidth: lineWidth,
                                   colorTip: baseColor,
                                   colorFoot: baseColor,
                                   colorInterp: .linear,
                                   alphaTip: 1,
                                   alphaFoot: 0,
                                   alphaInterp: .pow(x: 3),
                                   speed: speed,
                                   acc: 0,
                                   startPolicy: .progressive))
        addArc(SpinningGradientArc(centerOffset: CGPoint.zero,
                                   radiusRate: 0.25,
                                   startAngle: -45,
                                   endAngle: 45,
                                   lineWidth: lineWidth,
                                   colorTip: baseColor,
                                   colorFoot: baseColor,
                                   colorInterp: .linear,
                                   alphaTip: 1,
                                   alphaFoot: 0,
                                   alphaInterp: .pow(x: 4),
                                   speed: speed,
                                   acc: 0,
                                   startPolicy: .progressive))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
