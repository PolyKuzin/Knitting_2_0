//
//  CounterView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class CounterCellView : UIView {
	
	private var onPlusRow  : (()->())?
	private var onMinusRow : (()->())?

	@IBOutlet weak var plusButton  : UIImageView!
	@IBOutlet weak var minusButton : UIImageView!
	@IBOutlet weak var counterName : UILabel!
	@IBOutlet weak var currentRows : UILabel!

	override func awakeFromNib() {
		isUserInteractionEnabled = true
		self.plusButton.isUserInteractionEnabled = true
		self.minusButton.isUserInteractionEnabled = true

		self.plusButton .image  = UIImage.plus_btn
		self.minusButton.image = UIImage.minus_btn
		
		let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.plusTapped))
		tap1.numberOfTapsRequired = 1
		self.plusButton.addGestureRecognizer(tap1)
		let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.minusTapped))
		tap2.numberOfTapsRequired = 1
		self.minusButton.addGestureRecognizer(tap2)
		
		roundCorners([.topLeft, .bottomLeft], radius: 20)
	}
	
	@objc
	private func plusTapped() {
		self.onPlusRow?()
	}
	
	@objc
	private func minusTapped() {
		self.onMinusRow?()
	}
	
	public func configure(with data: _CountersView) {
		self.counterName.text = data.counter.name
		if let rows = data.counter.rows {
			self.currentRows.text = String(rows)
		} else {
			self.currentRows.text = "Az"
		}
		self.onPlusRow  = data.onPlusRow
		self.onMinusRow = data.onMinusRow
	}
}
