  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation
import UIKit
import Kingfisher

class FavoriteCell: UITableViewCell {
    
    var viewModel: FavoriteCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                avatarImageView.image = nil
                nameLabel.text = nil
                return
            }
            var imageUrl = viewModel.avatarImageUrl?.replacingOccurrences(of: "http", with: "https")
            if imageUrl != nil { imageUrl! += "/portrait_small.jpg"}
            if let avatarImageUrl = imageUrl, let avatarUrl = URL(string: avatarImageUrl) {
                let processor = RoundCornerImageProcessor(cornerRadius: 25)
                avatarImageView?.kf.setImage(with: avatarUrl, placeholder: UIImage(systemName: "person"), options: [.processor(processor)])
            }
            
            nameLabel.text = viewModel.name
        }
    }
    
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImageView = UIImageView()
        nameLabel = UILabel()
        
        nameLabel.text = "Name"
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
                
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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
        nameLabel.text = nil
    }
}
