  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation
import UIKit

import Kingfisher

class CharacterCell: UITableViewCell {
	
	var viewModel: CharacterCellViewModel? { didSet {
        guard let viewModel = viewModel else {
            avatarImageView.image = nil
            titleLabel.text = nil
            descriptionLabel.text = nil
            storiesLabel.text = nil
            dateLabel.text = nil
            starImageView.image = nil
            return
        }
        if let avatarUrl = viewModel.avatarURL {
			let processor = RoundCornerImageProcessor(cornerRadius: 25)
			avatarImageView?.kf.setImage(with: avatarUrl, placeholder: UIImage(systemName: "person"), options: [.processor(processor)])
		}
		
		titleLabel.text = viewModel.name
		var descriptionText: String = viewModel.description
        if descriptionText.count > 250 {
            descriptionText = String(descriptionText.prefix(250))
            descriptionText += "..."
        }
        descriptionLabel.text = descriptionText
    
		storiesLabel.text = viewModel.stories
		dateLabel.text = viewModel.date ?? "Date"
        starImageView.image = viewModel.starImage
		}
	}
	
	var avatarImageView: UIImageView!
	var titleLabel: UILabel!
	var descriptionLabel: UILabel!
	var storiesLabel: UILabel!
	var dateLabel: UILabel!
	var starImageView: UIImageView!
	
	class var identifier: String { return String(describing: self) }
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		avatarImageView = UIImageView()
		titleLabel = UILabel()
		descriptionLabel = UILabel()
		storiesLabel = UILabel()
		dateLabel = UILabel()
		starImageView = UIImageView()
				
		titleLabel.text = "Title"
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.numberOfLines = 0
		
		descriptionLabel.text = "Description"
		descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
		descriptionLabel.numberOfLines = 0
		storiesLabel.text = "Stories"
		storiesLabel.font = .preferredFont(forTextStyle: .caption2)
		dateLabel.text = "Date"
		dateLabel.font = .preferredFont(forTextStyle: .caption2)
		
		let centerStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, storiesLabel])
		centerStackView.spacing = 2
		centerStackView.axis = .vertical
		centerStackView.spacing = 3.0
		centerStackView.translatesAutoresizingMaskIntoConstraints = false
		centerStackView.contentCompressionResistancePriority(for: .vertical)
		centerStackView.setContentCompressionResistancePriority(.required, for: .vertical)
		centerStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		let rightStackView = UIStackView(arrangedSubviews: [starImageView, dateLabel])
		rightStackView.axis = .vertical
		rightStackView.spacing = 3.0
		rightStackView.translatesAutoresizingMaskIntoConstraints = false
		rightStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
		rightStackView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		contentView.addSubview(avatarImageView)
		contentView.addSubview(centerStackView)
		contentView.addSubview(rightStackView)
		
	
		starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
		starImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
		starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
		starImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		avatarImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
		avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		
		let margins = contentView
		avatarImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5.0).isActive = true
		avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		centerStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5.0).isActive = true
		centerStackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
		centerStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5.0).isActive = true
		rightStackView.leadingAnchor.constraint(equalTo: centerStackView.trailingAnchor, constant: -5.0).isActive = true
		rightStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5.0).isActive = true
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
        avatarImageView.image = nil
		titleLabel.text = nil
		descriptionLabel.text = nil
		storiesLabel.text = nil
		dateLabel.text = nil
		starImageView.image = nil
	}
}
