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

struct MailMessage {
	let to    : String
	let title : String
	let body  : String
}

protocol RowPresentable {
	var VC        : UIViewController & PanModalPresentable { get set }
}

struct PayWall     : RowPresentable {
	var VC         : PanModalPresentable.LayoutType = FullScreenNavigation(rootViewController: PayWallVC(nibName: "PayWallVC", bundle: nil))
}

struct Profile     : RowPresentable {
	var VC         : PanModalPresentable.LayoutType = PanelNavigation(rootViewController: PanProfileVC(nibName: "PanProfileVC",   bundle: nil))
}

struct Project     : RowPresentable {
	var VC         : PanModalPresentable.LayoutType = PanelNavigation(rootViewController: PanProject(nibName: "PanProject", bundle: nil))
}

struct Counter     : RowPresentable {
	var VC         : PanModalPresentable.LayoutType = PanelNavigation(rootViewController: PanCounter(nibName: "PanCounter", bundle: nil))
}

class BaseVC : UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
    }
	
	public func showPayWall() {
		self.presentPanModal(PayWall().VC)
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
}

// MARK: - UI Elements
extension BaseVC {
	
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
	
	public func getBackgroundColor() -> UIColor {
		return UIColor.white
	}
}
