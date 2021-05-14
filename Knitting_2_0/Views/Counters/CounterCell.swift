//
//  CounterCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 30.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class CounterCell								: SwipeableCollectionViewCell {
	
	let counterName								: UILabel = {
		let label 								= UILabel()
		label.font								= UIFont.semibold_17
		label.frame 							= CGRect(x: 0, y: 0, width: 65, height: 20)
		label.textColor 						= UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
		
		return label
	}()
	
	let currentRows								: UILabel = {
		let label								= UILabel()
		label.font								= UIFont.rounded
		label.frame								= CGRect(x: 0, y: 0, width: 75, height: 86)
		label.textColor							= UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		
		return label
	}()
	
	let plusButton								: UIButton = {
		let imageView							= UIButton()
		imageView.setImage(UIImage.plus_btn, for: .normal)
		return imageView
	}()
	
	let minusButton								: UIButton = {
		let imageView							= UIButton()
		imageView.setImage(UIImage.minus_btn, for: .normal)
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
		
		self.layer.cornerRadius					= 20
		self.clipsToBounds						= true
		editContainerView.backgroundColor		= UIColor.secondary
		visibleContainerView.backgroundColor 	= UIColor.white
		deleteContainerView.backgroundColor 	= UIColor.third
		duplicateContainerView.backgroundColor  = UIColor.mainColor

	}
	
	func configurу(with counter: MCounter) {
		
		counterName.text = counter.name
		currentRows.text = String(counter.rows)
		
		visibleContainerView.roundCorners([.topLeft, .bottomLeft], radius: 20)
		duplicateContainerView	.roundCorners([.topRight, .bottomRight], radius: 20)

		layer.cornerRadius						= 20
		layer.borderWidth						= 0.0
		layer.shadowColor						= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
		layer.shadowOffset						= CGSize(width: 0, height: 8)
		layer.shadowRadius						= 7
		layer.shadowOpacity						= 1
		layer.masksToBounds						= false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: Layout
extension CounterCell	{
	
	func setupLayout()	{
		sendSubviewToBack(visibleContainerView)

		visibleContainerView.addSubview(counterName)
		counterName.translatesAutoresizingMaskIntoConstraints = false

		visibleContainerView.addSubview(currentRows)
		currentRows.translatesAutoresizingMaskIntoConstraints = false

		visibleContainerView.addSubview(plusButton)
		plusButton.translatesAutoresizingMaskIntoConstraints = false

		visibleContainerView.addSubview(minusButton)
		minusButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			counterName.topAnchor.constraint(equalTo: visibleContainerView.topAnchor, constant: 12),
			counterName.centerXAnchor.constraint(equalTo: visibleContainerView.centerXAnchor),
			
			currentRows.centerXAnchor.constraint(equalTo: visibleContainerView.centerXAnchor),
			currentRows.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor),
			
			plusButton.trailingAnchor.constraint(equalTo: visibleContainerView.trailingAnchor, constant: -10),
			plusButton.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor),
			plusButton.heightAnchor.constraint(equalToConstant: self.frame.height - 20),
			plusButton.widthAnchor.constraint(equalTo: heightAnchor),
			
			minusButton.leadingAnchor.constraint(equalTo: visibleContainerView.leadingAnchor, constant: 10),
			minusButton.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor),
			minusButton.heightAnchor.constraint(equalToConstant: self.frame.height - 20),
			minusButton.widthAnchor.constraint(equalTo: heightAnchor)
		])
	}
}
