//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-14.
//

import Foundation
import UIKit

class CharacterCell: UITableViewCell {
	
	var avatarImageView: UIImageView!
	var titleLabel: UILabel!
	var descriptionLabel: UILabel!
	var storiesLabel: UILabel!
	var dateLabel: UILabel!
	var starImageView: UIImageView!
	
	class var identifier: String { return String(describing: self) }
		
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
