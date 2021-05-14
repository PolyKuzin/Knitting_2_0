//
//  LoadingCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _Loading {
	var title : String { get set }
}

class LoadingCell : UICollectionViewCell {
	
	@IBOutlet weak var title    : UILabel!
	@IBOutlet weak var activity : UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.activity.startAnimating()
		self.activity.hidesWhenStopped = true
	}

	public func configure(with data: _Loading) {
		self.title.text = data.title
	}
}
