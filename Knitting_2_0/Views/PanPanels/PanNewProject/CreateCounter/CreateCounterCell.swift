//
//  CreateCounterCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class CreateCounterCell: UITableViewCell {
	
	static var reuseId = "CreateCounterCell"
	
	@IBOutlet weak var label    : UILabel!
	@IBOutlet weak var switcher : UISwitch!
	
	private var onSwitch : ((Bool)->())?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.label.text = "Create counter with project name?".localized()
		
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	@IBAction func onSwitch(_ sender: Any) {
		self.onSwitch?(switcher.isOn)
	}
	
	public func configure(with data: Any) {
		if let data = data as? PanNewProject.ViewState.SelectCounter {
			self.onSwitch = data.onSwitch
		}
	}
}
