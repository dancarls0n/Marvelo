  //
 //  Created by Dan Carlson on 2022-12-14.
//

import UIKit

import DataStore

extension EventsViewController {
    public struct Dependencies {
        public var dataStore: DataStore

        public init(dataStore: DataStore) {
            self.dataStore = dataStore
        }
    }
}

public class EventsViewController: UIViewController {

    private var dependencies: Dependencies
	var tableView: UITableView!
	lazy var viewModel = {
        EventsViewModel(dataStore: dependencies.dataStore)
	}()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Task { @MainActor in
            viewModel.stopMonitoringDataStore()
        }
    }
    
	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView = UITableView(frame: self.view.bounds)
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.addSubview(tableView)
		initView()
		initViewModel()
        viewModel.startMonitoringDataStore()
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
		
		tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
	}
	
	func initViewModel() {
		viewModel.reloadTableView = {
			[weak self] in
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableViewDelegate

extension EventsViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: - UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.events.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else { fatalError("xib does not exists") }
		let cellVM = viewModel.getCellViewModel(at: indexPath)
		cell.viewModel = cellVM
		return cell
	}
}
