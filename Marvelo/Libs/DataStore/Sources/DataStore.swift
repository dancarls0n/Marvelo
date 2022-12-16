//
//  DataStore.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public protocol DataStore {
    // MARK: external api for data consumption

    /// Get Characters. If you specify refetch, the update is delivered on `charactersStream`
    func getCharacters(refetch: Bool) -> [Character]

    /// Get Events. If you specify refetch, the update is delivered on `eventsStream`
    func getEvents(refetch: Bool) -> [Event]

    func getFavoritesList() -> FavoriteList

    // MARK: DataStore changes from UI
    func update(updatedCharacter: Character)
    func setFavorite(characterID: Int) async
    func reorderFavorites(favoriteList: FavoriteList)

    // MARK: API Fetches
    func fetchCharactersFromAPI() async
    func fetchEventsFromAPI() async

    // MARK: - AsyncStreams for subscribing to data changes
    func charactersStream() -> AsyncStream<[Character]>
    func eventsStream() -> AsyncStream<[Event]>
    func favoritesStream() -> AsyncStream<FavoriteList>
}
