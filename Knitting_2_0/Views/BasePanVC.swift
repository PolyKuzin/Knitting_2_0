//
//  BasePanVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class BasePanVC : UIViewController {
	
	var becomePro : (()->()) = {
		print("BECOME PRO")
	}
	
	var onPrivacy : (()->()) = {
		print("PRIVACY")
	}
	
	var onRestore : (()->()) = {
		print("RESTORE")
	}
	
	var onTerms   : (()->()) = {
		print("TERMS")
	}
	
	public func getColor() -> UIColor {
		return UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
