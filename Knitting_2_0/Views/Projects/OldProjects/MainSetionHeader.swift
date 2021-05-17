//
//  SetionHeader.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 18.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class MainSectionHeader: UICollectionReusableView {
	
	static let reusedId = "SectionHeader"
	
	let title			: UILabel = {
		let label		= UILabel()
		label.textColor = .black
		label.font		= UIFont.bold_28
		
		return label
	}()
	
	let profileImage	: UIImageView = {
		let imageView	= UIImageView()
		imageView.image = UIImage(named: "emptyProfile")
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

extension MainSectionHeader {
	
	private func setupLayout() {
		addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints	= false
		NSLayoutConstraint.activate([
			profileImage.topAnchor.constraint(equalTo: topAnchor),
			profileImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			profileImage.heightAnchor.constraint(equalToConstant: 40),
			profileImage.widthAnchor.constraint(equalToConstant: 40),
			profileImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15)
		])
		

		addSubview(title)
		title.translatesAutoresizingMaskIntoConstraints			= false
		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
			title.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
			title.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15)
		])
	}
}
