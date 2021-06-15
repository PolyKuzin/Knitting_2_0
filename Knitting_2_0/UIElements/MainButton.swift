//
//  MainButton.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

let ChangeColorNotification = "ru.polykuzin.ChangeColor"

// TODO: добавить функцию добавления действия

@IBDesignable
class MainButton : UIButton {
	
	private func setup() {
		self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		self.roundCorners(.allCorners, radius: 15)
		self.setTitleColor(UIColor.white, for: .normal)
		self.titleLabel?.font = UIFont.medium_17
		self.backgroundColor = UIColor.mainColor
		NotificationCenter.default.addObserver(self, selector: #selector(updateColor),
											   name: NSNotification.Name(rawValue: ChangeColorNotification), object: nil)
	}
	
	@objc
	private func updateColor() {
		self.setColor(UIColor.mainColor)
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
	
	public func setGradient() {
		let gradientLayer			= CAGradientLayer()
		gradientLayer.frame			= bounds
		gradientLayer.locations		= [0.0, 1.0]
		gradientLayer.startPoint	= CGPoint(x: 0.5, y: 1.0)
		gradientLayer.endPoint		= CGPoint(x: 0.5, y: 0.0)
		gradientLayer.colors		= [UIColor(red: 0.551, green: 0.408, blue: 0.858, alpha: 1).cgColor,
									   UIColor(red: 0.739, green: 0.577, blue: 0.900, alpha: 1).cgColor]
		layer.insertSublayer(gradientLayer, at: 0)
	}
}
