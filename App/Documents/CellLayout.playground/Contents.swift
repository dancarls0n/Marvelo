//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class TableHost : UIViewController, UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell: CharacterCell = self.tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier) as? CharacterCell else {
			return CharacterCell(style: .default, reuseIdentifier: CharacterCell.identifier)
		}

		return cell

	}
	var tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 400)))
	
	override func loadView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
		
		let view = UIView()
		view.addSubview(tableView)
		self.view = view
	}
}


class CharacterCell: UITableViewCell {
	
	var avatarImageView: UIImageView!
	var titleLabel: UILabel!
	var descriptionLabel: UILabel!
	var storiesLabel: UILabel!
	var dateLabel: UILabel!
	var starImageView: UIImageView!
	
	class var identifier: String { return String(describing: self) }
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
		titleLabel = UILabel()
		descriptionLabel = UILabel()
		storiesLabel = UILabel()
		dateLabel = UILabel()
		starImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
		starImageView.heightAnchor.constraint(equalToConstant: 15)
		starImageView.widthAnchor.constraint(equalToConstant: 15)
		
		titleLabel.text = "Title"
		descriptionLabel.text = "Description"
		storiesLabel.text = "Stories"
		avatarImageView.image = UIImage(systemName: "person")
		starImageView.image = UIImage(systemName: "star")
		dateLabel.text = "Date"

		let centerStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, storiesLabel])
		centerStackView.spacing = 2
		centerStackView.axis = .vertical
		centerStackView.spacing = 3.0
		centerStackView.translatesAutoresizingMaskIntoConstraints = false
		centerStackView.contentCompressionResistancePriority(for: .vertical)
		centerStackView.setContentCompressionResistancePriority(.required, for: .vertical)
		let rightStackView = UIStackView(arrangedSubviews: [starImageView, dateLabel])
		rightStackView.axis = .vertical
		rightStackView.spacing = 3.0
		rightStackView.translatesAutoresizingMaskIntoConstraints = false
		rightStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
		contentView.addSubview(avatarImageView)
		contentView.addSubview(centerStackView)
		contentView.addSubview(rightStackView)
			
		let margins = contentView
		avatarImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5.0).isActive = true
		centerStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5.0).isActive = true
		centerStackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
		centerStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
		rightStackView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
		rightStackView.leadingAnchor.constraint(equalTo: centerStackView.trailingAnchor, constant: 5.0).isActive = true
		rightStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
		rightStackView.topAnchor.constraint(equalTo: centerStackView.topAnchor).isActive = true
		rightStackView.bottomAnchor.constraint(equalTo: centerStackView.bottomAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func initView() {
		// Cell view customization
		backgroundColor = .clear
		
		// Line separator full width
		preservesSuperviewLayoutMargins = false
		separatorInset = UIEdgeInsets.zero
		layoutMargins = UIEdgeInsets.zero
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		avatarImageView = nil
		titleLabel.text = nil
		descriptionLabel.text = nil
		storiesLabel.text = nil
		dateLabel.text = nil
		starImageView.image = nil
	}
}



// Present the view controller in the Live View window
PlaygroundPage.current.liveView = TableHost()
