//
//  MainVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .purple
		navigationController?.navigationBar.backgroundColor = .white
		let image = UIImage()
		
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = image
    }
}
