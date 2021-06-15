//
//  ErrorCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _Error {
	var title    : String   { get set }
	var image    : UIImage? { get set }
	var onSelect : (()->()) { get set }
}

class ErrorCell : UICollectionViewCell {
	
	private var onSelect : (()->())?
	
	@IBOutlet weak var title     : UILabel!
	@IBOutlet weak var button    : MainButton!
	@IBOutlet weak var imageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.button.addTarget(self, action: #selector(self.onTap), for: .touchUpInside)
    }
	
	@objc
	private func onTap() {
		self.onSelect?()
	}
	
	public func configure(with data: _Error) {
		self.onSelect = data.onSelect
		self.title.text = data.title
		if let image = data.image {
			self.imageView.image = image
		} else {
//			self.imageView.image = UIimage.error
		}
	}
}
