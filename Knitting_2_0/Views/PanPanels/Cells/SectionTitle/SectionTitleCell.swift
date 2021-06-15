//
//  SectionTitleCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 08.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _Title {
	var title          : String { get set }
}

class SectionTitleCell : UITableViewCell {
	
	@IBOutlet weak var title : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
	
	public func configure(with data: _Title) {
		self.title.text = data.title
		if UserDefaults.standard.bool(forKey: "setPro") == false {
			self.title.alpha = 0.4
		}
	}
}
