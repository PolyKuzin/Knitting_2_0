//
//  BenefitCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class BenefitCell: UITableViewCell {
	
	static let reuseID = "BenefitCell"
	
	@IBOutlet weak var mainLabel     : UILabel!
	@IBOutlet weak var leftImage     : UIImageView!
	@IBOutlet weak var containerView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
		containerView.backgroundColor = .white
		containerView.layer.cornerRadius  = 20
		containerView.layer.borderWidth   = 0.0
		containerView.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
		containerView.layer.shadowOffset  = CGSize(width: 0, height: 4)
		containerView.layer.shadowRadius  = 5
		containerView.layer.shadowOpacity = 1
		containerView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
	func configure(with data: Any) {
		switch data {
		case is PanProfileVC.ViewState.Benefit :
			let data = data as! PanProfileVC.ViewState.Benefit
			self.mainLabel.text  = data.text
			self.leftImage.image = data.image
		default:
			break
		}
	}
}
