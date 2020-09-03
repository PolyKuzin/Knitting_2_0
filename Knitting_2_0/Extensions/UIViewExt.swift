//
//  UIViewExt.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 01.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//extension UIView {	
//    
//    func pinEdgesToSuperView() {
//		guard let superView = superview else { return }
//		translatesAutoresizingMaskIntoConstraints = false
//		topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
//		leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
//		bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
//		rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
//	}
//}
