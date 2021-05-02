//
//  CreateCounterCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _SwitcherCell {
	var title      : String       { get set }
	var onSwitch   : ((Bool)->()) { get set }
}

class SwitcherCell : UITableViewCell {
	
	static var reuseId = "CreateCounterCell"
	
	@IBOutlet weak var label    : UILabel!
	@IBOutlet weak var switcher : UISwitch!
	
	private var onSwitch : ((Bool)->())?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
	}
	
	@IBAction func onSwitch(_ sender: Any) {
		self.onSwitch?(switcher.isOn)
	}
	
	public func configure(with data: _SwitcherCell) {
		self.onSwitch   = data.onSwitch
		self.label.text = data.title
	}
}
