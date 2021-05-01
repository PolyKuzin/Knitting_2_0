//
//  SelectImageCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 20.02.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _SelectImageCell {
	var items          : [Item]      { get set }
	var currentImage   : Int         { get set }
	var showPayWall    : (()->())    { get set }
	var selectImage    : ((Int)->()) { get set }
}

class SelectImageCell: UITableViewCell {
	
	static let reuseID = "SelectImageCell"
	
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
		self.collectionView.register(UINib(nibName: ImageCollectionViewCell.reuseId, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
    }
	
	public func configure(with data: Any) {
		if let data = data as? PanNewProject.ViewState.SelectImages {
			self.items = data.items
			self.selectImage = data.selectImage
			self.showPayWall = data.showPayWall
		}
	}
}

extension SelectImageCell : UICollectionViewDelegate {
	
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

extension SelectImageCell : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as! ImageCollectionViewCell
		cell.configure(with: items[indexPath.row])
		return cell
	}
}
