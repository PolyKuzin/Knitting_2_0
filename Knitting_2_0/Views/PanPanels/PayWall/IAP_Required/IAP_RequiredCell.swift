//
//  IAP_RequiredCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol IAP_Required {
	var privacy : (()->()) { get set }
	var restore : (()->()) { get set }
	var terms   : (()->()) { get set }
}

class IAP_RequiredCell: UITableViewCell {
	
	static var reuseID = "IAP_RequiredCell"
	
	private var onPrivacy : (()->())?
	private var onRestore : (()->())?
	private var onTerms   : (()->())?

	@IBOutlet weak var privacyBtn : UIButton!
	@IBOutlet weak var restoreBtn : UIButton!
	@IBOutlet weak var termsBtn   : UIButton!
	
	@IBAction func onPrivacyTap() {
		self.onPrivacy?()
	}
	
	@IBAction func onRestoreTap() {
		self.onRestore?()
	}
	
	@IBAction func onTermsTap()   {
		self.onTerms?()
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
	public func configure(with data: IAP_Required) {
		self.onPrivacy = data.privacy
		self.onRestore = data.restore
		self.onTerms   = data.terms
	}
}
