//
//  IAP_ButtonCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 29.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class IAP_ButtonCell: UITableViewCell {
	
	static var reuseId = "IAP_ButtonCell"
	
	private var onSelect : (()->())?
	
	@IBOutlet weak var button : UIButton!
	
	@IBAction func onButtonTap() {
		self.onSelect?()
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
	public func configure(with data: _MainButton) {
		self.onSelect = data.onTap
		self.button.backgroundColor = data.color
		self.button.setTitle(data.title, for: .normal)
	}
}
