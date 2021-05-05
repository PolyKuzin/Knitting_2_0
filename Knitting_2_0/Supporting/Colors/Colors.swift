//
//  Colors.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

struct Colors {
	
	static let normalTextField			= UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
	static let normalBorderTextField	= UIColor(red: 0.82,  green: 0.82,  blue: 0.839, alpha: 1)
	static let errorTextField			= UIColor(red: 1,	  green: 0.954, blue: 0.976, alpha: 1)
	static let errorTextFieldBorder		= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)

	static let questionText				= UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
	static let errorLabel				= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)
	static let labelText				= UIColor(red: 0.234, green: 0.234, blue: 0.234, alpha: 1)
	
	static let borderButton				= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
	static let backgroundUpButton		= UIColor(red: 0.584, green: 0.475, blue: 0.82,  alpha: 1)

	static let backIcon					= UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
	static let hiddenContainerView		= UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
}

extension UIColor {
	
	/// dark - for dark theme
	/// light - for light theme
	public class var background : UIColor {
		switch UserDefaults.standard.string(forKey: "Color_background") {
		case "dark":
			return UIColor.black
		default:
			return UIColor.white
		}
	}
	
	/// red     - for red theme
	/// green  - for green theme
	/// purple - for purple theme
	public class var mainColor  : UIColor {
		switch UserDefaults.standard.string(forKey: "Color_main") {
		case "red"   :
			return UIColor(red: 1.000, green: 0.346, blue: 0.346, alpha: 1)
		case "green" :
			return UIColor(red: 0.494, green: 0.875, blue: 0.624, alpha: 1)
		default      :
			return UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		}
	}
	
	public class var secondary  : UIColor {
		switch UserDefaults.standard.string(forKey: "Color_main") {
		case "red"   :
			return UIColor(red: 1.000, green: 0.533, blue: 0.533, alpha: 1)
		case "green" :
			return UIColor(red: 0.107, green: 0.758, blue: 0.602, alpha: 1)
		default      :
			return UIColor(red: 0.616, green: 0.733, blue: 0.875, alpha: 1)
		}
	}
	
	public class var third      : UIColor {
		switch UserDefaults.standard.string(forKey: "Color_main") {
		case "red"   :
			return UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
		case "green" :
			return UIColor(red: 0.529, green: 0.824, blue: 0.753, alpha: 1)
		default      :
			return UIColor(red: 0.984, green: 0.682, blue: 0.827, alpha: 1)
		}
	}
}
