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
	let title = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		customisedElements()
		setupConstraints()
	}
	
	private func customisedElements() {
		title.textColor = .black
		title.font		= Fonts.displayMedium20 // change to UIFont(name: "SFProDisplay-Bold", size: 28)
	}
	
	private func setupConstraints() {
		addSubview(title)
		
		title.translatesAutoresizingMaskIntoConstraints = false
		title.topAnchor.constraint(equalTo: topAnchor).isActive = true
		title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
