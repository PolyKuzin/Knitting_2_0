//
//  Fonts.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

extension UIFont {
	
	// MARK: - REGULAR
	public class var regular_14  : UIFont {
		return UIFont.systemFont(ofSize: 14, weight: .regular)
	}
	
	public class var regular_17  : UIFont {
		return UIFont.systemFont(ofSize: 17, weight: .regular)
	}
	
	public class var regular_18  : UIFont {
		return UIFont.systemFont(ofSize: 18, weight: .regular)
	}
	
	// MARK: - MEDIUM
	public class var medium_17   : UIFont {
		return UIFont.systemFont(ofSize: 17, weight: .medium)
	}
	
	public class var medium_18   : UIFont {
		return UIFont.systemFont(ofSize: 18, weight: .medium)
	}
	
	public class var medium_20   : UIFont {
		return UIFont.systemFont(ofSize: 20, weight: .medium)
	}
	
	// 0
	public class var medium_22   : UIFont {
		return UIFont.systemFont(ofSize: 22, weight: .medium)
	}
	
	// MARK: - SEMIBOLD
	public class var semibold_14 : UIFont {
		return UIFont.systemFont(ofSize: 14, weight: .semibold)
	}
	
	public class var semibold_17 : UIFont {
		return UIFont.systemFont(ofSize: 17, weight: .semibold)
	}
	
	public class var semibold_18 : UIFont {
		return UIFont.systemFont(ofSize: 18, weight: .semibold)
	}
	
	public class var semibold_22 : UIFont {
		return UIFont.systemFont(ofSize: 22, weight: .semibold)
	}
	
	public class var semibold_28 : UIFont {
		return UIFont.systemFont(ofSize: 28, weight: .semibold)
	}

	// MARK: - BOLD
	public class var bold_16     : UIFont {
		return UIFont.systemFont(ofSize: 16, weight: .bold)
	}
	
	public class var bold_17     : UIFont {
		return UIFont.systemFont(ofSize: 17, weight: .bold)
	}
	
	public class var bold_28     : UIFont {
		return UIFont.systemFont(ofSize: 28, weight: .bold)
	}
	
	public class var bold_30     : UIFont {
		return UIFont.systemFont(ofSize: 30, weight: .bold)
	}
	
	// MARK: - ROUNDED
	public class var rounded     : UIFont {
		return UIFont(name: "SFProRounded-Medium", size: 72) ?? UIFont.systemFont(ofSize: 72, weight: .bold)
	}
}
