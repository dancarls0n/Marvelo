  //
 //  Created by Dan Carlson on 2022-12-14.
//

import UIKit

struct CharacterCellViewModel {
	var avatarURL: URL?
	var name: String
	var description: String
	var stories: String
	var date: String
	var starImage: UIImage
	var setFavorite: () -> Void = { }
}
