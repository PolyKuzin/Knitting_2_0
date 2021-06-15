//
//  DeleteView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class LabelView : UIView {
	
	@IBOutlet weak var label : UILabel!

	override func awakeFromNib() {
		isUserInteractionEnabled = true
		let width = (UIScreen.main.bounds.width - 40) / 4
		self.frame = CGRect(x: 0, y: 0, width: width, height: 130)
	}
	
	public func configure(with data: String) {
		self.label.text = data
	}
}
