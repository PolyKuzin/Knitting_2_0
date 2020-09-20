//
//  CardViewAnimations.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 20.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

//MARK: CardView Animations
extension MainVC {

    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
			let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
				switch state {
				case .expanded	:
					self.setUpClearNavBar()
					self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 20
				case .collapsed	:
					self.setupNormalNavBar()
					self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
				}
			}
			frameAnimator.addCompletion { _ in
				self.cardVisible = !self.cardVisible
				self.runningAnimations.removeAll()
			}
			frameAnimator.startAnimation()
			runningAnimations.append(frameAnimator)
			
			let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
				switch state {
				case .expanded:
					self.cardViewController.view.layer.cornerRadius = 20
				case .collapsed:
					self.cardViewController.view.layer.cornerRadius = 0
				}
			}
			
			cornerRadiusAnimator.startAnimation()
			runningAnimations.append(cornerRadiusAnimator)
		
			let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
				switch state {
				case .expanded:
					self.view.insertSubview(self.visualEffectView, at: 1)
					self.visualEffectView.effect	= UIBlurEffect(style: .dark)
					self.visualEffectView.alpha		= 0.7
				case .collapsed:
					self.visualEffectView.effect	= nil
				}
			}
		
			blurAnimator.startAnimation()
			runningAnimations.append(blurAnimator)
		}
	}
	
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
			checkWhenAnimationsScholdEnd()
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
			checkWhenAnimationsScholdEnd()
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			checkWhenAnimationsScholdEnd()
        }
    }
	
	func checkWhenAnimationsScholdEnd() {
		if self.cardViewController.view.frame.origin.y == self.view.frame.height {
			self.teardownCardView()
		}
	}
}
