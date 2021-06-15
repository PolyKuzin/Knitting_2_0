//
//  CountersHeader.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 22.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _CountersHeader {
	var project  : Project  { get set }
	var onSelect : (()->()) { get set }
}

class CountersHeader : UICollectionReusableView {
	
	private var onAdd  : (()->())?
	private var onBack : (()->())?
	
	@IBOutlet weak var addCounter : MainButton!
	@IBOutlet weak var backButton : UIButton!
	@IBOutlet weak var image      : UIImageView!
	@IBOutlet weak var title      : UILabel!
	@IBOutlet weak var body       : UILabel!
	
	override func awakeFromNib() {
		self.addCounter.setTitle("+ Create counter".localized())
		self.backButton.addTarget(self, action: #selector(self.onTap), for: .touchUpInside)
		self.addCounter.addTarget(self, action: #selector(self.onAddTap), for: .touchUpInside)
	}
	
	@objc
	private func onTap() {
		self.onBack?()
	}
	
	@objc
	private func onAddTap() {
		self.onAdd?()
	}
	
	public func configure(with data: (Project, (()->()), (()->()))) {
		self.image.image = data.0.image
		self.title.text  = data.0.name
		self.body.text   = data.0.info
		self.onBack      = data.1
		self.onAdd       = data.2
	}
}
