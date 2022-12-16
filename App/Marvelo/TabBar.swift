//
//  TabViewController.swift
//  Marvelo
//
//  Created by Dan Carlson on 2022-12-16.
//

import UIKit

import Characters
import Events
import Favorites
import Notifications

class TabBar : UITabBarController {
		
	override func viewDidLoad() {
		self.setupVCs()
	}
	
	fileprivate func prepTabNavController(for rootViewController: UIViewController,
																				title: String,
																				image: UIImage) -> UIViewController {
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		navController.navigationBar.prefersLargeTitles = true
		rootViewController.navigationItem.title = title
		return navController
	}
	
	func setupVCs() {
		viewControllers = [
			prepTabNavController(for: CharactersViewController(), title: "Characters", image: UIImage(systemName: "person.2.crop.square.stack.fill")!),
			prepTabNavController(for: EventsViewController(), title: "Events", image: UIImage(systemName: "figure.run.square.stack.fill")!),
			prepTabNavController(for: FavoritesViewController(), title: "Favorites", image: UIImage(systemName: "star.square.on.square.fill")!)
		]
	}
	
}
