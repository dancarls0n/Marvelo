//
//  ViewController.swift
//  Marvelo
//
//  Created by Dan Carlson on 2022-12-13.
//

import UIKit
import APIClient
import Models

class ViewController: UIViewController {

	var characters: [Character] = []
	var events: [Event] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		Task {
			await fetchResults()
			DispatchQueue.main.async {
				self.view.backgroundColor = .green
			}
		}
		self.view.backgroundColor = .red
	}
	
	func fetchResults() async {
		do {
			let characters = await try APIClient.fetchCharacters()
			let events = await try APIClient.fetchEvents()
			print("\(characters.count) characters, \(events.count) events")
		} catch {
			print("failed")
		}
	}


}

