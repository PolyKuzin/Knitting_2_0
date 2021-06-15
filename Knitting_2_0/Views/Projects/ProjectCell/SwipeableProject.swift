//
//  Swipe.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 16.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import AppstoreTransition

protocol _SwipeableProject {
	var project          : Project                  { get set }
	var onVisibleProject : ((SwipeableProject)->()) { get set }
	var onEditProject    : ((SwipeableProject)->()) { get set }
	var onDeleteProject  : ((SwipeableProject)->()) { get set }
	var onDoubleProject  : ((SwipeableProject)->()) { get set }
}

extension SwipeableProject : CardCollectionViewCell {
	
	var cardContentView: UIView {
		get {
			guard let view = self.projectView else { return UIView() }
			return view
		}
	}
}

class SwipeableProject   : UICollectionViewCell {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		animate(isHighlighted: true)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		animate(isHighlighted: false)
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		animate(isHighlighted: false)
	}
	
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
	
	public var project     : Project?
	public var projectView  : ProjectCellView? = ProjectCellView.loadFromNib()
	private var deleteView  = LabelView.loadFromNib()
	private var editView    = LabelView.loadFromNib()
	private var dubleView   = LabelView.loadFromNib()
	
	private var onVisibleProject : ((SwipeableProject)->())?
	private var onDeleteProject  : ((SwipeableProject)->())?
	private var onEditProject    : ((SwipeableProject)->())?
	private var onDoubleProject  : ((SwipeableProject)->())?
	
	public func configure(with data: _SwipeableProject) {
		self.project          = data.project
		self.onVisibleProject = data.onVisibleProject
		self.onDeleteProject  = data.onDeleteProject
		self.onEditProject    = data.onEditProject
		self.onDoubleProject  = data.onDoubleProject
		self.projectView?.configure(with: data.project)
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
		stackView.addArrangedSubview(projectView!)
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
		
		projectView? .translatesAutoresizingMaskIntoConstraints = false
		editView    .translatesAutoresizingMaskIntoConstraints = false
		deleteView  .translatesAutoresizingMaskIntoConstraints = false
		dubleView   .translatesAutoresizingMaskIntoConstraints = false
		
		projectView?.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		editView    .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		deleteView  .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		dubleView   .heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
		
		projectView?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)   .isActive = true
		editView    .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
		deleteView  .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
		dubleView   .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
	}
	
	private func setupGestureRecognizer() {
		let visibleContainerTapGestureRecognizer   = UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
		projectView?.addGestureRecognizer (visibleContainerTapGestureRecognizer)
		
		let deleteContainerTapGestureRecognizer    = UITapGestureRecognizer(target: self, action: #selector(deleteContainerViewTapped))
		deleteView.addGestureRecognizer  (deleteContainerTapGestureRecognizer)
		
		let editContainerTapGestureRecognizer      = UITapGestureRecognizer(target: self, action: #selector(editContainerViewTapped))
		editView.addGestureRecognizer    (editContainerTapGestureRecognizer)
		
		let duplicateContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(duplicateContainerViewTapped))
		dubleView.addGestureRecognizer   (duplicateContainerTapGestureRecognizer)
	}
	
	@objc
	private func editContainerViewTapped() {
		defer { self.scrollToInit() }
		self.onEditProject?(self)
	}
	
	@objc
	private func deleteContainerViewTapped() {
		defer { self.scrollToInit() }
		self.onDeleteProject?(self)
	}
	
	@objc
	private func visibleContainerViewTapped() {
		defer { self.scrollToInit() }
		self.onVisibleProject?(self)
	}
	
	@objc
	private func duplicateContainerViewTapped() {
		defer { self.scrollToInit() }
		self.onDoubleProject?(self)
	}
	
	private func scrollToInit() {
		self.isSelected = false
		let leftOffset = CGPoint(x: 0, y: 0)
		scrollView.setContentOffset(leftOffset, animated: true)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if scrollView.contentOffset.x > 0 {
			scrollView.contentOffset.x = scrollView.frame.width / 4
		}
	}
}
