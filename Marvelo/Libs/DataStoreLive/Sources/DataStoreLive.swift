//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-15.
//

import Foundation

import APIClient
@_exported import DataStore
import Models
import NotificationClientLive
import Storage

extension DataStoreLive {
    public struct Dependencies {
        public var storage: Storage

        public init(storage: Storage) {
            self.storage = storage
        }
    }
}

public class DataStoreLive: DataStore {

    private var dependencies: Dependencies
    private var storage: Storage { dependencies.storage }

    private var charactersStreamContinuations: [UUID: AsyncStream<[Character]>.Continuation] = [:]
    private var eventsStreamContinuations: [UUID: AsyncStream<[Event]>.Continuation] = [:]
    private var favoriteStreamContinuations: [UUID: AsyncStream<FavoriteList>.Continuation] = [:]

	var favoriteList: FavoriteList = FavoriteList() {
		didSet {
			storage.save(favoriteList, for: .favorites)
			publish(favoriteList: favoriteList)
		}
	}
	var characters: [Character] = [] {
		didSet {
			storage.save(characters, for: .characters)
			//TODO: more inteligent stream for only changed characters?
            publish(characters: characters)
		}
	}
	var events: [Event] = [] {
		didSet {
			storage.save(events, for: .events)
            publish(events: events)
		}
	}

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies

		// fetch from storage
		if let favoriteList = storage.fetchFavorites() {
			self.favoriteList = favoriteList
		} else {
			storage.save(favoriteList, for: .favorites)
		}
		if let characters = storage.fetchCharacters() {
			self.characters = characters
		} else {
            storage.save(characters, for: .characters)
		}
		if let events = storage.fetchEvents() {
			self.events = events
		} else {
            storage.save(events, for: .events)
		}
		
		// update from api
		Task { await fetchCharactersFromAPI() }
		Task { await fetchEventsFromAPI() }
	}

    // MARK: - Async Streams
    private func publish(characters: [Character]) {
        charactersStreamContinuations.values.forEach { $0.yield(characters) }
    }

    private func publish(events: [Event]) {
        eventsStreamContinuations.values.forEach { $0.yield(events) }
    }

    private func publish(favoriteList: FavoriteList) {
        favoriteStreamContinuations.values.forEach { $0.yield(favoriteList) }
    }
	
	// MARK: - AsyncStreams for subscribing to data changes
	public var newCharacterStream: AsyncStream<Character>?
	//look at RTC-Observer
	public var characterStream: AsyncStream<Character>?
	public var eventStream: AsyncStream<Event>?
	public var favoriteStream: AsyncStream<FavoriteList>?
}


extension DataStoreLive {

    // MARK: - external api for data consumption

	public func getCharacters(refetch: Bool = false) -> [Character] {
        if refetch {
            Task { await fetchCharactersFromAPI() }
        }
        // Return persisted characters synchronously, ahead of refetch.
        return characters
	}
	
	public func getEvents(refetch: Bool = false) -> [Event] {
        if refetch {
            Task { await fetchEventsFromAPI() }
        }
        // Return persisted events synchronously, ahead of refetch.
        return events
	}
	
	public func getFavoritesList() -> FavoriteList {
		return favoriteList
	}

    // MARK: - DataStore changes from UI
	
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

    // MARK: - API Fetches

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

    // MARK: - AsyncStreams for subscribing to data changes

    public func charactersStream() -> AsyncStream<[Character]> {
        let continuationID = UUID()
        return AsyncStream { continuation in
            charactersStreamContinuations[continuationID] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.charactersStreamContinuations[continuationID] = nil
            }
        }
    }

    public func eventsStream() -> AsyncStream<[Event]> {
        let continuationID = UUID()
        return AsyncStream { continuation in
            eventsStreamContinuations[continuationID] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.eventsStreamContinuations[continuationID] = nil
            }
        }
    }

    public func favoritesStream() -> AsyncStream<FavoriteList> {
        let continuationID = UUID()
        return AsyncStream { continuation in
            favoriteStreamContinuations[continuationID] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.favoriteStreamContinuations[continuationID] = nil
            }
        }
    }
}
