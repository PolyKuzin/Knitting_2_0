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
		frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		roundCorners(.allCorners, radius: 15)
		setTitleColor(UIColor.white, for: .normal)
		titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
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
	}
	
	public func setImage(_ image: UIImage) {
		setImage(image, for: .normal)
	}
}
