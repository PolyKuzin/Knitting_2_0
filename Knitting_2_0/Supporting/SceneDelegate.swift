//
//  SceneDelegate.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
		window					= UIWindow(windowScene: windowScene)
		
		let nav1				= UINavigationController()
		let entryView			= EntryVC(nibName: nil, bundle: nil)
		nav1.viewControllers	= [entryView]
		
		let nav2				= UINavigationController()
		let mainView			= MainVC(nibName: nil, bundle: nil)
		nav2.viewControllers	= [mainView]
		
		self.window!.rootViewController = nav1
		self.window?.makeKeyAndVisible()
    }
}

