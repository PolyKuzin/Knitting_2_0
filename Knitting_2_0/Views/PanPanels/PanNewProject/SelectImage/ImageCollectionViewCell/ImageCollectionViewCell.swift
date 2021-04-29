//
//  ImageCollectionViewCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "ImageCollectionViewCell"
	
	@IBOutlet weak var lockerImage : UIImageView!
	@IBOutlet weak var imageView   : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.imageView.layer.cornerRadius = 20
    }
	
	public func configure(with data: Any) {
		if let data = data as? Item {
			self.imageView.image = data.image
			if !data.isEnabled { self.lockerImage.isHidden = false } else { self.lockerImage.isHidden = true }
			if data.isSelected {
				self.imageView.layer.borderWidth = 3
				self.imageView.layer.borderColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1).cgColor
			} else {
				self.imageView.layer.borderWidth = 0
			}
		}
	}
}
