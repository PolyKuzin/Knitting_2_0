//
//  NewProjectCardVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 21.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class NewProjectCardVM {

	private var createLabel : UILabel = {
		let label						= UILabel()
		label.text 						= "Create new project"
		label.font 						= Fonts.displayMedium20		//CHANGE to dispayBold20
		label.textColor 				= .black
		label.textAlignment 			= .center
		
		return label
	}()
	
	private var projectImageView : UIImageView = {
		let imageView					= UIImageView()
		imageView.image					= UIImage(named: "emptyProject")
		imageView.layer.cornerRadius	= 20
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	func create() -> UILabel {
		return createLabel
	}
	
	func profileImage() -> UIImageView {
		return projectImageView
	}
}
