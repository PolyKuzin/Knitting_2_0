//
//  FloatingPanelLayout.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 18.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import FloatingPanel

class MenuFloatingLayout: FloatingPanelLayout {
	
	var initialState: FloatingPanelState    = .half
	var position    : FloatingPanelPosition = .bottom
	
	var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
		switch UIDevice.modelName {
		case "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone SE", "iPhone 8", "iPod touch (6th generation)", "iPod touch (7th generation)":
			return [
				.full: FloatingPanelLayoutAnchor(absoluteInset: 50,     edge: .top,    referenceGuide: .safeArea ),
				.half: FloatingPanelLayoutAnchor(fractionalInset: 0.62, edge: .bottom, referenceGuide: .superview),
				.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.2, edge: .bottom, referenceGuide: .superview)
			]
		case "Simulator iPhone 5c", "Simulator iPhone 5s", "Simulator iPhone 6", "Simulator iPhone 6s", "Simulator iPhone 7", "Simulator iPhone SE", "Simulator iPhone 8", "Simulator iPod touch (6th generation)", "Simulator iPod touch (7th generation)":
			return [
				.full: FloatingPanelLayoutAnchor(absoluteInset: 50,     edge: .top,    referenceGuide: .safeArea ),
				.half: FloatingPanelLayoutAnchor(fractionalInset: 0.62, edge: .bottom, referenceGuide: .superview),
				.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.2, edge: .bottom, referenceGuide: .superview)
			]
			
		default:
			return [
				.full: FloatingPanelLayoutAnchor(absoluteInset: 40,     edge: .top,    referenceGuide: .safeArea ),
				.half: FloatingPanelLayoutAnchor(fractionalInset: 0.67, edge: .bottom, referenceGuide: .superview),
				.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .superview)
			]
		}
	}
}
