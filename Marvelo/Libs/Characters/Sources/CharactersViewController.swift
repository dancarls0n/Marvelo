//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-15.
//

import UIKit

import DataStore

extension CharactersViewController {
    public struct Dependencies {
        public var dataStore: DataStoreProtocol

        public init(dataStore: DataStoreProtocol) {
            self.dataStore = dataStore
        }
    }
}

public class CharactersViewController: UIViewController {

    private var dependencies: Dependencies
	var tableView: UITableView!
	lazy var viewModel = {
        CharactersViewModel(dataStore: dependencies.dataStore)
	}()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView = UITableView(frame: self.view.bounds)
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.addSubview(tableView)
		initView()
		initViewModel()
	}
	
	func initView() {		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .white
		tableView.separatorColor = .gray
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .singleLine
		tableView.tableFooterView = UIView()
		tableView.allowsSelection = false
		
		tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
	}
	
	func initViewModel() {
		viewModel.getCharactersFromDataStore()
		viewModel.reloadTableView = {
			[weak self] in
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableViewDelegate

extension CharactersViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: - UITableViewDataSource

extension CharactersViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.characters.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { fatalError("xib does not exists") }
		let cellVM = viewModel.getCellViewModel(at: indexPath)
		cell.viewModel = cellVM
		return cell
	}
}
