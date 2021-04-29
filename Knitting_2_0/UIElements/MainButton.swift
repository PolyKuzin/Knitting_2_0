//
//  MainButton.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

@IBDesignable
class MainButton: UIButton {
	
	private func setup() {
		self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		self.roundCorners(.allCorners, radius: 15)
		self.setTitleColor(UIColor.white, for: .normal)
		self.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		self.backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	public func setTitle(_ text: String) {
		setTitle(text.localized(), for: .normal)
		titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
	}
	
	public func setImage(_ image: UIImage) {
		setImage(image, for: .normal)
	}
	
	public func setColor(_ color: UIColor) {
		self.backgroundColor = color
	}
}
