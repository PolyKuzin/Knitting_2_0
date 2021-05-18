//
//  CounterView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class CounterCellView : UIView {
	
	@IBOutlet weak var plusButton  : UIImageView!
	@IBOutlet weak var minusButton : UIImageView!
	@IBOutlet weak var counterName : UILabel!
	@IBOutlet weak var currentRows : UILabel!

	override func awakeFromNib() {
		self.plusButton.image  = UIImage.plus_btn
		self.minusButton.image = UIImage.minus_btn
		isUserInteractionEnabled = true
		roundCorners([.topLeft, .bottomLeft], radius: 20)
	}
	
	public func configure(with data: Counter) {
		self.counterName.text = data.name
		if let rows = data.rows {
			self.currentRows.text = String(rows)
		} else {
			self.currentRows.text = "Az"
		}
	}
}
