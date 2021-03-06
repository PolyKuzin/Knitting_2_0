//
//  UITableViewCell+Ext.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	static var nib  : UINib{
		return UINib(nibName: reuseId, bundle: nil)
	}
	
	static var reuseId : String{
		return String(describing: self)
	}
}
