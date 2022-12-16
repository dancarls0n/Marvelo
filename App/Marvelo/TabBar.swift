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
import NotificationClientLive

@MainActor
class TabBar : UITabBarController {
		
  private var newCharacterStream: Task<Void, Never>?
  private var notificationEventStream: Task<Void, Never>?
  
	override func viewDidLoad() {
		self.setupVCs()
    
    newCharacterStream = Task {
      for await newCharacter in LiveDependencies.shared.notificationClient.newCharacterStream() {
          print("new Character: \(newCharacter)")
      }
    }
    notificationEventStream = Task {
      for await event in LiveDependencies.shared.notificationClient.notificationStream() {
        print("notification event: \(event.description)")
      }
    }
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
            prepTabNavController(
                for: Characters.CharactersViewController(
                    dependencies: CharactersViewController.Dependencies(
                        dataStore: LiveDependencies.shared.dataStore
                    )
                ),
                title: "Characters", image: UIImage(systemName: "person.2.crop.square.stack.fill")!
            ),
			prepTabNavController(for: EventsViewController(), title: "Events", image: UIImage(systemName: "figure.run.square.stack.fill")!),
			prepTabNavController(for: FavoritesViewController(), title: "Favorites", image: UIImage(systemName: "star.square.on.square.fill")!)
		]
	}
	
}
