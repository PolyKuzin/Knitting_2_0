//
//  SwipingPageCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 19.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
	
	var page : Page? {
		didSet {
			guard let page = page else { return }
			screenImageView.image   = UIImage(named: page.imageName)
			titleLabel.text         = page.title
			descriptionLabel.text   = page.descrription
		}
	}
	
	private let screenImageView : UIImageView = {
		let imageView               = UIImageView()
		imageView.contentMode       = .scaleAspectFit
		
		return imageView
	}()
	
   private let titleLabel       : UILabel = {
		let title                   = UILabel()
		title.font                  = UIFont(name: "SFProRounded-Bold", size: 36)
		
		return title
	}()
	
   private let descriptionLabel : UILabel = {
		let description             = UILabel()
		description.numberOfLines   = 0
		description.font            = UIFont(name: "SFProRounded-Regular", size: 17)
		description.lineBreakMode   = .byWordWrapping
		
		return description
	}()
	
	let continueButton          : UIButton = {
		let button                  = UIButton(type: .system)
		button.frame                = CGRect(x: 0, y: 0, width: 181, height: 36)
		button.setTitle("   Продолжить   ", for: .normal)
		button.titleLabel?.font     = UIFont(name: "SFProRounded-Regular", size: 24)
		button.setTitleColor(UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1), for: .normal)
		button.layer.borderWidth    = 1
		button.layer.borderColor    = UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1).cgColor
		button.layer.cornerRadius   = 18
		
		button.isHidden = false
		
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PageCell {
	
	func setUpLayout() {
		
	}
}
