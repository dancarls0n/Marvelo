//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-15.
//

import UIKit

class CharactersViewController: UIViewController {
	var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initView()
		initViewModel()
	}
	
	func initView() {
		// TableView customization
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1))
		tableView.separatorColor = .white
		tableView.separatorStyle = .singleLine
		tableView.tableFooterView = UIView()
		tableView.allowsSelection = false
		
		tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
	}
	
	func initViewModel() {
		/* Add code later */
	}
}

// MARK: - UITableViewDelegate

extension CharactersViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 130
	}
}

// MARK: - UITableViewDataSource

extension CharactersViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { fatalError("cell does not exists") }
		return cell
	}
}
