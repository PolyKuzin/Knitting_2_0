//
//  IAP_PricingCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 01.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _IAP_PricingCell {
	var title         : String { get set }
}

class IAP_PricingCell : UITableViewCell {
	
	static let reuseID = "IAP_PricingCell"
	
	@IBOutlet weak var title : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
    }
    
	public func configure(with data: _IAP_PricingCell) {
		self.title.text = data.title
	}
}
