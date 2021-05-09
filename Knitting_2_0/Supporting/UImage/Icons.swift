//
//  Icons.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

extension UIImage {
	
	public class var logoIcon : UIImage {
		return UIImage(named: "logoIcon") ?? UIImage()
	}
	
	public class var delete   : UIImage {
		return UIImage(named: "delete")    ?? UIImage()
	}
	
	public class var emptyProject : UIImage {
		return UIImage(named: "_0")    ?? UIImage()
	}
	
	public class var backIcon : UIImage {
		return UIImage(named: "arrow")    ?? UIImage()
	}
	
	public class var emptyProfile : UIImage {
		return UIImage(named: "emptyProfile")    ?? UIImage()
	}
	
	public class var exit : UIImage {
		return UIImage(named: "exit")    ?? UIImage()
	}
	
	public class var moon : UIImage {
		switch UserDefaults.standard.integer(forKey: "Color_background") {
		case 1  :
			return UIImage(named: "Moon_Dark")   ?? UIImage()
		default :
			return UIImage(named: "Moon_Light")   ?? UIImage()
		}
	}
	
	public class var sun : UIImage {
		switch UserDefaults.standard.integer(forKey: "Color_background") {
		case 1  :
			return UIImage(named: "Sun_Dark")   ?? UIImage()
		default :
			return UIImage(named: "Sun_Light")   ?? UIImage()
		}
	}
	
	public class var phone : UIImage {
		switch UserDefaults.standard.integer(forKey: "Color_background") {
		case 1  :
			return UIImage(named: "Phone_Dark")   ?? UIImage()
		default :
			return UIImage(named: "Phone_Light")   ?? UIImage()
		}
	}
	
	/// red     - for red theme
	/// green  - for green theme
	/// purple - for purple theme
	public class var plus_btn  : UIImage {
		switch UserDefaults.standard.string(forKey: "Color_main") {
		case "red"   :
			return UIImage(named: "plus_red")   ?? UIImage()
		case "green" :
			return UIImage(named: "plus_green") ?? UIImage()
		default      :
			return UIImage(named: "plus_purp")  ?? UIImage()
		}
	}
	
	/// red     - for red theme
	/// green  - for green theme
	/// purple - for purple theme
	public class var minus_btn : UIImage {
		switch UserDefaults.standard.string(forKey: "Color_main") {
		case "red"   :
			return UIImage(named: "minus_red")   ?? UIImage()
		case "green" :
			return UIImage(named: "minus_green") ?? UIImage()
		default      :
			return UIImage(named: "minus_purp")  ?? UIImage()
		}
	}
}
