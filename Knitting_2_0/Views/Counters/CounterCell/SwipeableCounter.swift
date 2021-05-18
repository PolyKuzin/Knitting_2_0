//
//  SwipeableCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

import UIKit

protocol _SwipeableCounter {
	var counter          : Counter         { get set }
	var onPlusRow        : ((Counter)->()) { get set }
	var onMinusRow       : ((Counter)->()) { get set }
	var onVisibleCounter : ((Counter)->()) { get set }
	var onEditCounter    : ((Counter)->()) { get set }
	var onDeleteCounter  : ((Counter)->()) { get set }
	var onDoubleCounter  : ((Counter)->()) { get set }
}

class SwipeableCounter   : UICollectionViewCell {
	
	let scrollView  : UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.isPagingEnabled = true
		scrollView.layer.cornerRadius = 20
		scrollView.alwaysBounceVertical = false
		scrollView.alwaysBounceHorizontal = false
		scrollView.isUserInteractionEnabled = true
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	private var counter     : Counter?
	private var counterView = CounterCellView.loadFromNib()
	private var deleteView  = LabelView.loadFromNib()
	private var editView    = LabelView.loadFromNib()
	private var dubleView   = LabelView.loadFromNib()
	
	private var onVisibleCounter : ((Counter)->())?
	private var onDeleteCounter  : ((Counter)->())?
	private var onEditCounter    : ((Counter)->())?
	private var onDoubleCounter  : ((Counter)->())?
	
	public func configure(with data: _SwipeableCounter) {
		self.counter          = data.counter
		self.onVisibleCounter = data.onVisibleCounter
		self.onDeleteCounter  = data.onDeleteCounter
		self.onEditCounter    = data.onEditCounter
		self.onDoubleCounter  = data.onDoubleCounter
		self.counterView.configure(with: data.counter)
	}
		
	override func awakeFromNib() {
		setupSubviews()
		setupGestureRecognizer()
		layer.cornerRadius  = 20
		layer.borderWidth   = 0.0
		layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
		layer.shadowOffset  = CGSize(width: 0, height: 8)
		layer.shadowRadius  = 10
		layer.shadowOpacity = 1
		layer.masksToBounds = false
	}
	
	private func setupSubviews() {
		let stackView			= UIStackView()
		stackView.axis			= .horizontal
		stackView.distribution 	= .fill
		stackView.addArrangedSubview(counterView)
		stackView.addArrangedSubview(deleteView)
		deleteView.configure(with: "Delete".localized())
		deleteView.backgroundColor = UIColor.third
		stackView.addArrangedSubview(editView)
		editView.configure(with: "Edit".localized())
		editView.backgroundColor = UIColor.secondary
		stackView.addArrangedSubview(dubleView)
		dubleView.configure(with: "Duplicate".localized())
		dubleView.backgroundColor = UIColor.mainColor
		stackView.isUserInteractionEnabled = true

		dubleView.roundCorners([.topRight, .bottomRight], radius: 20)

		addSubview(scrollView)
		scrollView.addSubview(stackView)
		scrollView.translatesAutoresizingMaskIntoConstraints  = false
		stackView.translatesAutoresizingMaskIntoConstraints  = false
		NSLayoutConstraint.activate([
			scrollView.topAnchor    .constraint(equalTo: self.topAnchor),
			scrollView.leftAnchor   .constraint(equalTo: self.leftAnchor),
			scrollView.bottomAnchor .constraint(equalTo: self.bottomAnchor),
			scrollView.rightAnchor  .constraint(equalTo: self.rightAnchor),
			
			stackView.widthAnchor  .constraint(equalTo: scrollView.widthAnchor,  multiplier: 1.75),
			stackView.heightAnchor .constraint(equalTo: scrollView.heightAnchor),
			stackView.topAnchor    .constraint(equalTo: scrollView.topAnchor),
			stackView.leftAnchor   .constraint(equalTo: scrollView.leftAnchor),
			stackView.bottomAnchor .constraint(equalTo: scrollView.bottomAnchor),
			stackView.rightAnchor  .constraint(equalTo: scrollView.rightAnchor)
		])
		
		counterView .translatesAutoresizingMaskIntoConstraints = false
		editView    .translatesAutoresizingMaskIntoConstraints = false
		deleteView  .translatesAutoresizingMaskIntoConstraints = false
		dubleView   .translatesAutoresizingMaskIntoConstraints = false
		
		counterView .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		editView    .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		deleteView  .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		dubleView   .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		
		counterView .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)   .isActive = true
		editView    .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
		deleteView  .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
		dubleView   .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
	}
	
	private func setupGestureRecognizer() {
		let visibleContainerTapGestureRecognizer   = UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
		counterView.addGestureRecognizer (visibleContainerTapGestureRecognizer)
		
		let deleteContainerTapGestureRecognizer    = UITapGestureRecognizer(target: self, action: #selector(deleteContainerViewTapped))
		deleteView.addGestureRecognizer  (deleteContainerTapGestureRecognizer)
		
		let editContainerTapGestureRecognizer      = UITapGestureRecognizer(target: self, action: #selector(editContainerViewTapped))
		editView.addGestureRecognizer    (editContainerTapGestureRecognizer)
		
		let duplicateContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(duplicateContainerViewTapped))
		dubleView.addGestureRecognizer   (duplicateContainerTapGestureRecognizer)
	}
	
	@objc
	private func visibleContainerViewTapped() {
		defer { self.scrollToInit() }
		guard let counter = self.counter else { return }
		self.onVisibleCounter?(counter)
	}
	
	@objc
	private func deleteContainerViewTapped() {
		defer { self.scrollToInit() }
		guard let counter = self.counter else { return }
		self.onDeleteCounter?(counter)
	}
	
	@objc
	private func editContainerViewTapped() {
		defer { self.scrollToInit() }
		guard let counter = self.counter else { return }
		self.onEditCounter?(counter)
	}
	
	@objc
	private func duplicateContainerViewTapped() {
		defer { self.scrollToInit() }
		guard let counter = self.counter else { return }
		self.onDoubleCounter?(counter)
	}
	
	private func scrollToInit() {
		self.isSelected = false
		let leftOffset = CGPoint(x: 0, y: 0)
		scrollView.setContentOffset(leftOffset, animated: false)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if scrollView.contentOffset.x > 0 {
			scrollView.contentOffset.x = scrollView.frame.width / 4
		}
	}
}
