//
//  BaseVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import MessageUI
import SafariServices

let animationDuration = 0.7

struct MailMessage {
	let to    : String
	let title : String
	let body  : String
}

class BaseVC : UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .background
    }
	
	public func showPayWall() {
		let vc = PayWallVC(nibName: "PayWallVC", bundle: nil)
		let panVc : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(panVc)
	}
	
	public func openMailController(_ message: MailMessage) {
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setToRecipients([message.to])
			mail.setSubject(message.title)
			mail.setMessageBody(message.body, isHTML: false)
			present(mail, animated: true)
		} else if let emailUrl = createEmailUrl(to: message.to, subject: message.title, body: message.body) {
			UIApplication.shared.open(emailUrl)
		}
	}
		
	private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
		let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
		let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

		let gmailUrl   = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
		let yahooMail  = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let sparkUrl   = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

		if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
			return gmailUrl
		} else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
			return outlookUrl
		} else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
			return yahooMail
		} else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
			return sparkUrl
		}
		return defaultUrl
	}
	
	public func openWeb(link: String) {
		if let sc = BaseVC.safariController(link) { present(sc, animated: true, completion: nil) }
	}
		
	class func safariController(_ link: String) -> SFSafariViewController? {
		guard let url = URL(string: link) else { return nil }
		let safariVC = SFSafariViewController(url: url)
		safariVC.preferredBarTintColor = .white
		safariVC.preferredControlTintColor = .white
		return safariVC
	}
	
	func setupNormalNavBar() {
		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.view.backgroundColor			= .white
		navigationController.navigationBar.isTranslucent	= false
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		
		self.navigationItem.setHidesBackButton(true, animated: true)
	}
}

// MARK: - UI Elements
extension BaseVC {
	
	// TODO: Убрать её нахуй отсюда
	public func getImage(_ str: String) -> Int {
		switch str {
		case "_1":
			return 1
		case "_2":
			return 2
		case "_3":
			return 3
		case "_4":
			return 4
		case "_5":
			return 5
		case "_6":
			return 6
		default:
			return 0
		}
	}
}
