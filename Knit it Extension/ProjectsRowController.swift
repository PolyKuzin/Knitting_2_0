//
//  ProjectsRowController.swift
//  Knit it Extension
//
//  Created by Павел Кузин on 24.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import WatchKit

class ProjectsRowController: NSObject {
	
	@IBOutlet weak var projectImage: WKInterfaceGroup!
	@IBOutlet weak var projectName: WKInterfaceLabel!
	
	var project : MProject? {
		didSet {
			projectName.setText(project?.name)
			projectImage.setBackgroundImage(project?.image.toImage())
		}
	}
}

//MARK: String to Image
extension String {
	func toImage() -> UIImage? {
		if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
			return UIImage(data: data)
		}
		return nil
	}
}
