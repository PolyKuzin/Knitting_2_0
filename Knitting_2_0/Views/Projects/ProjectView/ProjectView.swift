//
//  ProjectView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class ProjectView : UIView {
	
	@IBOutlet weak var image : UIImageView!
	@IBOutlet weak var title : UILabel!
	@IBOutlet weak var body  : UILabel!

	override func awakeFromNib() {
		isUserInteractionEnabled = true
	}
	
	public func configure(with data: Project) {
		self.image.image = data.image
		self.title.text  = data.name
		self.body.text   = data.info
	}
}
