//
//  MainButtonCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _MainButton {
	var title : String   { get set }
	var onTap : (()->()) { get set }
	var color : UIColor  { get set }
}

class MainButtonCell: UITableViewCell {
	
	static var reuseId = "MainButtonCell"
	
	private var onTap : (()->())?

	@IBOutlet weak var button : MainButton!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.button.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
		self.button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
    }
    
	@objc
	private func tap() {
		self.onTap?()
	}
	
	public func configure(with data: _MainButton) {
		self.onTap = data.onTap
		self.button.setTitle(data.title)
		self.button.setColor(data.color)
	}
}
