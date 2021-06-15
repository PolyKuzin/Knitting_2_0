//
//  InformationCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
	
	static let reuseID = "InformationCell"
	
	@IBOutlet weak var emailLabel    : UILabel!
	@IBOutlet weak var nicknameLabel : UILabel!
	@IBOutlet weak var profileImage  : UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		profileImage.roundCorners(.allCorners, radius: profileImage.frame.height / 2)
	}

	func configure(with data: Any) {
		switch data {
		case is PanProfileVC.ViewState.Information:
			let data = data as! PanProfileVC.ViewState.Information
			self.emailLabel    .text  = data.email
			self.nicknameLabel .text  = data.name
			self.profileImage  .image = data.image
		default:
			break
		}
	}
}
