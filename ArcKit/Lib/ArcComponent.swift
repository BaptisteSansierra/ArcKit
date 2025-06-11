//
//  ArcComponent.swift
//  test
//
//  Created by bat on 10/6/25.
//

import UIKit

public protocol ArcComponent {
    func draw(_ rect: CGRect)
    func startAnimating()
    func stopAnimating()
}
