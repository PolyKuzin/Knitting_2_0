//
//  ProjectCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class ProjectCell: SwipeableCollectionViewCell {
    
	static var reuseId 							= "projectCell"
	
	let projectName								= UILabel()
	var projectImage 							= UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
		
		self.layer.cornerRadius					= 20
        projectImage.layer.cornerRadius         = 10
		self.clipsToBounds						= true
        projectImage.clipsToBounds              = true
		visibleContainerView.backgroundColor 	= Colors.whiteColor
		editContainerView.backgroundColor		= UIColor(red: 0.616, green: 0.733, blue: 0.875, alpha: 1)
		deleteContainerView.backgroundColor 	= UIColor(red: 0.984, green: 0.682, blue: 0.827, alpha: 1)
		duplicateContainerView.backgroundColor  = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	}
	
	func configurу(with project: MProject) {
		
		
		projectImage.image 						= project.image.toImage()
		projectName.text						= project.name
		
		projectName.font						= Fonts.displaySemibold22
		
		visibleContainerView	.roundCorners([.topLeft, .bottomLeft], radius: 20)
		duplicateContainerView	.roundCorners([.topRight, .bottomRight], radius: 20)
		layer.cornerRadius						= 20
		layer.borderWidth						= 0.0
		layer.shadowColor						= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
		layer.shadowOffset						= CGSize(width: 0, height: 8)
		layer.shadowRadius						= 10
		layer.shadowOpacity						= 1
		layer.masksToBounds						= false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: Layout
extension ProjectCell {
	
	func setupLayout() {
		sendSubviewToBack(visibleContainerView)
		
        visibleContainerView.addSubview(projectImage)
		projectImage.translatesAutoresizingMaskIntoConstraints														= false
		projectImage.leadingAnchor.constraint(equalTo: visibleContainerView.leadingAnchor, constant: 20).isActive	= true
		projectImage.topAnchor.constraint(equalTo: visibleContainerView.topAnchor, constant: 20).isActive			= true
		projectImage.heightAnchor.constraint(equalTo: visibleContainerView.heightAnchor, constant: -40).isActive	= true
		projectImage.widthAnchor.constraint(equalTo: projectImage.heightAnchor).isActive							= true
		
        visibleContainerView.addSubview(projectName)
		projectName.translatesAutoresizingMaskIntoConstraints														= false
		projectName.leadingAnchor.constraint(equalTo: projectImage.trailingAnchor, constant: 20).isActive			= true
		projectName.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor).isActive					= true
		projectName.trailingAnchor.constraint(equalTo: visibleContainerView.trailingAnchor, constant: -20).isActive	= true
		projectName.heightAnchor.constraint(equalToConstant: 26).isActive											= true
	}
}
