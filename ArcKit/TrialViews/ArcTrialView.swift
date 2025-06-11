//
//  ArcTrialView.swift
//  test
//
//  Created by bat on 11/6/25.
//

import UIKit

open class ArcTrialView: UIView {
    
    // MARK: - private vars
    private var timer: Timer?
    private var arcs: [ArcComponent]

    // MARK: - init
    override public init(frame: CGRect) {
        arcs = [ArcComponent]()
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - override
    override open func draw(_ rect: CGRect) {
        for arc in arcs {
            arc.draw(rect)
        }
    }

    // MARK: - open
    open func addArc(_ arc: ArcComponent) {
        arcs.append(arc)
    }

    open func clearArcs() {
        arcs.removeAll()
    }

    open func startAnimating() {
        if let timer = timer {
            timer.invalidate()
        }
        for arc in arcs {
            arc.startAnimating()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
            DispatchQueue.main.async {
                self?.setNeedsDisplay()
            }
        })
    }
    
    open func stopAnimating() {
        timer?.invalidate()
        for arc in arcs {
            arc.stopAnimating()
        }
    }
}
