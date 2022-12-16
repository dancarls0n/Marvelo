//
//  DataStoreMock.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public struct DataStoreMock {

    public var getCharactersClosure: (_ refetch: Bool) -> [Character]
    public var getEventsClosure: (_ refetch: Bool) -> [Event]
    public var getFavoritesListClosure: () -> FavoriteList

    public var updateClosure: (_ updatedCharacter: Character) -> Void
    public var setFavoriteClosure: (_ characterID: Int) async -> Void
    public var reorderFavoritesClosure: (_ favoriteList: FavoriteList) -> Void

    public var fetchCharactersFromAPIClosure: () async -> Void
    public var fetchEventsFromAPIClosure: () async -> Void

    public var charactersStreamClosure: () -> AsyncStream<[Character]>
    public var eventsStreamClosure: () -> AsyncStream<[Event]>
    public var favoritesStreamClosure: () -> AsyncStream<FavoriteList>
}

extension DataStoreMock: DataStore {

    public func getCharacters(refetch: Bool) -> [Models.Character] {
        return getCharactersClosure(refetch)
    }

    public func getEvents(refetch: Bool) -> [Models.Event] {
       return getEventsClosure(refetch)
    }

    public func getFavoritesList() -> Models.FavoriteList {
        return getFavoritesListClosure()
    }

    public func update(updatedCharacter: Models.Character) {
        return updateClosure(updatedCharacter)
    }

    public func setFavorite(characterID: Int) async {
        return await setFavoriteClosure(characterID)
    }

    public func reorderFavorites(favoriteList: Models.FavoriteList) {
        return reorderFavoritesClosure(favoriteList)
    }

    public func fetchCharactersFromAPI() async {
        return await fetchEventsFromAPIClosure()
    }

    public func fetchEventsFromAPI() async {
        return await fetchEventsFromAPIClosure()
    }

    public func charactersStream() -> AsyncStream<[Character]> {
        return charactersStreamClosure()
    }

    public func eventsStream() -> AsyncStream<[Event]> {
        return eventsStreamClosure()
    }

    public func favoritesStream() -> AsyncStream<FavoriteList> {
        return favoritesStreamClosure()
    }
}
