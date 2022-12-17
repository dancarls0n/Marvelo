  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation

import DataStore
import Models
import UIKit

@MainActor
public class FavoritesViewModel: NSObject {
			
	private var dataStore: DataStore
    private var favoritesStreamTask: Task<Void, Never>?
	 
	init(dataStore: DataStore) {
		self.dataStore = dataStore
	}

    func startMonitoringDataStore() {
        // Subscribe for updates.
        favoritesStreamTask = Task {
            for await updatedFavorites in dataStore.favoritesStream() {
                //TODO: should we attach the characters to the favorites to make this more efficient?
                let characters = dataStore.getCharacters(refetch: false)
                modelizeFavorites(favoritesList: updatedFavorites, characters: characters)
            }
        }

        // Get the persisted favorites
        let favoritesList = dataStore.getFavoritesList()
        let characters = dataStore.getCharacters(refetch: false)
        modelizeFavorites(favoritesList: favoritesList, characters: characters)
    }

    func stopMonitoringDataStore() {
        favoritesStreamTask?.cancel()
        favoritesStreamTask = nil
    }

	var reloadTableView: (() -> Void)?
	
	// Fetched from DataStore
	var favoritesList: FavoriteList = FavoriteList()
    var characters: [Character] = []
	
	var favoriteCellViewModels = [FavoriteCellViewModel]() {
		didSet {
			reloadTableView?()
		}
	}

    func modelizeFavorites(favoritesList: FavoriteList, characters: [Character]) {
		self.favoritesList = favoritesList
        self.characters = characters
		var vms = [FavoriteCellViewModel]()
        for favorite in favoritesList.favorites {
            let character = characters.first(where: { $0.id == favorite.characterID })
			vms.append(createCellModel(character: character))
		}
		favoriteCellViewModels = vms
	}
	
    func createCellModel(character: Character?) -> FavoriteCellViewModel {
        let avatarUrl = character?.thumbnail?.path
		let name = character?.name ?? "?"
        
        return FavoriteCellViewModel(avatarImageUrl: avatarUrl,
                                  name: name)
	}
	
	func getCellViewModel(at indexPath: IndexPath) -> FavoriteCellViewModel {
		return favoriteCellViewModels[indexPath.row]
	}
}
