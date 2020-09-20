//
//  SetionHeader.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 18.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
	
	static let reusedId = "SectionHeader"
	
	let title			: UILabel = {
		let label		= UILabel()
		label.textColor = .black							//TO CONSTANTS
		label.font		= Fonts.displayBold28
		
		return label
	}()
	
	let profileImage	: UIImageView = {
		let imageView	= UIImageView()
		imageView.image = UIImage(named: "emptyProfile") 	//TO CONSTANTS
        imageView.isUserInteractionEnabled = true
		
		return imageView
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
		addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints									= false
		profileImage.topAnchor.constraint(equalTo: topAnchor).isActive							= true
		profileImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive	= true
		profileImage.heightAnchor.constraint(equalToConstant: 40).isActive						= true
		profileImage.widthAnchor.constraint(equalToConstant: 40).isActive						= true

		addSubview(title)
		title.translatesAutoresizingMaskIntoConstraints											= false
		title.topAnchor.constraint(equalTo: topAnchor).isActive									= true
		title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive							= true
		title.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor).isActive			= true
		title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive							= true
	}
}
