//
//  ImageCollectionCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 09.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class ImageCollectionCell : UICollectionViewCell {

	static let reuseId = "ImageCollectionCell"
	
	@IBOutlet weak var imageView   : UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		self.layer.cornerRadius = 10
	}
	
	public func configure(with data: Item) {
	self.imageView.image = data.image
		UserDefaults.standard.bool(forKey: "setPro") ? (self.alpha = 1) : (self.alpha = 0.4)
		UserDefaults.standard.bool(forKey: "setPro") ? (self.imageView.alpha = 1) : (self.imageView.alpha = 0.4)
		if data.isSelected {
			self.layer.borderWidth = 3
			self.layer.borderColor = UIColor.mainColor.cgColor
		} else {
			self.layer.borderWidth = 0
		}
	}
}
