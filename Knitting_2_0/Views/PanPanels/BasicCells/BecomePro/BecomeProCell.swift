//
//  BecomeProCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _BecomePro {
	var onBecomePro : (()->()) { get set}
}

class BecomeProCell : UITableViewCell {
	
	static let reuseID = "BecomeProCell"
	
	private var onBecomePro : (()->())?
	
	@IBOutlet weak var purchaiseButton : MainButton!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.purchaiseButton.addTarget(self, action: #selector(self.becomePro), for: .touchUpInside)
		self.purchaiseButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		self.purchaiseButton.roundCorners(.allCorners, radius: 15)
		self.purchaiseButton.setColor(UIColor(red: 0.552, green: 0.325, blue: 0.779, alpha: 1))
		self.purchaiseButton.setTitle("Become PRO Knitter".localized())
		self.purchaiseButton.setImage(UIImage(named: "Diamond")!)
    }
	
	@objc
	private func becomePro() {
		self.onBecomePro?()
	}
	
	public func configure(with data: _BecomePro) {
		self.onBecomePro = data.onBecomePro
	}
}
