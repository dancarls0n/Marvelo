//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-15.
//

import Foundation

import DataStore
import Models
import UIKit

public class CharactersViewModel: NSObject {
		
	// TODO: Bind to data layer to get updates upon character or favorites changes
	
	private var dataStore: DataStore
	 
	init(dataStore: DataStore) {
		self.dataStore = dataStore
//		self.getCharactersFromDataStore()
		//subscribe to async streams from datastore
	}
	
	public func getCharactersFromDataStore() {
		Task {
			let characters = await dataStore.getCharacters()
			self.modelizeCharacters(characters: characters)
		}
	}
	
	//asyncStreamCallback
	// remodelize my characters
	// redraw the tableview (or the cells)

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
		let avatarUrl = character.thumbnail?.path
		let name = character.name ?? ""
		let description = character.description ?? ""
		let storyCount: Int = character.stories?.items?.count ?? 0
		let stories = "\(storyCount) stories"
		let date = character.modified ?? ""
		let characterInFavorites = favoritesList.favorites.contains(where: { $0.characterID == character.id })
		let starImage: UIImage = characterInFavorites ? UIImage(systemName: "star.filled")! : UIImage(systemName: "star")!
		
		return CharacterCellViewModel(avatarImageUrl: avatarUrl,
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
