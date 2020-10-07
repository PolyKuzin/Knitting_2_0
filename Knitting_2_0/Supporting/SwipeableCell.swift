//
//  SwipeableCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SwipeableCollectionViewCell: UICollectionViewCell {
    
	let editContainerView		= UIView()
	let deleteContainerView		= UIView()
    let visibleContainerView	= UIView()
	
    private let scrollView							: UIScrollView = {
        let scrollView								= UIScrollView(frame: .zero)
        scrollView.isPagingEnabled					= true
        scrollView.showsVerticalScrollIndicator 	= false
        scrollView.showsHorizontalScrollIndicator	= false
        scrollView.layer.cornerRadius				= 20
		
        return scrollView
    }()
    
    weak var delegate: SwipeableCollectionViewCellDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews			()
        setupGestureRecognizer	()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let stackView			= UIStackView()
        stackView.axis			= .horizontal
        stackView.distribution 	= .fillEqually
        stackView.addArrangedSubview(visibleContainerView)
        stackView.addArrangedSubview(deleteContainerView)
		stackView.addArrangedSubview(editContainerView)
        
        addSubview(scrollView)
        scrollView.pinEdgesToSuperView()
        scrollView.addSubview(stackView)
        stackView.pinEdgesToSuperView()
		editContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive					= true
		deleteContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive				= true
		visibleContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive				= true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive				= true
		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.5).isActive	= true
    }
    
    private func setupGestureRecognizer() {
		let editContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
		deleteContainerView.addGestureRecognizer	(editContainerTapGestureRecognizer)
		
        let deleteContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
        deleteContainerView.addGestureRecognizer	(deleteContainerTapGestureRecognizer)
        
        let visibleContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
        visibleContainerView.addGestureRecognizer	(visibleContainerTapGestureRecognizer)
    }
	
	@objc
	private func editContainerViewTapped() {
		delegate?.editContainerViewTapped(inCell: self)
	}
	
	@objc
	private func hiddenContainerViewTapped() {
		delegate?.deleteContainerViewTapped(inCell: self)
	}
    
    @objc
	private func visibleContainerViewTapped() {
        delegate?.visibleContainerViewTapped(inCell: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = scrollView.frame.width / 4
        }
    }
}

