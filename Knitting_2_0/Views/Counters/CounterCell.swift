//
//  CounterCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 30.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class CounterCell: SwipeableCollectionViewCell {
	
	static var reuseId 							= "counterCell"
	
	let deleteImageView: UIImageView = {
		guard let image							= Icons.delete?.withRenderingMode(.alwaysTemplate) else { return UIImageView() }
		let imageView							= UIImageView(image: image)
		imageView.tintColor						= .white
		return imageView
	}()
	
	let counterName								: UILabel = {
		let label 								= UILabel()
		label.font								= Fonts.textSemibold17
		label.frame 							= CGRect(x: 0, y: 0, width: 65, height: 20)
		label.textColor 						= UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
		
		return label
	}()
	
	let currentRows								: UILabel = {
		let label								= UILabel()
		label.font								= UIFont(name: "SFProRounded-Medium", size: 72)
		label.frame								= CGRect(x: 0, y: 0, width: 75, height: 86)
		label.textColor							= UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		
		return label
	}()
	
	let plusButton								: UIButton = {
		let imageView							= UIButton()
		imageView.setImage(UIImage(named: "addProject"), for: .normal)
		imageView.frame							= CGRect(x: 0, y: 0, width: 49, height: 49)
		
		return imageView
	}()
	
	let minusButton								: UIButton = {
		let imageView							= UIButton()
		imageView.setImage(UIImage(named: "minus"), for: .normal)
		imageView.frame							= CGRect(x: 0, y: 0, width: 32, height: 5)
		
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
		
		self.layer.cornerRadius					= 20
		self.clipsToBounds						= true
		editContainerView.backgroundColor		= .orange
		visibleContainerView.backgroundColor 	= Colors.whiteColor
		deleteContainerView.backgroundColor 	= Colors.hiddenContainerView
	}
	
	func configurу(with counter: MCounter) {
		
		counterName.text = counter.name
		currentRows.text = String(counter.rows)
		
		visibleContainerView.roundCorners([.topLeft, .bottomLeft], radius: 20)
		editContainerView.roundCorners([.topRight, .bottomRight], radius: 20)
		
		layer.cornerRadius						= 20
		layer.borderWidth						= 0.0
		layer.shadowColor						= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
		layer.shadowOffset						= CGSize(width: 0, height: 8)
		layer.shadowRadius						= 30.0
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
		counterName.topAnchor.constraint(equalTo: visibleContainerView.topAnchor, constant: 12).isActive = true
		counterName.centerXAnchor.constraint(equalTo: visibleContainerView.centerXAnchor).isActive = true
		
		visibleContainerView.addSubview(currentRows)
		currentRows.translatesAutoresizingMaskIntoConstraints = false
		currentRows.centerXAnchor.constraint(equalTo: visibleContainerView.centerXAnchor).isActive = true
		currentRows.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor).isActive = true
		
		visibleContainerView.addSubview(plusButton)
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		plusButton.trailingAnchor.constraint(equalTo: visibleContainerView.trailingAnchor, constant: -50).isActive = true
		plusButton.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor).isActive = true
		
		visibleContainerView.addSubview(minusButton)
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.leadingAnchor.constraint(equalTo: visibleContainerView.leadingAnchor, constant: 50).isActive = true
		minusButton.centerYAnchor.constraint(equalTo: visibleContainerView.centerYAnchor).isActive = true
		
		deleteContainerView.addSubview(deleteImageView)
		deleteImageView.translatesAutoresizingMaskIntoConstraints 													= false
		deleteImageView.centerXAnchor.constraint(equalTo: deleteContainerView.centerXAnchor).isActive 				= true
		deleteImageView.centerYAnchor.constraint(equalTo: deleteContainerView.centerYAnchor).isActive 				= true
		deleteImageView.widthAnchor.constraint(equalToConstant: 25).isActive 										= true
		deleteImageView.heightAnchor.constraint(equalToConstant: 30).isActive 										= true
	}
}
