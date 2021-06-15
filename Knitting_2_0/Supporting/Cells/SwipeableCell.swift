////
////  SwipeableCell.swift
////  Knitting_2_0
////
////  Created by Павел Кузин on 13.09.2020.
////  Copyright © 2020 Павел Кузин. All rights reserved.
////
//
//import UIKit
//
//class SwipeableCollectionViewCell : UICollectionViewCell {
//
//	let visibleContainerView	= UIView()
//	let deleteContainerView		= UIView()
//	let editContainerView		= UIView()
//	let duplicateContainerView	= UIView()
//
//    let scrollView							: UIScrollView = {
//        let scrollView								= UIScrollView(frame: .zero)
//        scrollView.isPagingEnabled					= true
//        scrollView.showsVerticalScrollIndicator 	= false
//        scrollView.showsHorizontalScrollIndicator	= false
//        scrollView.layer.cornerRadius				= 20
//        return scrollView
//    }()
//
//	let deleteLabel : UILabel = {
//		let label = UILabel()
//		label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//		label.font = UIFont.medium_18
//		label.text = "Delete".localized()
//		return label
//	}()
//
//	let editLabel : UILabel = {
//		let label = UILabel()
//		label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//		label.font = UIFont.medium_18
//		label.text = "Edit".localized()
//		return label
//	}()
//
//	let duplicateLabel : UILabel = {
//		let label = UILabel()
//		label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//		label.font = UIFont.medium_18
//		label.text = "Duplicate".localized()
//		return label
//	}()
//
//    weak var delegate: SwipeableCollectionViewCellDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupSubviews			()
//        setupGestureRecognizer	()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupSubviews() {
//        let stackView			= UIStackView()
//        stackView.axis			= .horizontal
//        stackView.distribution 	= .fill
//        stackView.addArrangedSubview(visibleContainerView)
//        stackView.addArrangedSubview(deleteContainerView)
//		stackView.addArrangedSubview(editContainerView)
//		stackView.addArrangedSubview(duplicateContainerView)
//
//		stackView.isUserInteractionEnabled = true
//		visibleContainerView.isUserInteractionEnabled = true
//		deleteContainerView.isUserInteractionEnabled = true
//		editContainerView.isUserInteractionEnabled = true
//		duplicateContainerView.isUserInteractionEnabled = true
//
//        addSubview(scrollView)
//        scrollView.pinEdgesToSuperView()
//        scrollView.addSubview(stackView)
//        stackView.pinEdgesToSuperView()
//
//		stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)								.isActive				= true
//		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.75)				.isActive	= true
//
//		visibleContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1)		.isActive				= true
//		editContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25)		.isActive					= true
//		deleteContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25)	.isActive				= true
//		duplicateContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive				= true
//
//
//		deleteContainerView.addSubview(deleteLabel)
//		deleteLabel.translatesAutoresizingMaskIntoConstraints = false
//		deleteLabel.centerYAnchor.constraint(equalTo: deleteContainerView.centerYAnchor).isActive = true
//		deleteLabel.centerXAnchor.constraint(equalTo: deleteContainerView.centerXAnchor).isActive = true
//
//		editContainerView.addSubview(editLabel)
//		editLabel.translatesAutoresizingMaskIntoConstraints = false
//		editLabel.centerYAnchor.constraint(equalTo: editContainerView.centerYAnchor).isActive = true
//		editLabel.centerXAnchor.constraint(equalTo: editContainerView.centerXAnchor).isActive = true
//
//		duplicateContainerView.addSubview(duplicateLabel)
//		duplicateLabel.translatesAutoresizingMaskIntoConstraints = false
//		duplicateLabel.centerYAnchor.constraint(equalTo: duplicateContainerView.centerYAnchor).isActive = true
//		duplicateLabel.centerXAnchor.constraint(equalTo: duplicateContainerView.centerXAnchor).isActive = true
//    }
//
//    private func setupGestureRecognizer() {
//		let editContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(editContainerViewTapped))
//		editContainerView.addGestureRecognizer	(editContainerTapGestureRecognizer)
//
//        let deleteContainerTapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(deleteContainerViewTapped))
//        deleteContainerView.addGestureRecognizer	(deleteContainerTapGestureRecognizer)
//
//        let visibleContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
//        visibleContainerView.addGestureRecognizer	(visibleContainerTapGestureRecognizer)
//
//		let duplicateContainerTapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(duplicateContainerViewTapped))
//		duplicateContainerView.addGestureRecognizer	(duplicateContainerTapGestureRecognizer)
//    }
//
//	@objc
//	private func editContainerViewTapped() {
//		delegate?.editContainerViewTapped(inCell: self)
//	}
//
//	@objc
//	private func deleteContainerViewTapped() {
//		delegate?.deleteContainerViewTapped(inCell: self)
//	}
//
//    @objc
//	private func visibleContainerViewTapped() {
//        delegate?.visibleContainerViewTapped(inCell: self)
//    }
//
//	@objc
//	private func duplicateContainerViewTapped() {
//		delegate?.duplicateContainerViewTapped(inCell: self)
//	}
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if scrollView.contentOffset.x > 0 {
//            scrollView.contentOffset.x = scrollView.frame.width / 4
//        }
//    }
//}
//
