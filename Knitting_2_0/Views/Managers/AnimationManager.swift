//
//  AnimationManager.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 18.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class TransitionManager : NSObject {

}

extension TransitionManager : UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
		-> TimeInterval {
	  return 0
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

	}
}
