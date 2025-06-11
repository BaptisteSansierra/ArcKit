//
//  ViewController.swift
//  ArcKitDemo
//
//  Created by bat on 11/6/25.
//

import UIKit
import ArcKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectorSc: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func didUpdateSelectorValue(_ sender: Any) {
        updateContent()
    }
    
    @IBAction func didPressResetBt(_ sender: Any) {
        trialView?.stopAnimating()
        trialView?.startAnimating()
    }
    
    // MARK: - private vars
    private var trialView: ArcTrialView?

    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
    }

    // MARK: - private
    private func updateContent() {
        guard isViewLoaded else { return }
        trialView?.stopAnimating()
        trialView?.removeFromSuperview()
        switch selectorSc.selectedSegmentIndex {
            case 0:
                trialView = SimpleSpinnerView()
            case 1:
                trialView = MultiArcSpinnerView()
            case 2:
                trialView = BTScanner()
            case 3:
                trialView = SonarView()
            case 4:
                trialView = RainbowView()
            default:
                assertionFailure("Undefined segment")
                return
        }
        view.addSubview(trialView!)
        trialView!.backgroundColor = .clear
        trialView!.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: trialView!, attribute: .centerX, relatedBy: .equal,
                                              toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: trialView!, attribute: .top, relatedBy: .equal,
                                              toItem: view, attribute: .top, multiplier: 1, constant: 140))
        view.addConstraint(NSLayoutConstraint(item: trialView!, attribute: .height, relatedBy: .equal,
                                              toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270))
        view.addConstraint(NSLayoutConstraint(item: trialView!, attribute: .width, relatedBy: .equal,
                                              toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270))
        trialView!.startAnimating()
    }
}

