//
//  SelectCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 09.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {

	@IBOutlet weak var collectionView : UICollectionView!
	
	private var items : [Item] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	private var showPayWall : (()->())?
	private var selectImage : ((Int)->())?

	override func awakeFromNib() {
		super.awakeFromNib()
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.isUserInteractionEnabled = UserDefaults.standard.bool(forKey: "setPro")
		self.collectionView.register(UINib(nibName: ImageCollectionCell.reuseId, bundle: nil), forCellWithReuseIdentifier: ImageCollectionCell.reuseId)
	}
	
	public func configure(with data: _SelectCell) {
		self.items = data.items
		self.selectImage = data.selectImage
		self.showPayWall = data.showPayWall
	}
}

extension SelectCell : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let defaults = UserDefaults()
		self.items.enumerated().forEach { (_index,_) in self.items[_index].isSelected = false }
		if defaults.bool(forKey: "setPro") || indexPath.row == 0 {
			self.items[indexPath.row].isSelected = true
			self.selectImage?(indexPath.row)
		} else {
			self.showPayWall?()
			self.selectImage?(0)
		}
	}
}

extension SelectCell : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.reuseId, for: indexPath) as! ImageCollectionCell
		cell.configure(with: items[indexPath.row])
		return cell
	}
}
