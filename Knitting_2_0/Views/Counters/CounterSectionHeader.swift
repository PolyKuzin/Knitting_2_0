//
//  CounterSectionHeader.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 30.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
	
	static let reusedId = "CounterSectionHeader"
	
	var title				: UILabel = {
		let label			= UILabel()
		label.textColor 	= .black							//TO CONSTANTS
		label.font			= Fonts.displayBold28
		label.textAlignment = .center
		
		return label
	}()
	
	var profileImage		: UIImageView = {
		let imageView		= UIImageView()
		imageView.isUserInteractionEnabled = true
		imageView.layer.cornerRadius = 20
		
		return imageView
	}()
	
	var createCounter		: UIButton = {
		let button			= UIButton()
		button.backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		button.frame = CGRect(x: 0, y: 0, width: 155, height: 40)
		button.setTitle("+ Create counter".localized(), for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		button.layer.cornerRadius = 15
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension SectionHeader {
	
	private func setupLayout() {
		
		translatesAutoresizingMaskIntoConstraints												= false
		heightAnchor.constraint(equalToConstant: 240).isActive									= true
		
		addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints									= false
		profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive					= true
		profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive				= true
		profileImage.heightAnchor.constraint(equalToConstant: 125).isActive						= true
		profileImage.widthAnchor.constraint(equalToConstant: 125).isActive						= true

		addSubview(title)
		title.translatesAutoresizingMaskIntoConstraints											= false
		title.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive	= true
		title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive							= true
		title.heightAnchor.constraint(equalToConstant: 35).isActive								= true
		
		addSubview(createCounter)
		createCounter.translatesAutoresizingMaskIntoConstraints									= false
		createCounter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive					= true
		createCounter.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive	= true
		createCounter.heightAnchor.constraint(equalToConstant: 52).isActive						= true
		createCounter.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16).isActive = true
	}
}

