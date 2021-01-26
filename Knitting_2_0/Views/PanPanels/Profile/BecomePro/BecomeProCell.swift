//
//  BecomeProCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class BecomeProCell: UITableViewCell {
	
	static let reuseID = "BecomeProCell"
	
	@IBOutlet weak var suplyLabel      : UILabel!
	@IBOutlet weak var purchaiseButton : MainButton!

    override func awakeFromNib() {
        super.awakeFromNib()
		purchaiseButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		suplyLabel.text = "Try 7-days free trial, then $4/month".localized()
		purchaiseButton.setTitle("Become PRO Knitter".localized())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
