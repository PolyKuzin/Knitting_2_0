//
//  CheckCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 09.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _CheckCell {
	var title      : String  { get set }
	var leftIcon   : UIImage { get set }
	var isSelected : Bool    { get set }
}

class CheckCell : UITableViewCell {
	
	@IBOutlet weak var leftIcon : UIImageView!
	@IBOutlet weak var title    : UILabel!
	@IBOutlet weak var shevron  : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
	
	public func configure(with data: _CheckCell) {
		self.title.text = data.title
		self.leftIcon.image = data.leftIcon
		self.shevron.isHidden = !data.isSelected
	}
}
