  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation

import DataStore
import Models
import UIKit

@MainActor
public class CharactersViewModel: NSObject {
		
	// TODO: Bind to data layer to get updates upon character or favorites changes
	
	private var dataStore: DataStore
    private var charactersStreamTask: Task<Void, Never>?
	 
	init(dataStore: DataStore) {
		self.dataStore = dataStore
	}

    func startMonitoringDataStore() {
        // Subscribe for updates.
        charactersStreamTask = Task {
            for await updatedCharacters in dataStore.charactersStream() {
                modelizeCharacters(characters: updatedCharacters)
            }
        }

        // Get the persisted characters
        let characters = dataStore.getCharacters(refetch: false)
        modelizeCharacters(characters: characters)
    }

    func stopMonitoringDataStore() {
        charactersStreamTask?.cancel()
        charactersStreamTask = nil
    }

	var reloadTableView: (() -> Void)?
	
	// Fetched from DataStore
	var characters: [Character] = []
	var favoritesList: FavoriteList = FavoriteList()
	
	var characterCellViewModels = [CharacterCellViewModel]() {
		didSet {
			reloadTableView?()
		}
	}

	func modelizeCharacters(characters: [Character]) {
		self.characters = characters
		var vms = [CharacterCellViewModel]()
		for character in characters {
			vms.append(createCellModel(character: character, favorites: favoritesList))
		}
		characterCellViewModels = vms
	}
	
	func favoriteCharacter(id: Int?) {
		guard let characterID = id else { return }
		Task {
			await dataStore.setFavorite(characterID: characterID)
		}
	}
	
	func createCellModel(character: Character, favorites: FavoriteList) -> CharacterCellViewModel {
		let name = character.name ?? ""
		let description = character.description ?? ""
		let storyCount: Int = character.stories?.items?.count ?? 0
		let stories = "\(storyCount) stories"
		let date = character.modified ?? ""
		let characterInFavorites = favoritesList.favorites.contains(where: { $0.characterID == character.id })
		let starImage: UIImage = characterInFavorites ? UIImage(systemName: "star.filled")! : UIImage(systemName: "star")!
		
        return CharacterCellViewModel(avatarURL: character.avatarURL,
                                      name: name,
                                      description: description,
                                      stories: stories,
                                      date: date,
                                      starImage: starImage,
                                      setFavorite: { [weak self] in self?.favoriteCharacter(id: character.id) })
        
	}
	
	func getCellViewModel(at indexPath: IndexPath) -> CharacterCellViewModel {
		return characterCellViewModels[indexPath.row]
	}
}
