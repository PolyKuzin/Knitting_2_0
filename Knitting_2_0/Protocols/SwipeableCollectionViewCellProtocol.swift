//
//  SwipeableCollectionViewCellProtocol.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 20.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

protocol SwipeableCollectionViewCellDelegate: class {
	func editContainerViewTapped	(inCell cell: SwipeableCollectionViewCell)
	func deleteContainerViewTapped	(inCell cell: SwipeableCollectionViewCell)
    func visibleContainerViewTapped	(inCell cell: SwipeableCollectionViewCell)
}
