//
//  ProjectCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class ProjectCell: SwipeableCollectionViewCell {
    
	static var reuseId = "projectCell"
	
	let projectName		= UILabel()
	var projectImage 	= UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupElements()
		setupConstraints()
		
		self.layer.cornerRadius = 15
		self.clipsToBounds = true
	}
	
	func configure() { //(with project: MProject) {
		projectImage.image 	= UIImage(named: "empty")
		projectName.text	= "Empty Project"
	}
	
	func setupElements() {
		projectImage.backgroundColor = .black
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: Layout
extension ProjectCell {
	
	func setupConstraints() {
		addSubview(projectName)
		addSubview(projectImage)
		
		projectName.translatesAutoresizingMaskIntoConstraints	= false
		projectName.leadingAnchor.constraint(equalTo: projectImage.trailingAnchor, constant: 20).isActive	= true
		projectName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive								= true
		projectName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive				= true
		projectName.heightAnchor.constraint(equalToConstant: 26).isActive									= true
		
		projectImage.translatesAutoresizingMaskIntoConstraints												= false
		projectImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive				= true
		projectImage.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive						= true
		projectImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -40).isActive					= true
		projectImage.widthAnchor.constraint(equalTo: projectImage.heightAnchor).isActive					= true
	}
}
