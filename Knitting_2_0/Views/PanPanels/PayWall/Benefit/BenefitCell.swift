//
//  BenefitCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _Benefit {
	var text      : String  { get set }
	var image     : UIImage { get set }
}

class BenefitCell : UITableViewCell {
	
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
    
	public func configure(with data: _Benefit) {
		self.mainLabel.text  = data.text
		self.leftImage.image = data.image
	}
}
