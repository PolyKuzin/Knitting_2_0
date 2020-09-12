//
//  UIViewExt.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 01.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

//Gradient backGround color
extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer			= CAGradientLayer()
        gradientLayer.frame			= bounds
		gradientLayer.locations		= [0.0, 1.0]
		gradientLayer.startPoint	= CGPoint(x: 0.5, y: 1.0)
		gradientLayer.endPoint		= CGPoint(x: 0.5, y: 0.0)
        gradientLayer.colors		= [colorOne.cgColor, colorTwo.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//Animation For Errors
extension UIView {
	
	func shakeAnimation(){
		let shake		= CABasicAnimation(keyPath: "position")
		let fromPoint	= CGPoint(x: center.x - 5, y: center.y)
		let fromValue	= NSValue(cgPoint: fromPoint)
		let toPoint		= CGPoint(x: center.x + 5, y: center.y)
		let toValue		= NSValue(cgPoint: toPoint)
		shake.duration	= 0.1
		shake.repeatCount = 2
		shake.autoreverses = true
		shake.fromValue = fromValue
		shake.toValue = toValue
		layer.add(shake, forKey: "position")
	}
}

extension UIView {
    
    func pinEdgesToSuperView() {
		guard let superView = superview else { return }
		translatesAutoresizingMaskIntoConstraints							= false
		topAnchor.constraint(equalTo: superView.topAnchor).isActive			= true
		leftAnchor.constraint(equalTo: superView.leftAnchor).isActive		= true
		bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive	= true
		rightAnchor.constraint(equalTo: superView.rightAnchor).isActive		= true
	}
}
