//
//  TabViewController.swift
//  Marvelo
//
//  Created by Dan Carlson on 2022-12-16.
//

import UIKit
import SwiftUI

import Characters
import Events
import Favorites
import Models
import NotificationClientLive

@MainActor
class TabBar : UITabBarController {
    
    private var newCharacterStream: Task<Void, Never>?
    private var notificationEventStream: Task<Void, Never>?
    
    override func viewDidLoad() {
        self.setupVCs()
        
        newCharacterStream = Task {
            for await newCharacter in LiveDependencies.shared.notificationClient.newCharacterStream() {
                DispatchQueue.main.async { [weak self] in
                    self?.displayIncomingCharacter(newCharacter)
                }
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
    
    func displayIncomingCharacter(_ character: Models.Character) {
        guard let name = character.name else { return }
        let characterView = IncomingCharacterView(name: name,
                                                  imageURL: character.avatarURL,
                                                  description: character.description,
                                                  onDismiss: { self.dismiss(animated: true) })
        let swiftUIController = UIHostingController(rootView: characterView)
        swiftUIController.modalPresentationStyle = .overFullScreen
        self.present(swiftUIController, animated: true)
    }
       
    func displaySoloCharacter(_ character: Models.Character) {
        guard let name = character.name else { return }
        let soloCharacterView = SoloCharacterView(name: name,
                                                  imageURL: character.avatarURL,
                                                  onDismiss: { self.dismiss(animated: true) })
        let swiftUIController = UIHostingController(rootView: soloCharacterView)
        swiftUIController.modalPresentationStyle = .pageSheet
        self.present(swiftUIController, animated: true)
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
            prepTabNavController(for: EventsViewController(
                dependencies: EventsViewController.Dependencies(
                    dataStore: LiveDependencies.shared.dataStore
                )
            ),
                title: "Events", image: UIImage(systemName: "figure.run.square.stack.fill")!),
            prepTabNavController(for: FavoritesViewController(
                dependencies: FavoritesViewController.Dependencies(
                    dataStore: LiveDependencies.shared.dataStore
                )
            ),
                title: "Favorites", image: UIImage(systemName: "star.square.on.square.fill")!)
        ]
    }
    
}
