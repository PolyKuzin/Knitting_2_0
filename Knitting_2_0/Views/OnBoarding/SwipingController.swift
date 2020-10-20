//
//  SwipingController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 19.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class SwipingController : UICollectionViewController, UICollectionViewDelegateFlowLayout, PlayVideoCellProtocol {

	let pages = [
		Page(imageName: "mapScreen",	 title: "Карта",			descrription: "На карте вы увидите все актуальные мерпоприятия",			continueButton: false),
		Page(imageName: "joinScreen",	 title: "Присоединяйтесь",	descrription: "Участвуйте в интересных вам событиях других пользователей",	continueButton: false),
		Page(imageName: "createScreen",  title: "Создавайте",		descrription: "Создавайте свои мероприятия и зовите на них других игроков",	continueButton: false),
		Page(imageName: "messageScreen", title: "Общайтесь",		descrription: "Договаривайтесь о встрече, месте и времени",					continueButton: true)
	]
	
	private let skipButton : UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Пропустить", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont(name: "SFProRounded-Regular", size: 15)
		button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
		button.addTarget(self, action: #selector(handleLast), for: .touchUpInside)
		
		return button
	}()
	
	@objc
	private func handleLast() {
		let indexPath		= IndexPath(item: 3, section: 0)
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		pageControl.alpha	= 0
		skipButton.alpha	= 0
	}
	
	private lazy var pageControl : UIPageControl = {
		let pc								= UIPageControl()
		pc.currentPage						= 0
		pc.numberOfPages					= pages.count
		pc.currentPageIndicatorTintColor 	= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
		pc.pageIndicatorTintColor 			= UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
		
		return pc
	}()
	
	fileprivate func setUpBottomControls() {
		
		let bottomControlsStackView 										= UIStackView(arrangedSubviews: [pageControl, skipButton])
		bottomControlsStackView.translatesAutoresizingMaskIntoConstraints 	= false
		bottomControlsStackView.distribution 								= .fillEqually
		
		view.addSubview(bottomControlsStackView)
		
		NSLayoutConstraint.activate([
			bottomControlsStackView.bottomAnchor.constraint		(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			bottomControlsStackView.leadingAnchor.constraint	(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -75),
			bottomControlsStackView.trailingAnchor.constraint	(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			bottomControlsStackView.heightAnchor.constraint		(equalToConstant: 50)
		])
	}
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		let x = targetContentOffset.pointee.x
		pageControl.currentPage = Int(x / view.frame.width)
		if !(x / view.frame.width >= 2.5) {
			pageControl.alpha 	= 1
			skipButton.alpha 	= 1
		} else {
			pageControl.alpha 	= 0
			skipButton.alpha 	= 0
		}
	}
	
	func playVideoButtonDidSelect() {
		let viewController = RegistrationVC() // Or however you want to create it.
		self.present(viewController, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpBottomControls()
		
		collectionView.backgroundColor = .white
		collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
		collectionView.isPagingEnabled = true
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pages.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell	= collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
		let page	= pages[indexPath.item]
		cell.page	= page
		
		if indexPath.item == 3 {
			cell.continueButton.isHidden = false
		} else {
			cell.continueButton.isHidden = true
		}
		cell.continueButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)

		return cell
	}
	
	@objc
	private func goToRegistration() {
//		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as! UINavigationController
//		vc.modalPresentationStyle = .fullScreen
//		present(vc, animated: true, completion: nil)
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
		let vc: UIViewController	= storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as! UINavigationController
		vc.modalPresentationStyle	= .fullScreen
		self.present(vc, animated: true, completion: nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: view.frame.height)
	}
}
