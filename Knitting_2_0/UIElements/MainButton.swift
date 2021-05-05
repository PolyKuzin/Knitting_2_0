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
		self.titleLabel?.font = UIFont.medium_17
		self.backgroundColor = UIColor.mainColor
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	public func setTitle(_ text: String)    {
		setTitle(text.localized(), for: .normal)
		titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
	}
	
	public func setImage(_ image: UIImage?)  {
		guard let image = image else { return }
		setImage(image, for: .normal)
	}
	
	public func setColor(_ color: UIColor?) {
		guard let color = color else { return }
		self.backgroundColor = color
	}
}
