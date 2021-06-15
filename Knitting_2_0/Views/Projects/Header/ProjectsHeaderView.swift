//
//  ProjectsHeaderView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 29.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class ProjectsHeaderView : UICollectionReusableView {
	
	private var onProfileTap : (()->())?
	
	@IBOutlet weak var title     : UILabel!
	@IBOutlet weak var onProfile : UIButton!

	@IBAction func onTap() {
		self.onProfileTap?()
	}
	
	override func awakeFromNib() {
		
	}
	
	public func configure(title: String, action: @escaping (()->())) {
		self.title.text = title
		self.onProfileTap = action
	}
}
