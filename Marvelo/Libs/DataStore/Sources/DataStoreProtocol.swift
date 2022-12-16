//
//  DataStoreProtocol.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public protocol DataStoreProtocol {
    // MARK: external api for data consumption
    func getCharacters(refetch: Bool) async -> [Character]
    func getEvents(refetch: Bool) async -> [Event]
    func getFavoritesList() -> FavoriteList

    // MARK: DataStore changes from UI
    func update(updatedCharacter: Character)
    func setFavorite(characterID: Int) async
    func reorderFavorites(favoriteList: FavoriteList)

    // MARK: API Fetches
    func fetchCharactersFromAPI() async
    func fetchEventsFromAPI() async
}
