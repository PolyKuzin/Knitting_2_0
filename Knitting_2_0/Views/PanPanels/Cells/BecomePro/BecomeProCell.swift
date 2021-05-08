//
//  BecomeProCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _BecomePro {
	var image       : UIImage?   { get set }
	var title       : String     { get set }
	var color       : UIColor?   { get set }
	var onBecomePro : (()->())   { get set }
}

class BecomeProCell : UITableViewCell {
	
	static let reuseID = "BecomeProCell"
	
	private var onBecomePro : (()->())?
	
	@IBOutlet weak var button : MainButton!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.button.setGradient()
		self.selectionStyle = .none
		self.button.addTarget(self, action: #selector(self.becomePro), for: .touchUpInside)
    }
	
	@objc
	private func becomePro() {
		self.onBecomePro?()
	}
	
	public func configure(with data: _BecomePro) {
		self.button.setTitle(data.title)
		self.button.setImage(data.image)
		if let imageView = self.button.imageView {
			self.button.bringSubviewToFront(imageView)
		}
		self.onBecomePro = data.onBecomePro
	}
}
