  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation
import UIKit
import Kingfisher

class EventCell: UITableViewCell {
    
    var viewModel: EventCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                avatarImageView.image = nil
                titleLabel.text = nil
                descriptionLabel.text = nil
                comicsLabel.text = nil
                charactersLabel.text = nil
                return
            }
            var imageUrl = viewModel.avatarImageUrl?.replacingOccurrences(of: "http", with: "https")
            if imageUrl != nil { imageUrl! += "/portrait_small.jpg"}
            if let avatarImageUrl = imageUrl, let avatarUrl = URL(string: avatarImageUrl) {
                let processor = RoundCornerImageProcessor(cornerRadius: 25)
                avatarImageView?.kf.setImage(with: avatarUrl, placeholder: UIImage(systemName: "person"), options: [.processor(processor)])
            }
            
            titleLabel.text = viewModel.title
            
            var descriptionText: String = viewModel.description
            if descriptionText.count > 250 {
                descriptionText = String(descriptionText.prefix(250))
                descriptionText += "..."
            }
            descriptionLabel.text = descriptionText
        
            comicsLabel.text = "\(viewModel.comicsCount) Comics"
            let characterText: String = viewModel.characters.reduce(into: "", { characterString, character in
                guard let name = character.name else {
                    return
                }
                characterString += " " + name + ","
//                TODO: Characters embedded in events DO NOT HAVE IDs!
//                guard let characterId = character.id, let name = character.name else {
//                    return
//                }
//                if viewModel.favoriteList.hasCharacter(with: characterId) {
//                    characterString += "*" + name + "*,"
//                } else {
//                    characterString += "*" + name + "*,"
//                }
            })
            charactersLabel.text = characterText.trimmingCharacters(in: [","])
        }
    }
    
    var avatarImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var comicsLabel: UILabel!
    var charactersLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImageView = UIImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        comicsLabel = UILabel()
        charactersLabel = UILabel()
        
        titleLabel.text = "Title"
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
        descriptionLabel.numberOfLines = 0
        comicsLabel.text = "Stories"
        comicsLabel.font = .preferredFont(forTextStyle: .caption2)
        charactersLabel.numberOfLines = 0
        charactersLabel.font = .preferredFont(forTextStyle: .footnote)
        
        let centerStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, comicsLabel, charactersLabel])
        centerStackView.spacing = 2
        centerStackView.axis = .vertical
        centerStackView.spacing = 3.0
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        centerStackView.contentCompressionResistancePriority(for: .vertical)
        centerStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        centerStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(centerStackView)
        
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
        centerStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5.0).isActive = true
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
        comicsLabel.text = nil
        charactersLabel.text = nil
    }
}
