//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-15.
//

import Foundation

import APIClient
import Models
import Notifications
import Storage

// Improvement:
// Define protocol (interaction functions)
// Live one is this class
// Pass in mock for testing

// source of values for entire application
public var store = DataStore()

public class DataStore {
	
	var favoriteList: FavoriteList = FavoriteList() {
		didSet {
			Storage.save(favoriteList, for: .favorites)
			//TODO: publish to asyncStream for Favorites
			//TODO: publish to asyncStream for Characters
		}
	}
	var characters: [Character] = [] {
		didSet {
			Storage.save(characters, for: .characters)
			//TODO: publish to asyncStream for Characters
			//TODO: more inteligent stream for only changed characters?
		}
	}
	var events: [Event] = [] {
		didSet {
			Storage.save(events, for: .events)
			//TODO: publish to asyncStream for Events
		}
	}
	
	init () {
		// fetch from storage
		if let favoriteList = Storage.fetchFavorites() {
			self.favoriteList = favoriteList
		} else {
			Storage.save(favoriteList, for: .favorites)
		}
		if let characters = Storage.fetchCharacters() {
			self.characters = characters
		} else {
			Storage.save(characters, for: .characters)
		}
		if let events = Storage.fetchEvents() {
			self.events = events
		} else {
			Storage.save(events, for: .events)
		}
		
		// update from api
		Task { await fetchCharactersFromAPI() }
		Task { await fetchEventsFromAPI() }
	}
	
	// MARK: - AsyncStreams for subscribing to data changes
	public var newCharacterStream: AsyncStream<Character>?
	//look at RTC-Observer
	public var characterStream: AsyncStream<Character>?
	public var eventStream: AsyncStream<Event>?
	public var favoriteStream: AsyncStream<FavoriteList>?
}

// MARK: - external api for data consumption
extension DataStore {

	public func getCharacters(refetch: Bool = false) async -> [Character] {
		guard refetch else { return characters }
		await fetchCharactersFromAPI()
		return characters
	}
	
	public func getEvents(refetch: Bool = false) async -> [Event] {
		guard refetch else { return events }
		await fetchEventsFromAPI()
		return events
	}
	
	public func getFavoritesList() -> FavoriteList {
		return favoriteList
	}
}

// MARK: - DataStore changes from UI
extension DataStore {
	
	public func update(updatedCharacter: Character) {
		// new character
		guard let existingCharacter = self.characters.first(where: { $0.id == updatedCharacter.id }) else {
			self.characters.append(updatedCharacter)
			//TODO: publish to newCharacterStream
			return
		}
	
		guard existingCharacter != updatedCharacter else { return }
		
		if let existingCharacterIndex = characters.firstIndex(of: existingCharacter) {
			characters[existingCharacterIndex] = updatedCharacter
		}
	}
	
	public func setFavorite(characterID: Int) async {
		if self.favoriteList.favorites.contains(where: { $0.characterID == characterID }) { return }
		else {
			self.favoriteList.favorites.append(Favorite(characterID: characterID))
		}
	}
	
	public func reorderFavorites(favoriteList: FavoriteList) {
		//TODO - only replace array if it's different
		self.favoriteList = favoriteList
	}
}


// MARK: - API Fetches

extension DataStore {

	public func fetchCharactersFromAPI() async {
			do {
				let characters = try await APIClient.fetchCharacters()
				// TODO - only replace array if it's different
				self.characters = characters
			} catch { }
	}
	
	public func fetchEventsFromAPI() async {
			do {
				let events = try await APIClient.fetchEvents()
				// TODO - only replace array if it's different
				self.events = events
			} catch {}
	}
	
}
