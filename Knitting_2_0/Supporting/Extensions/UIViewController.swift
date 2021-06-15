//
//  UIViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 04.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

extension UIViewController {

	func presentDetail(_ viewControllerToPresent: UIViewController) {
		let transition = CATransition()
		transition.duration = 0.25
		transition.type = CATransitionType.push
		transition.subtype = CATransitionSubtype.fromRight
		self.view.window!.layer.add(transition, forKey: kCATransition)

		present(viewControllerToPresent, animated: false)
	}

	func dismissDetail() {
		let transition = CATransition()
		transition.duration = 0.25
		transition.type = CATransitionType.push
		transition.subtype = CATransitionSubtype.fromLeft
		self.view.window!.layer.add(transition, forKey: kCATransition)

		dismiss(animated: false)
	}
}
