//
//  CollectionViewCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol SelectableView {
	var view     : UIView          { get set }
	var onSelect : ((Project)->()) { get set }
}

protocol _ProjectCell : _Project {
	var views : [SelectableView] { get set }
}

class ProjectCollectionCell : SwipeableCollectionViewCell {
	
	

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
	
	public func configure(with data : _ProjectCell) {
		
	}
}
