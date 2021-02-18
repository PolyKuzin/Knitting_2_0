//
//  NavigationController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class NavigationController: UINavigationController, PanModalPresentable {
	
	var cornerRadius: CGFloat {
		return 16
	}
	
	var shouldRoundTopCorners: Bool {
		return true
	}
	
//	var shortFormHeight: PanModalHeight {
//		return .contentHeight(200) // TODO:(350)
//	}

	var longFormHeight: PanModalHeight {
		return .maxHeight // shortFormHeight // .maxHeightWithTopInset(70)
	}
	
	var panScrollable: UIScrollView? {
		return (topViewController as? PanModalPresentable)?.panScrollable
	}

	override init(rootViewController: UIViewController) {
		super.init(nibName: nil, bundle: nil)
		viewControllers = [rootViewController]
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	open override var preferredStatusBarStyle: UIStatusBarStyle {
	   return topViewController?.preferredStatusBarStyle ?? .default
	}

	override func popViewController(animated: Bool) -> UIViewController? {
		let vc = super.popViewController(animated: animated)
		panModalSetNeedsLayoutUpdate()
		return vc
	}

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		panModalSetNeedsLayoutUpdate()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationBar.isTranslucent          = false
		self.navigationBar.prefersLargeTitles     = true
		self.navigationItem.largeTitleDisplayMode = .automatic
		self.view.backgroundColor       = .white
		self.navigationBar.barTintColor = UIColor(named: "MainLabel")
		self.navigationBar.tintColor    = UIColor(named: "MainLabel")
		setTitleApearence()
	}
	
	public func setTransparent() {
		if #available(iOS 13.0, *) {
			self.navigationBar.standardAppearance.backgroundColor = .clear
			self.navigationBar.compactAppearance?   .configureWithTransparentBackground()
			self.navigationBar.standardAppearance   .configureWithTransparentBackground()
			self.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
		} else {
			// Fallback on earlier versions
		}
	}
	
	private func setTitleApearence() {
		let largeTitle   = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 30), NSAttributedString.Key.foregroundColor: UIColor.black]
		let defaultTitle = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 16),    NSAttributedString.Key.foregroundColor: UIColor.black]
		
		if #available(iOS 13.0, *) {
			let appereance = UINavigationBarAppearance()
			appereance.backgroundColor              = .white
			appereance.shadowColor                  = .clear
			appereance.largeTitleTextAttributes     = largeTitle as [NSAttributedString.Key : Any]
			appereance.titleTextAttributes          = defaultTitle as [NSAttributedString.Key : Any]
			self.navigationBar.standardAppearance   = appereance
			self.navigationBar.compactAppearance    = appereance
			self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
			appereance.setBackIndicatorImage(#imageLiteral(resourceName: "arrow"), transitionMaskImage: #imageLiteral(resourceName: "arrow"))
		} else {
			self.navigationBar.titleTextAttributes      = defaultTitle as [NSAttributedString.Key : Any]
			self.navigationBar.largeTitleTextAttributes = largeTitle as [NSAttributedString.Key : Any]
		}
	}
}
