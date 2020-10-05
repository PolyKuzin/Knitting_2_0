//
//  SwipeableCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SwipeableCollectionViewCell: UICollectionViewCell {
    
	let deleteContainerView		= UIView()
    let visibleContainerView	= UIView()
	
    private let scrollView							: UIScrollView = {
        let scrollView								= UIScrollView(frame: .zero)
        scrollView.isPagingEnabled					= true
        scrollView.showsVerticalScrollIndicator 	= false
        scrollView.showsHorizontalScrollIndicator	= false
        scrollView.layer.cornerRadius = 20
		
        return scrollView
    }()
    
    weak var delegate: SwipeableCollectionViewCellDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizer()
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
        
        addSubview(scrollView)
        scrollView.pinEdgesToSuperView()
        scrollView.addSubview(stackView)
        stackView.pinEdgesToSuperView()
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive				= true
		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2).isActive	= true
    }
    
    private func setupGestureRecognizer() {
        let hiddenContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
        deleteContainerView.addGestureRecognizer	(hiddenContainerTapGestureRecognizer)
        
        let visibleContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
        visibleContainerView.addGestureRecognizer	(visibleContainerTapGestureRecognizer)
    }
    
    @objc
	private func visibleContainerViewTapped() {
        delegate?.visibleContainerViewTapped(inCell: self)
    }
    
    @objc
	private func hiddenContainerViewTapped() {
        delegate?.hiddenContainerViewTapped(inCell: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = scrollView.frame.width / 4
        }
    }
}

