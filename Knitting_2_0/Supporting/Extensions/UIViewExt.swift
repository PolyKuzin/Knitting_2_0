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

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}

typealias EdgeClosure = (_ view: UIView, _ superview: UIView) -> ([NSLayoutConstraint])

enum Corners {
	case all
	case top
	case bottom
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
	case allButTopLeft
	case allButTopRight
	case allButBottomLeft
	case allButBottomRight
	case left
	case right
	case topLeftBottomRight
	case topRightBottomLeft
}

extension UIView {
	// MARK: - Load From Nib
	/**
	 Load the view from a nib file called with the name of the class;
	  - note: The first object of the nib file **must** be of the matching class
	  - parameters:
		- none
	 */
	static func loadFromNib() -> Self {
		let bundle = Bundle(for: self)
		let nib = UINib(nibName: String(describing: self), bundle: bundle)
		return nib.instantiate(withOwner: nil, options: nil).first as! Self
	}
	
	// MARK: - Constraints
	/**
	 Method **adds** a view to the superView, seted translatesAutoresizingMaskIntoConstraints to **false** and activates constrates
	 - parameters:
		- on: View on which view schould be fixed
	 */
	func pin(on superview: UIView, _ callback: EdgeClosure) {
		superview.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		callback(self, superview).forEach {
			$0.isActive = true
		}
	}
	
	// MARK: - Round Cornerns
	/**
	 Sets the cornerRadius for selected corners from **Corners** enum
	 - parameters:
		- corners:
			* all
			* top
			* bottom
			* topLeft
			* topRight
			* bottomLeft
			* bottomRight
			* allButTopLeft
			* allButTopRight
			* allButBottomLeft
			* allButBottomRight
			* left
			* right
			* topLeftBottomRight
			* topRightBottomLeft
		- radius: The **CGFloat** value to be set
	 */
	func roundCorners(_ corners: Corners, radius: CGFloat) {
		var cornerMasks = [CACornerMask]()
		
		// Top left corner
		switch corners {
		case .all, .top, .topLeft, .allButTopRight, .allButBottomLeft, .allButBottomRight, .topLeftBottomRight:
			cornerMasks.append(CACornerMask(rawValue: UIRectCorner.topLeft.rawValue))
		default:
			break
		}
		
		// Top right corner
		switch corners {
		case .all, .top, .topRight, .allButTopLeft, .allButBottomLeft, .allButBottomRight, .topRightBottomLeft:
			cornerMasks.append(CACornerMask(rawValue: UIRectCorner.topRight.rawValue))
		default:
			break
		}
		
		// Bottom left corner
		switch corners {
		case .all, .bottom, .bottomLeft, .allButTopRight, .allButTopLeft, .allButBottomRight, .topRightBottomLeft:
			cornerMasks.append(CACornerMask(rawValue: UIRectCorner.bottomLeft.rawValue))
		default:
			break
		}
		
		// Bottom right corner
		switch corners {
		case .all, .bottom, .bottomRight, .allButTopRight, .allButTopLeft, .allButBottomLeft, .topLeftBottomRight:
			cornerMasks.append(CACornerMask(rawValue: UIRectCorner.bottomRight.rawValue))
		default:
			break
		}
		
		clipsToBounds = true
		layer.cornerRadius = radius
		if #available(iOS 11.0, *) {
			layer.maskedCorners = CACornerMask(cornerMasks)
		} else {
			// Fallback on earlier versions
		}
	}
	
	/**
	 Adds a gradient layer **at 0** to the view with a color from **top - left** to **botom - right**
	 */
	func setGradientBackground(topLeftColor : UIColor, botomRightColor: UIColor) {
		let gradientLayer               = CAGradientLayer()
		gradientLayer.frame             = bounds
		gradientLayer.locations         = [0.0, 1.0]
		gradientLayer.startPoint        = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint          = CGPoint(x: 1, y: 1)
		gradientLayer.colors            = [topLeftColor.cgColor, botomRightColor.cgColor]
		layer.insertSublayer(gradientLayer, at: 0)
	}
}
