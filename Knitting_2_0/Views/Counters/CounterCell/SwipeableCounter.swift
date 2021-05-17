//
//  SwipeableCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _SwipeableCounter {
	var counter          : Counter?          { get set }
	var onVisibleCounter : ((Counter?)->())? { get set }
	var onEditCounter    : ((Counter?)->())? { get set }
	var onDeleteCounter  : ((Counter?)->())? { get set }
	var onDoubleCounter  : ((Counter?)->())? { get set }
}

class SwipeableCounter   : UIView {
	
	let scrollView  : UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.isPagingEnabled = true
		scrollView.layer.cornerRadius = 20
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	private var counter     : Counter?
	private var counterView = CounterView.loadFromNib()
	private var deleteView  = LabelView.loadFromNib()
	private var editView    = LabelView.loadFromNib()
	private var dubleView   = LabelView.loadFromNib()
	
	private var onVisibleCounter : ((Counter?)->())?
	private var onEditCounter    : ((Counter?)->())?
	private var onDeleteCounter  : ((Counter?)->())?
	private var onDoubleCounter  : ((Counter?)->())?
	
	override func awakeFromNib() {
		setupSubviews			()
		setupGestureRecognizer	()
	}
	
	public func configure(with data: _SwipeableCounter) {
		self.onVisibleCounter = data.onVisibleCounter
		self.onDeleteCounter  = data.onDeleteCounter
		self.onEditCounter    = data.onEditCounter
		self.onDoubleCounter  = data.onDoubleCounter
	}
	
	private func setupSubviews() {
		let stackView			= UIStackView()
		stackView.axis			= .horizontal
		stackView.distribution 	= .fill
		stackView.addArrangedSubview(counterView)

		stackView.addArrangedSubview(deleteView)
		deleteView.configure(with: "Delete".localized())
		stackView.addArrangedSubview(editView)
		editView.configure(with: "Edit".localized())
		stackView.addArrangedSubview(dubleView)
		dubleView.configure(with: "Duplicate".localized())
		stackView.isUserInteractionEnabled = true

		addSubview(scrollView)
		
		counterView .widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1)   .isActive = true
		editView    .widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
		deleteView  .widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive	= true
		dubleView   .widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive	= true
	}
	
	private func setupGestureRecognizer() {
		let editContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(editContainerViewTapped))
		editView.addGestureRecognizer	(editContainerTapGestureRecognizer)
		
		let deleteContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(deleteContainerViewTapped))
		deleteView.addGestureRecognizer	(deleteContainerTapGestureRecognizer)
		
		let visibleContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
		counterView.addGestureRecognizer	(visibleContainerTapGestureRecognizer)
		
		let duplicateContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(duplicateContainerViewTapped))
		dubleView.addGestureRecognizer	(duplicateContainerTapGestureRecognizer)
	}
	
	@objc
	private func editContainerViewTapped() {
		self.onEditCounter?(counter)
	}
	
	@objc
	private func deleteContainerViewTapped() {
		self.onDeleteCounter?(counter)
	}
	
	@objc
	private func visibleContainerViewTapped() {
		self.onVisibleCounter?(counter)
	}
	
	@objc
	private func duplicateContainerViewTapped() {
		self.onDoubleCounter?(counter)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if scrollView.contentOffset.x > 0 {
			scrollView.contentOffset.x = scrollView.frame.width / 4
		}
	}
}
