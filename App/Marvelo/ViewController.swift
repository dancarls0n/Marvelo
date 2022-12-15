//
//  ViewController.swift
//  Marvelo
//
//  Created by Dan Carlson on 2022-12-13.
//

import UIKit

import Characters

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		let tabBarController = UITabBarController()
		let charactersVC = Characters.CharactersViewController()
		tabBarController.setViewControllers([charactersVC], animated: false)
		self.present(tabBarController, animated: false)
	}
}



//class ViewController: UIViewController {
//
//	var characters: [Character] = []
//	var events: [Event] = []
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		// Do any additional setup after loading the view.
//		Task {
//			await fetchResults()
//			DispatchQueue.main.async {
//				self.view.backgroundColor = .green
//			}
//		}
//		self.view.backgroundColor = .red
//	}
//
//	func fetchResults() async {
//		do {
//			let characters = try await APIClient.fetchCharacters()
//			let events = try await APIClient.fetchEvents()
//			print("\(characters.count) characters, \(events.count) events")
//		} catch {
//			print("failed")
//		}
//	}
//
//
//}
//
