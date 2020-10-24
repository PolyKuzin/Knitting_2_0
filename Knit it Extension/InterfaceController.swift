//
//  InterfaceController.swift
//  Knit it Extension
//
//  Created by Павел Кузин on 24.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!
	
	var watchSession: WCSession?
	var projects: [MProject?] = []

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		watchSession = WCSession.default
		watchSession?.delegate = self
		watchSession?.activate()
		configureTable()
	}
	
	func configureTable() {
		projects.removeAll()
		table.setNumberOfRows(projects.count, withRowType: "ProjectsRowController")
		for i in 0..<projects.count {
			let row: ProjectsRowController = table.rowController(at: i) as! ProjectsRowController
			let project : MProject = projects[i] ?? MProject(name: "", image: "", date: "")
			if project.name == "knitting-f824f" {
				
			} else {
				row.project = project
			}
		}
	}
}

extension InterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		projects.removeAll()
		
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		let newProject = MProject(name: applicationContext["name"] as! String,
								  image: "123", date: "123")
		projects.append(newProject)
		configureTable()
	}
}
