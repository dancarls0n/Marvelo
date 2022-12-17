  //
 //  Created by Dan Carlson on 2022-12-14.
//

import UIKit
import Models

struct EventCellViewModel {
	var avatarImageUrl: String?
	var title: String
	var description: String
	var comicsCount: Int
    var characters: [Character]
    var favoriteList: FavoriteList
}
