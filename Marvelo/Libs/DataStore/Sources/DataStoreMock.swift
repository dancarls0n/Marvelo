//
//  DataStoreMock.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public struct DataStoreMock {

    public var getCharactersClosure: (_ refetch: Bool) async -> [Character]
    public var getEventsClosure: (_ refetch: Bool) async -> [Event]
    public var getFavoritesListClosure: () -> FavoriteList


    public var updateClosure: (_ updatedCharacter: Character) -> Void
    public var setFavoriteClosure: (_ characterID: Int) async -> Void
    public var reorderFavoritesClosure: (_ favoriteList: FavoriteList) -> Void

    public var fetchCharactersFromAPIClosure: () async -> Void
    public var fetchEventsFromAPIClosure: () async -> Void
}

extension DataStoreMock: DataStore {

    public func getCharacters(refetch: Bool) async -> [Models.Character] {
        return await getCharactersClosure(refetch)
    }

    public func getEvents(refetch: Bool) async -> [Models.Event] {
       return await getEventsClosure(refetch)
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
}
