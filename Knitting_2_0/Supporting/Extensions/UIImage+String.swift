//
//  UIImage+String.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 21.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

//MARK: String to Image
extension String {
    func toImage() -> UIImage? {
		switch self {
		case "_0", "_1", "_2", "_3", "_4", "_5", "_6":
			let str = self
			return UIImage(named: str)
		default:
			if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
				return UIImage(data: data)
			}
		}
        return nil
    }
}

//MARK: ImageToString
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
