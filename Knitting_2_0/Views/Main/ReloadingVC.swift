//
//  ReloadingVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 26.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class ReloadingVC: UIViewController {
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		self.dismiss(animated: false, completion: nil)
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(MainVC(), animated: false)
		navigationController.viewControllers.removeAll(where: { self === $0 })
		
	}
}
