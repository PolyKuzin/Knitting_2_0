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
	}
	
	public func configure(with data: String) {
		self.label.text = data
	}
}
